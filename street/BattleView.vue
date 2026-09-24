<template>
  <div
    class="battle"
    :style="{ '--aura': playerSpec.cssAura, '--oppAura': oppSpec.cssAura }"
    @contextmenu.prevent
  >
    <!-- 3D 对战舞台 -->
    <BattleStage :engine="engine" :paused="paused" />

    <!-- 顶部 HUD -->
    <div class="hud">
      <div class="hud__side hud__side--p">
        <div class="hud__name">{{ playerName }}</div>
        <div class="hud__char">{{ playerSpec.cn }} · {{ playerSpec.name }}</div>
        <div class="bar bar--hp"><i :style="{ width: hp0 + '%' }"></i></div>
        <div class="bar bar--meter"><i :style="{ width: meter0 + '%' }"></i></div>
        <div class="pips">
          <span v-for="n in 2" :key="n" :class="{ on: wins0 >= n }"></span>
        </div>
      </div>

      <div class="hud__center">
        <div class="timer">{{ String(timeLeft).padStart(2, '0') }}</div>
        <div class="round">ROUND {{ round }}</div>
      </div>

      <div class="hud__side hud__side--o">
        <div class="hud__name">{{ oppName }}</div>
        <div class="hud__char">{{ oppSpec.cn }} · {{ oppSpec.name }}</div>
        <div class="bar bar--hp bar--hp-r"><i :style="{ width: hp1 + '%' }"></i></div>
        <div class="bar bar--meter bar--meter-r"><i :style="{ width: meter1 + '%' }"></i></div>
        <div class="pips pips--r">
          <span v-for="n in 2" :key="n" :class="{ on: wins1 >= n }"></span>
        </div>
      </div>
    </div>

    <!-- 回合 / K.O. 横幅 -->
    <transition name="banner">
      <div
        v-if="banner"
        class="banner"
        :class="{
          'banner--win': banner === 'YOU WIN',
          'banner--lose': banner === 'YOU LOSE',
          'banner--draw': banner === 'DRAW'
        }"
      >
        {{ banner }}
      </div>
    </transition>

    <!-- 连击 -->
    <transition name="combo">
      <div v-if="combo >= 2" class="combo">{{ combo }}<small>HITS</small></div>
    </transition>

    <!-- 暂停按钮 -->
    <button class="topbtn" :disabled="phase === 'matchOver'" @click="togglePause">⏸</button>

    <!-- 操作区 -->
    <div class="controls">
      <div class="controls__dpad">
        <button class="kb kb--wide" @pointerdown.prevent="btnDown('left')" @pointerup.prevent="btnUp('left')" @pointerleave.prevent="btnUp('left')" @pointercancel.prevent="btnUp('left')">◀</button>
        <button class="kb kb--jump" @pointerdown.prevent="btnDown('up')" @pointerup.prevent="btnUp('up')" @pointerleave.prevent="btnUp('up')" @pointercancel.prevent="btnUp('up')">跳 ↑</button>
        <button class="kb kb--wide" @pointerdown.prevent="btnDown('right')" @pointerup.prevent="btnUp('right')" @pointerleave.prevent="btnUp('right')" @pointercancel.prevent="btnUp('right')">▶</button>
      </div>

      <div class="controls__actions">
        <button class="kb kb--block" @pointerdown.prevent="btnDown('block')" @pointerup.prevent="btnUp('block')" @pointerleave.prevent="btnUp('block')" @pointercancel.prevent="btnUp('block')">防<br><i>S</i></button>
        <button class="kb kb--light" @pointerdown.prevent="btnDown('light')" @pointerup.prevent="btnUp('light')" @pointerleave.prevent="btnUp('light')" @pointercancel.prevent="btnUp('light')">轻拳<br><i>J</i></button>
        <button class="kb kb--heavy" @pointerdown.prevent="btnDown('heavy')" @pointerup.prevent="btnUp('heavy')" @pointerleave.prevent="btnUp('heavy')" @pointercancel.prevent="btnUp('heavy')">重拳<br><i>K</i></button>
        <button class="kb kb--kick" @pointerdown.prevent="btnDown('kick')" @pointerup.prevent="btnUp('kick')" @pointerleave.prevent="btnUp('kick')" @pointercancel.prevent="btnUp('kick')">踢腿<br><i>L</i></button>
        <button class="kb kb--super" :class="{ ready: superReady }" :disabled="!superReady" @pointerdown.prevent="btnDown('super')" @pointerup.prevent="btnUp('super')" @pointerleave.prevent="btnUp('super')" @pointercancel.prevent="btnUp('super')">必杀<br><i>U</i></button>
      </div>
    </div>

    <p class="hint">移动 <b>A/D</b> · 跳 <b>W</b> · 防 <b>S</b> · 轻拳 <b>J</b> · 重拳 <b>K</b> · 踢腿 <b>L</b> · 必杀 <b>U</b>（气满）</p>

    <!-- 结算 -->
    <transition name="overlay">
      <div v-if="showResult" class="overlay">
        <div class="overlay__box">
          <h2 class="result" :class="resultWon ? 'win' : 'lose'">
            {{ resultWon ? 'YOU WIN!' : 'YOU LOSE' }}
          </h2>
          <p class="result__sub">
            {{ resultWon ? '漂亮的胜利！奖励已发放 🪙' : '再接再厉，下一场翻盘！' }}
          </p>
          <div class="overlay__btns">
            <button class="btn-ghost" @click="toLobby">返回大厅</button>
            <button class="btn-primary" @click="rematch">再战 REMATCH</button>
          </div>
        </div>
      </div>
    </transition>

    <!-- 暂停 -->
    <transition name="overlay">
      <div v-if="paused && !showResult" class="overlay">
        <div class="overlay__box">
          <h2 class="result">PAUSED</h2>
          <p class="result__sub">暂停中 · 对手也在等你</p>
          <div class="overlay__btns">
            <button class="btn-ghost" @click="toLobby">退出对战</button>
            <button class="btn-primary" @click="togglePause">继续 RESUME</button>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import BattleStage from '../components/BattleStage.vue'
import { createBattle } from '../battle/engine.js'
import { ROSTER, getCharacter } from '../three/roster.js'
import { player, addCoins, persist } from '../store/player.js'
import { sfx } from '../utils/arcadeAudio.js'
import { playFight } from '../composables/useFight.js'

const route = useRoute()
const router = useRouter()

/* ------------------------------ 引擎参数 ------------------------------ */
const playerSpec = getCharacter(player.fighterId)
const playerName = computed(() => player.account || 'PLAYER').value

const oppId = (() => {
  const q = route.query.opp
  if (typeof q === 'string' && ROSTER.some((c) => c.id === q)) return q
  const pool = ROSTER.filter((c) => c.id !== player.fighterId)
  return pool[Math.floor(Math.random() * pool.length)].id
})()
const oppSpec = getCharacter(oppId)
const oppName = typeof route.query.oppname === 'string' && route.query.oppname ? route.query.oppname : oppSpec.name
const modeName = typeof route.query.mode === 'string' && route.query.mode ? route.query.mode : 'VS ONLINE'
const difficulty = ['easy', 'normal', 'hard'].includes(route.query.diff) ? route.query.diff : 'normal'

const engine = createBattle({
  playerSpec,
  oppSpec,
  playerName,
  oppName,
  difficulty
})

/* ------------------------------ HUD 状态 ------------------------------ */
const hp0 = ref(100)
const hp1 = ref(100)
const meter0 = ref(0)
const meter1 = ref(0)
const timeLeft = ref(60)
const round = ref(1)
const wins0 = ref(0)
const wins1 = ref(0)
const phase = ref('intro')
const combo = ref(0)
const banner = ref('')
const superReady = computed(() => meter0.value >= 100)

let ended = false
let rafId = 0

function tickHud() {
  rafId = requestAnimationFrame(tickHud)
  const s = engine.state
  hp0.value = s.fighters[0] ? s.fighters[0].hp : 100
  hp1.value = s.fighters[1] ? s.fighters[1].hp : 100
  meter0.value = s.fighters[0] ? s.fighters[0].meter : 0
  meter1.value = s.fighters[1] ? s.fighters[1].meter : 0
  timeLeft.value = Math.max(0, Math.ceil(s.time))
  round.value = s.round
  wins0.value = s.wins[0]
  wins1.value = s.wins[1]
  phase.value = s.phase
  combo.value = s.combo >= 2 && s.comboOwner === 0 ? s.combo : 0

  if (s.phase === 'intro') banner.value = 'ROUND ' + s.round
  else if (s.phase === 'roundOver')
    banner.value = s.lastRoundWinner === -1 ? 'DRAW' : s.lastRoundWinner === 0 ? 'YOU WIN' : 'YOU LOSE'
  else banner.value = ''

  if (s.phase === 'matchOver' && !ended) {
    ended = true
    finishMatch()
  }
}

/* ------------------------------ 结算 ------------------------------ */
const showResult = ref(false)
const resultWon = ref(false)

function finishMatch() {
  const won = engine.state.winner === 0
  resultWon.value = won
  if (won) {
    player.wins += 1
    addCoins(150)
    player.exp = Math.min(100, player.exp + 10)
    sfx.coin()
  } else {
    player.losses += 1
    player.exp = Math.min(100, player.exp + 4)
    sfx.error()
  }
  persist()
  showResult.value = true
  paused.value = true
}

function rematch() {
  ended = false
  showResult.value = false
  paused.value = false
  engine.reset()
  sfx.fight()
  playFight({
    player: playerName,
    opponent: oppName,
    subtitle: `${modeName} · 重赛`,
    duration: 1300
  })
}

function toLobby() {
  sfx.click()
  router.push({ name: 'lobby' })
}

/* ------------------------------ 暂停 ------------------------------ */
const paused = ref(false)
function togglePause() {
  if (phase.value === 'matchOver') return
  paused.value = !paused.value
  sfx.click()
}

/* ------------------------------ 操作输入 ------------------------------ */
const GROUPS = {
  light: ['j', 'J'],
  heavy: ['k', 'K'],
  kick: ['l', 'L'],
  super: ['u', 'U', 'i', 'I'],
  left: ['arrowleft', 'a', 'A'],
  right: ['arrowright', 'd', 'D'],
  up: ['arrowup', 'w', 'W'],
  block: ['arrowdown', 's', 'S', 'ShiftLeft', 'ShiftRight']
}
const ATTACKS = new Set(['light', 'heavy', 'kick', 'super'])

function nameFor(code, key) {
  const k = key.length === 1 ? key : code
  for (const name in GROUPS) {
    if (GROUPS[name].includes(k)) return name
  }
  return null
}

function onKeyDown(e) {
  if (e.key === 'Escape') {
    togglePause()
    return
  }
  const name = nameFor(e.code, e.key)
  if (!name) return
  if (['arrowleft', 'arrowright', 'arrowup', 'arrowdown', ' '].includes(e.key.toLowerCase?.() || e.key)) e.preventDefault()
  if (e.key.toLowerCase() === ' ') e.preventDefault()
  if (ATTACKS.has(name)) {
    if (e.repeat) return
    engine.attack(name)
    sfx.click()
  } else {
    engine.press(name)
  }
}

function onKeyUp(e) {
  const name = nameFor(e.code, e.key)
  if (!name || ATTACKS.has(name)) return
  engine.release(name)
}

/* 触屏 / 鼠标 */
function btnDown(name) {
  if (ATTACKS.has(name)) {
    engine.attack(name)
    sfx.click()
  } else {
    engine.press(name)
  }
}
function btnUp(name) {
  if (!ATTACKS.has(name)) engine.release(name)
}

/* ------------------------------ 生命周期 ------------------------------ */
onMounted(() => {
  window.addEventListener('keydown', onKeyDown)
  window.addEventListener('keyup', onKeyUp)
  tickHud()
  sfx.fight()
  playFight({
    player: playerName,
    opponent: oppName,
    subtitle: `${modeName} · ${playerSpec.cn}${playerSpec.name} VS ${oppSpec.cn}${oppSpec.name}`,
    duration: 1300
  })
})

onBeforeUnmount(() => {
  window.removeEventListener('keydown', onKeyDown)
  window.removeEventListener('keyup', onKeyUp)
  cancelAnimationFrame(rafId)
})
</script>

<style scoped>
.battle {
  position: fixed;
  inset: 0;
  z-index: 2;
  overflow: hidden;
  touch-action: none;
  background: #05060c;
}

/* ------------------------------ HUD ------------------------------ */
.hud {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  z-index: 5;
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  gap: 14px;
  padding: 16px clamp(14px, 4vw, 44px) 0;
  pointer-events: none;
}
.hud__side {
  display: flex;
  flex-direction: column;
  gap: 5px;
}
.hud__side--o {
  align-items: flex-end;
  text-align: right;
}
.hud__name {
  font-size: 13px;
  font-weight: 800;
  letter-spacing: 0.12em;
  color: #fff;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.7);
}
.hud__char {
  font-size: 10px;
  letter-spacing: 0.16em;
  color: rgba(226, 232, 255, 0.6);
}
.bar {
  width: min(38vw, 420px);
  height: 13px;
  border-radius: 4px;
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.16);
  overflow: hidden;
}
.bar--hp {
  height: 16px;
  box-shadow: inset 0 0 0 1px rgba(0, 0, 0, 0.35);
}
.bar--hp i {
  display: block;
  height: 100%;
  border-radius: 3px;
  background: linear-gradient(90deg, color-mix(in srgb, var(--aura) 60%, #000 40%), var(--aura));
  box-shadow: 0 0 12px var(--aura);
  transition: width 0.18s linear;
}
.bar--hp-r i {
  margin-left: auto;
  background: linear-gradient(90deg, var(--oppAura), color-mix(in srgb, var(--oppAura) 60%, #000 40%));
  box-shadow: 0 0 12px var(--oppAura);
}
.bar--meter {
  height: 7px;
}
.bar--meter i {
  display: block;
  height: 100%;
  background: linear-gradient(90deg, #ffd35c, #ff7a1f);
  box-shadow: 0 0 10px rgba(255, 170, 60, 0.8);
  transition: width 0.18s linear;
}
.bar--meter-r i {
  margin-left: auto;
}
.bar--meter.full i {
  animation: meterFull 0.7s infinite;
}
@keyframes meterFull {
  50% {
    opacity: 0.6;
  }
}
.pips {
  display: flex;
  gap: 6px;
  margin-top: 2px;
}
.pips span {
  width: 16px;
  height: 7px;
  border-radius: 3px;
  background: rgba(255, 255, 255, 0.18);
}
.pips span.on {
  background: var(--aura);
  box-shadow: 0 0 8px var(--aura);
}
.pips--r {
  justify-content: flex-end;
}
.pips--r span.on {
  background: var(--oppAura);
  box-shadow: 0 0 8px var(--oppAura);
}
.hud__center {
  text-align: center;
  padding-top: 2px;
}
.timer {
  font-size: clamp(30px, 5vw, 46px);
  font-weight: 900;
  font-style: italic;
  line-height: 1;
  color: #fff;
  text-shadow: 0 0 18px rgba(255, 255, 255, 0.4);
  font-variant-numeric: tabular-nums;
}
.round {
  margin-top: 4px;
  font-size: 10px;
  letter-spacing: 0.3em;
  color: rgba(226, 232, 255, 0.6);
}

/* 横幅 */
.banner {
  position: absolute;
  top: 34%;
  left: 0;
  right: 0;
  text-align: center;
  z-index: 6;
  pointer-events: none;
  font-size: clamp(34px, 8vw, 86px);
  font-weight: 900;
  font-style: italic;
  letter-spacing: 0.04em;
  color: #fff;
  text-shadow: 0 0 30px rgba(255, 95, 31, 0.7);
}
.banner--win {
  color: #4dffa5;
  text-shadow: 0 0 34px rgba(77, 255, 165, 0.8);
}
.banner--lose {
  color: #ff6a6a;
  text-shadow: 0 0 34px rgba(255, 90, 90, 0.8);
}
.banner--draw {
  color: #ffd35c;
}
.banner-enter-active {
  animation: bannerIn 0.4s cubic-bezier(0.22, 1, 0.36, 1);
}
.banner-leave-active {
  transition: opacity 0.3s;
}
.banner-leave-to {
  opacity: 0;
}
@keyframes bannerIn {
  from {
    opacity: 0;
    transform: scale(1.7) skewX(-6deg);
    filter: blur(6px);
  }
}

/* 连击 */
.combo {
  position: absolute;
  top: 46%;
  left: clamp(16px, 5vw, 60px);
  z-index: 6;
  pointer-events: none;
  font-size: clamp(26px, 5vw, 52px);
  font-weight: 900;
  font-style: italic;
  color: #ffd35c;
  text-shadow: 0 0 22px rgba(255, 170, 40, 0.9);
  line-height: 0.9;
}
.combo small {
  display: block;
  font-size: 0.32em;
  letter-spacing: 0.4em;
  color: #fff;
}
.combo-enter-active {
  animation: comboPop 0.25s ease-out;
}
.combo-leave-active {
  transition: opacity 0.3s;
}
.combo-leave-to {
  opacity: 0;
}
@keyframes comboPop {
  from {
    transform: scale(1.5) rotate(-6deg);
  }
}

/* 暂停键 */
.topbtn {
  position: absolute;
  top: 16px;
  left: 50%;
  transform: translateX(-50%);
  display: none;
}

/* ------------------------------ 操作 ------------------------------ */
.controls {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 5;
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 18px;
  padding: 14px clamp(14px, 4vw, 40px) 18px;
}
.controls__dpad {
  display: grid;
  grid-template-columns: repeat(3, 56px);
  grid-template-rows: 56px 56px;
  gap: 8px;
}
.kb--jump {
  grid-column: 2;
  grid-row: 1;
}
.kb--wide:nth-of-type(1) {
  grid-column: 1;
  grid-row: 2;
}
.kb--wide:nth-of-type(2) {
  grid-column: 3;
  grid-row: 2;
}
.controls__actions {
  display: grid;
  grid-template-columns: repeat(5, 58px);
  gap: 8px;
}
.kb {
  height: 56px;
  border-radius: 14px;
  border: 1px solid rgba(255, 255, 255, 0.18);
  background: linear-gradient(180deg, rgba(28, 32, 48, 0.92), rgba(10, 12, 22, 0.94));
  color: #eef2ff;
  font-family: inherit;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.04em;
  cursor: pointer;
  user-select: none;
  -webkit-user-select: none;
  touch-action: none;
  box-shadow: 0 6px 16px -8px #000;
  transition: transform 0.08s, box-shadow 0.12s, background 0.12s;
}
.kb i {
  display: block;
  font-style: normal;
  font-size: 9px;
  font-weight: 600;
  letter-spacing: 0.1em;
  opacity: 0.6;
  margin-top: 2px;
}
.kb:active {
  transform: translateY(2px) scale(0.97);
  box-shadow: 0 2px 8px -6px #000;
}
.kb--block {
  border-color: rgba(120, 200, 255, 0.5);
}
.kb--light {
  border-color: color-mix(in srgb, var(--aura) 60%, transparent);
}
.kb--heavy {
  border-color: color-mix(in srgb, var(--aura) 80%, transparent);
  background: linear-gradient(180deg, color-mix(in srgb, var(--aura) 30%, rgba(20, 24, 38, 0.94)), rgba(10, 12, 22, 0.94));
}
.kb--kick {
  border-color: rgba(255, 211, 92, 0.55);
}
.kb--super {
  border-color: rgba(255, 120, 40, 0.5);
  opacity: 0.45;
  filter: grayscale(0.4);
}
.kb--super.ready {
  opacity: 1;
  filter: none;
  border-color: #ffb347;
  background: linear-gradient(180deg, rgba(255, 150, 50, 0.4), rgba(20, 12, 8, 0.94));
  box-shadow: 0 0 18px -4px rgba(255, 150, 50, 0.8);
  animation: superReady 0.9s infinite;
}
@keyframes superReady {
  50% {
    box-shadow: 0 0 26px -2px rgba(255, 170, 60, 1);
  }
}
.kb:disabled {
  cursor: not-allowed;
}

.hint {
  position: absolute;
  bottom: 150px;
  left: 0;
  right: 0;
  text-align: center;
  z-index: 4;
  margin: 0;
  font-size: 11px;
  letter-spacing: 0.06em;
  color: rgba(226, 232, 255, 0.45);
  pointer-events: none;
}
.hint b {
  color: rgba(238, 242, 255, 0.8);
  background: rgba(255, 255, 255, 0.08);
  padding: 1px 5px;
  border-radius: 4px;
  margin: 0 2px;
}

/* ------------------------------ 结算 / 暂停 ------------------------------ */
.overlay {
  position: fixed;
  inset: 0;
  z-index: 40;
  display: grid;
  place-items: center;
  background: rgba(3, 4, 9, 0.74);
  backdrop-filter: blur(7px);
  padding: 20px;
}
.overlay__box {
  width: min(420px, 92vw);
  padding: 30px 26px 24px;
  border-radius: 20px;
  border: 1px solid color-mix(in srgb, var(--aura) 40%, transparent);
  background: linear-gradient(160deg, rgba(20, 23, 36, 0.97), rgba(8, 9, 16, 0.98));
  box-shadow: 0 40px 90px -30px #000, 0 0 60px -26px var(--aura);
  text-align: center;
}
.result {
  margin: 0 0 6px;
  font-size: clamp(34px, 8vw, 56px);
  font-weight: 900;
  font-style: italic;
  letter-spacing: 0.04em;
  background: linear-gradient(180deg, #fff, #ffd35c 55%, #ff5f1f);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  filter: drop-shadow(0 6px 20px rgba(255, 120, 40, 0.6));
}
.result.lose {
  background: linear-gradient(180deg, #fff, #ff8a8a 55%, #b81f1f);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  filter: drop-shadow(0 6px 20px rgba(255, 80, 80, 0.6));
}
.result__sub {
  margin: 0 0 20px;
  font-size: 12.5px;
  letter-spacing: 0.08em;
  color: rgba(226, 232, 255, 0.6);
}
.overlay__btns {
  display: flex;
  gap: 10px;
  justify-content: center;
}
.overlay__btns .btn-ghost,
.overlay__btns .btn-primary {
  flex: 1;
}
.btn-ghost {
  padding: 11px 16px;
  border-radius: 11px;
  border: 1px solid rgba(255, 255, 255, 0.16);
  background: rgba(255, 255, 255, 0.05);
  color: rgba(238, 242, 255, 0.85);
  font-family: inherit;
  font-size: 12.5px;
  letter-spacing: 0.12em;
  cursor: pointer;
  transition: all 0.18s;
}
.btn-ghost:hover {
  background: rgba(255, 255, 255, 0.1);
}
.btn-primary {
  padding: 11px 16px;
  border-radius: 11px;
  border: 0;
  background: linear-gradient(180deg, #ffd35c 0%, #ff9d2e 45%, #f2601f 100%);
  color: #2a1002;
  font-family: inherit;
  font-size: 13px;
  font-weight: 900;
  letter-spacing: 0.14em;
  cursor: pointer;
  box-shadow: 0 12px 28px -12px rgba(255, 138, 30, 0.9);
  transition: all 0.18s;
}
.btn-primary:hover {
  transform: translateY(-2px);
}

.overlay-enter-active,
.overlay-leave-active {
  transition: opacity 0.25s;
}
.overlay-enter-from,
.overlay-leave-to {
  opacity: 0;
}

/* ------------------------------ 响应式 ------------------------------ */
@media (max-width: 560px) {
  .controls__dpad {
    grid-template-columns: repeat(3, 50px);
  }
  .controls__actions {
    grid-template-columns: repeat(5, 52px);
  }
  .kb {
    height: 52px;
    font-size: 11px;
  }
  .hint {
    bottom: 140px;
    font-size: 10px;
  }
}
</style>
