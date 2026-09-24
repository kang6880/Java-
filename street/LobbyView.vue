<template>
  <div class="lobby">
    <!-- 顶部导航 -->
    <header class="nav">
      <div class="nav__left">
        <span class="nav__mark">STREET FIGHTER</span>
        <span class="nav__sep">/</span>
        <span class="nav__where">PLAYER LOBBY</span>
      </div>
      <div class="nav__right">
        <button class="nav__btn" :aria-pressed="muted" @click="toggleMute">
          {{ muted ? '音效 关' : '音效 开' }}
        </button>
        <button class="nav__btn nav__btn--out" @click="onLogout">退出登录</button>
      </div>
    </header>

    <main class="main">
      <!-- 左：玩家 / 模式 / 任务 -->
      <div class="col col--side">
        <!-- 玩家卡 -->
        <section class="card card--player">
          <div class="pcard">
            <div class="pcard__avatar" :style="{ background: character.cssAura }">
              {{ (player.account || 'P').slice(0, 1).toUpperCase() }}
            </div>
            <div class="pcard__info">
              <p class="pcard__name">
                {{ player.account }}
                <span v-if="player.guest" class="pcard__guest">游客</span>
              </p>
              <p class="pcard__level">
                LV.<strong>{{ player.level }}</strong>
                <span class="pcard__expbar"><i :style="{ width: player.exp + '%' }"></i></span>
              </p>
            </div>
          </div>
          <div class="pcard__nums">
            <div class="num">
              <em>金币</em>
              <strong>🪙 {{ player.coins.toLocaleString() }}</strong>
            </div>
            <div class="num">
              <em>战绩</em>
              <strong>{{ player.wins }}胜 / {{ player.losses }}负</strong>
            </div>
            <div class="num">
              <em>胜率</em>
              <strong>{{ winRate }}%</strong>
            </div>
          </div>
        </section>

        <!-- 模式选择 -->
        <section class="card">
          <h3 class="card__title">CHOOSE MODE <span>选择模式</span></h3>
          <div class="modes">
            <button
              v-for="m in modes"
              :key="m.id"
              class="mode"
              :class="{ 'is-hot': m.hot }"
              @click="startMode(m)"
              @mouseenter="sfx.hover()"
            >
              <span class="mode__icon" v-html="m.icon"></span>
              <span class="mode__text">
                <strong>{{ m.name }}<i>{{ m.en }}</i></strong>
                <small>{{ m.desc }}</small>
              </span>
              <span v-if="m.hot" class="mode__badge">推荐</span>
            </button>
          </div>
        </section>

        <!-- 每日任务 -->
        <section class="card">
          <h3 class="card__title">DAILY QUEST <span>每日任务</span></h3>
          <ul class="quests">
            <li v-for="q in quests" :key="q.name" class="quest">
              <span class="quest__name">{{ q.name }}</span>
              <span class="quest__bar"><i :style="{ width: (q.done / q.need) * 100 + '%' }"></i></span>
              <span class="quest__num" :class="{ 'is-done': q.done >= q.need }">
                {{ q.done >= q.need ? '已领取' : `${q.done}/${q.need}` }}
              </span>
            </li>
          </ul>
        </section>
      </div>

      <!-- 右：3D 舞台 + 选人 -->
      <div class="col col--stage">
        <div class="stage-wrap">
          <div class="stage-wrap__hud">
            <span class="tag tag--live"><i></i>LIVE 3D</span>
            <span class="tag">{{ character.country }} {{ character.flag }}</span>
          </div>

          <FighterStage :character-id="characterId" />

          <div class="nameplate">
            <p class="nameplate__cn">{{ character.cn }}</p>
            <h2 class="nameplate__en">{{ character.name }}</h2>
            <p class="nameplate__title">{{ character.title }}</p>
            <p class="nameplate__special"><span>必杀</span>{{ character.special }}</p>
          </div>

          <div class="stats">
            <div v-for="s in statRows" :key="s.key" class="stats__row">
              <span class="stats__label">{{ s.label }}</span>
              <span class="stats__bar"><i :style="{ width: s.value + '%' }"></i></span>
              <span class="stats__num">{{ s.value }}</span>
            </div>
          </div>
        </div>

        <div class="picker">
          <div class="picker__head">
            <span>CHANGE FIGHTER</span>
            <small>出战角色即时切换 · 按 1-4 快速选择</small>
          </div>
          <CharacterSelect v-model="characterId" :roster="roster" />
        </div>
      </div>
    </main>

    <!-- 底部滚动公告 -->
    <footer class="foot">
      <span class="foot__label">公告</span>
      <div class="foot__marquee">
        <div class="foot__track">
          <span v-for="n in 2" :key="n">
            🏆 本周街机模式冠军：SPINAL·07（8120 分） &nbsp;·&nbsp;
            🎁 每日签到已开启，连续 7 天可领取限定头带 &nbsp;·&nbsp;
            ⚔️ 新角色「豪鬼」已加入选人列表 &nbsp;·&nbsp;
            🎮 对战已实装：A/D 移动 · J/K/L 出招 · U 放必杀 &nbsp;·&nbsp;
          </span>
        </div>
      </div>
    </footer>

    <!-- 匹配中 / 匹配成功 -->
    <transition name="modal">
      <div v-if="match.state !== 'idle'" class="modal" @click.self="cancelMatch">
        <div class="modal__box">
          <template v-if="match.state === 'searching'">
            <div class="radar">
              <span class="radar__ring"></span>
              <span class="radar__ring radar__ring--2"></span>
              <span class="radar__core"></span>
            </div>
            <h3 class="modal__title">{{ match.mode.name }} · 正在匹配对手</h3>
            <p class="modal__sub">MATCHING&nbsp;&nbsp;PLEASE&nbsp;&nbsp;WAIT</p>
            <button class="btn-ghost" @click="cancelMatch">取消匹配</button>
          </template>

          <template v-else>
            <p class="modal__found">MATCH FOUND · 已找到对手</p>
            <div class="versus">
              <div class="versus__side">
                <span class="versus__pic" :style="{ color: character.cssAura }">
                  <svg viewBox="0 0 40 56"><circle cx="20" cy="9" r="7" /><path d="M20 17c-7 0-11 4-11 10v9h5l1 20h10l1-20h5v-9c0-6-4-10-11-10Z" /><path d="M9 27 3 38l3 2 7-10ZM31 27l6 11-3 2-7-10Z" /></svg>
                </span>
                <strong>{{ player.account }}</strong>
                <small>{{ character.cn }} · LV.{{ player.level }}</small>
              </div>
              <span class="versus__vs">VS</span>
              <div class="versus__side versus__side--rival">
                <span class="versus__pic" :style="{ color: opponent.char.cssAura }">
                  <svg viewBox="0 0 40 56"><circle cx="20" cy="9" r="7" /><path d="M20 17c-7 0-11 4-11 10v9h5l1 20h10l1-20h5v-9c0-6-4-10-11-10Z" /><path d="M9 27 3 38l3 2 7-10ZM31 27l6 11-3 2-7-10Z" /></svg>
                </span>
                <strong>{{ opponent.name }}</strong>
                <small>{{ opponent.char.cn }} · LV.{{ opponent.level }}</small>
              </div>
            </div>
            <div class="modal__actions">
              <button class="btn-ghost" @click="cancelMatch">稍后再说</button>
              <button class="btn-primary" @click="beginFight">开战 FIGHT!</button>
            </div>
          </template>
        </div>
      </div>
    </transition>

    <!-- 排行榜 -->
    <transition name="modal">
      <div v-if="showRank" class="modal" @click.self="showRank = false">
        <div class="modal__box modal__box--wide">
          <h3 class="modal__title">RANKING · 全区积分排行</h3>
          <ol class="ranks">
            <li v-for="(r, i) in ranks" :key="r.name" class="rank" :class="{ 'is-me': r.me }">
              <span class="rank__no" :class="'rank__no--' + (i + 1)">{{ i + 1 }}</span>
              <span class="rank__name">{{ r.name }}</span>
              <span class="rank__char">{{ r.char.cn }} {{ r.char.name }}</span>
              <span class="rank__score">{{ r.score.toLocaleString() }}</span>
            </li>
          </ol>
          <div class="modal__actions">
            <button class="btn-ghost" @click="showRank = false">关闭</button>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import CharacterSelect from '../components/CharacterSelect.vue'
import FighterStage from '../components/FighterStage.vue'
import { useToast } from '../composables/useToast.js'
import { playFight } from '../composables/useFight.js'
import { player, logout, setFighter } from '../store/player.js'
import { ROSTER, getCharacter } from '../three/roster.js'
import { sfx } from '../utils/arcadeAudio.js'

const router = useRouter()
const roster = ROSTER
const { showToast } = useToast()

const characterId = computed({
  get: () => player.fighterId,
  set: (id) => setFighter(id)
})
const character = computed(() => getCharacter(player.fighterId))
const winRate = computed(() => {
  const total = player.wins + player.losses
  return total ? Math.round((player.wins / total) * 100) : 0
})

const statRows = computed(() => [
  { key: 'power', label: '力量 POWER', value: character.value.stats.power },
  { key: 'speed', label: '速度 SPEED', value: character.value.stats.speed },
  { key: 'tech', label: '技巧 TECH', value: character.value.stats.tech }
])

const muted = ref(false)
function toggleMute() {
  muted.value = sfx.toggle()
  showToast(muted.value ? '已静音' : '音效已开启', 1400)
}

/* ------------------------------ 模式 ------------------------------ */
const icon = {
  arcade:
    '<svg viewBox="0 0 24 24"><path d="M6 3h12a3 3 0 0 1 3 3v9a3 3 0 0 1-3 3h-3l1.6 3H7.4L9 18H6a3 3 0 0 1-3-3V6a3 3 0 0 1 3-3Zm1.4 3.6v2h-2v1.8h2v2h1.8v-2h2V8.6h-2v-2H7.4Zm9.1.4a1.4 1.4 0 1 0 0 2.8 1.4 1.4 0 0 0 0-2.8Zm-1.6 3.4a1.4 1.4 0 1 0 0 2.8 1.4 1.4 0 0 0 0-2.8Z" fill="currentColor"/></svg>',
  vs: '<svg viewBox="0 0 24 24"><path d="M12 2 9.2 8.6 2 9.4l5.4 4.8L5.8 21 12 17.4 18.2 21l-1.6-6.8L22 9.4l-7.2-.8L12 2Z" fill="currentColor"/></svg>',
  training:
    '<svg viewBox="0 0 24 24"><path d="M4 9h2V7a2 2 0 0 1 4 0v10a2 2 0 0 1-4 0v-2H4v2a4 4 0 0 0 8 .5V14h0a4 4 0 0 0 8-.5v2h-2v2a2 2 0 0 1-4 0V7a2 2 0 0 1 4 0v2h2V7a4 4 0 0 0-8-.5V14h0a4 4 0 0 0-8 .5V9Z" fill="currentColor"/></svg>',
  ranking:
    '<svg viewBox="0 0 24 24"><path d="M6 3h12v2h3v3a4 4 0 0 1-4 4h-.5A5.5 5.5 0 0 1 13 15.7V18h3v3H8v-3h3v-2.3A5.5 5.5 0 0 1 7.5 12H7a4 4 0 0 1-4-4V5h3V3Zm0 4H5v1a2 2 0 0 0 1 1.7V7Zm12 0v2.7A2 2 0 0 0 19 8V7h-1Z" fill="currentColor"/></svg>'
}

const modes = [
  { id: 'arcade', name: '街机模式', en: 'ARCADE', desc: '连续挑战 8 位劲敌，问鼎世界冠军', icon: icon.arcade, hot: true },
  { id: 'vs', name: '在线对战', en: 'VS ONLINE', desc: '天梯匹配真人玩家，段位实时更新', icon: icon.vs },
  { id: 'training', name: '训练模式', en: 'TRAINING', desc: '自由练习连招与必杀技出招表', icon: icon.training },
  { id: 'ranking', name: '排行榜', en: 'RANKING', desc: '查看全区拳手积分与段位排名', icon: icon.ranking }
]

const quests = reactive([
  { name: '完成任意对局 3 场', done: 1, need: 3 },
  { name: '使用春丽获胜 2 场', done: 0, need: 2 },
  { name: '每日签到领金币', done: 1, need: 1 }
])

/* ------------------------------ 匹配 ------------------------------ */
const NAMES = ['SPINAL·07', 'RYU_KEN_88', 'ShinAkuma', '唐人街拳王', 'PUNCH-LOVER', 'BAY AREA JIN', '月下豪鬼', '格斗小蜗牛']
const match = reactive({ state: 'idle', mode: modes[0] })
const opponent = reactive({ name: '', char: ROSTER[0], level: 10 })
let matchTimer = null

function startMode(mode) {
  sfx.click()
  if (mode.id === 'ranking') {
    showRank.value = true
    return
  }
  match.mode = mode
  match.state = 'searching'
  sfx.coin()
  clearTimeout(matchTimer)
  matchTimer = setTimeout(() => {
    const pool = ROSTER.filter((c) => c.id !== player.fighterId)
    opponent.char = pool[Math.floor(Math.random() * pool.length)]
    opponent.name = NAMES[Math.floor(Math.random() * NAMES.length)]
    opponent.level = 6 + Math.floor(Math.random() * 40)
    match.state = 'found'
    sfx.select()
  }, 2200)
}

function cancelMatch() {
  clearTimeout(matchTimer)
  match.state = 'idle'
  sfx.click()
}

function beginFight() {
  sfx.fight()
  match.state = 'idle'
  const q = new URLSearchParams()
  q.set('opp', opponent.char.id)
  q.set('oppname', opponent.name)
  q.set('level', String(opponent.level))
  q.set('mode', match.mode.name)
  // 开发环境下可用 ?hard=1 直接挑战「困难」AI
  if (import.meta.env.DEV && new URLSearchParams(window.location.search).get('hard') === '1') {
    q.set('diff', 'hard')
  }
  router.push({ path: '/battle', query: Object.fromEntries(q) })
}

/* ------------------------------ 排行榜 ------------------------------ */
const showRank = ref(false)
const ranks = computed(() => {
  const base = NAMES.slice(0, 7).map((name, i) => ({
    name,
    char: ROSTER[i % ROSTER.length],
    score: 9200 - i * 640 + ((i * 37) % 200)
  }))
  base.splice(3, 0, {
    name: player.account || 'ME',
    char: character.value,
    score: 7180,
    me: true
  })
  return base
})

function onLogout() {
  sfx.click()
  logout()
  showToast('已退出登录', 1800)
  router.push({ name: 'login' })
}

function onKey(e) {
  if (e.target && /input|select|textarea/i.test(e.target.tagName)) return
  if (match.state !== 'idle' || showRank.value) {
    if (e.code === 'Escape') {
      match.state = 'idle'
      showRank.value = false
    }
    return
  }
  const n = Number(e.key)
  if (n >= 1 && n <= roster.length) {
    setFighter(roster[n - 1].id)
    sfx.select()
  }
  if (e.code === 'Space') {
    e.preventDefault()
    startMode(modes[0])
  }
}

onMounted(() => {
  window.addEventListener('keydown', onKey)
  // 仅开发环境：?match=1 直接展示“匹配成功”弹窗，便于调 UI
  if (import.meta.env.DEV && new URLSearchParams(window.location.search).get('match') === '1') {
    opponent.name = 'ShinAkuma'
    opponent.char = ROSTER[3]
    opponent.level = 42
    match.mode = modes[1]
    match.state = 'found'
  }
})
onBeforeUnmount(() => {
  window.removeEventListener('keydown', onKey)
  clearTimeout(matchTimer)
})
</script>

<style scoped>
.lobby {
  position: relative;
  z-index: 2;
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
  animation: lobbyIn 0.5s cubic-bezier(0.22, 1, 0.36, 1) both;
}
@keyframes lobbyIn {
  from {
    opacity: 0;
    transform: translateY(16px);
  }
}
@keyframes blink {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.22;
  }
}

/* ------------------------------ 顶栏 ------------------------------ */
.nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 16px 30px 10px;
}
.nav__left {
  display: flex;
  align-items: baseline;
  gap: 10px;
}
.nav__mark {
  font-size: 13px;
  font-weight: 900;
  letter-spacing: 0.26em;
  background: linear-gradient(180deg, #fff, color-mix(in srgb, var(--aura) 70%, #fff));
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
.nav__sep {
  color: rgba(226, 232, 255, 0.24);
}
.nav__where {
  font-size: 11px;
  letter-spacing: 0.24em;
  color: color-mix(in srgb, var(--aura) 82%, #fff 18%);
  font-weight: 800;
}
.nav__right {
  display: flex;
  align-items: center;
  gap: 10px;
}
.nav__btn {
  padding: 7px 14px;
  border-radius: 9px;
  border: 1px solid rgba(255, 255, 255, 0.13);
  background: rgba(255, 255, 255, 0.045);
  color: rgba(238, 242, 255, 0.82);
  font-family: inherit;
  font-size: 11.5px;
  letter-spacing: 0.1em;
  cursor: pointer;
  transition: all 0.18s;
}
.nav__btn:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: color-mix(in srgb, var(--aura) 60%, transparent);
  color: #fff;
}
.nav__btn--out:hover {
  border-color: rgba(255, 90, 90, 0.55);
  color: #ff9d9d;
  background: rgba(255, 74, 74, 0.1);
}

/* ------------------------------ 布局 ------------------------------ */
.main {
  flex: 1;
  display: grid;
  grid-template-columns: minmax(320px, 420px) minmax(0, 1fr);
  gap: clamp(16px, 2.4vw, 34px);
  padding: 4px clamp(20px, 4vw, 62px) 8px;
  min-height: 0;
  align-items: stretch;
}
.col {
  display: flex;
  flex-direction: column;
  gap: 14px;
  min-width: 0;
  min-height: 0;
}
.col--stage {
  height: 100%;
  max-height: 74vh;
}

.card {
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  background: linear-gradient(160deg, rgba(18, 20, 32, 0.78), rgba(8, 9, 16, 0.82));
  backdrop-filter: blur(8px);
  padding: 15px 17px 17px;
}
.card__title {
  margin: 0 0 12px;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.24em;
  color: color-mix(in srgb, var(--aura) 84%, #fff 16%);
  display: flex;
  align-items: baseline;
  gap: 8px;
}
.card__title span {
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.18em;
  color: rgba(226, 232, 255, 0.4);
}

/* --------------------------- 玩家卡 --------------------------- */
.card--player {
  padding-bottom: 14px;
}
.pcard {
  display: flex;
  align-items: center;
  gap: 13px;
}
.pcard__avatar {
  display: grid;
  place-items: center;
  width: 52px;
  height: 52px;
  border-radius: 14px;
  font-size: 22px;
  font-weight: 900;
  color: #06070c;
  box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.18), 0 8px 22px -8px var(--aura);
  flex: none;
}
.pcard__name {
  margin: 0;
  font-size: 16px;
  font-weight: 800;
  letter-spacing: 0.06em;
  display: flex;
  align-items: center;
  gap: 8px;
}
.pcard__guest {
  font-size: 9.5px;
  letter-spacing: 0.1em;
  padding: 2px 7px;
  border-radius: 999px;
  background: rgba(255, 211, 92, 0.16);
  border: 1px solid rgba(255, 211, 92, 0.45);
  color: #ffd35c;
  font-weight: 700;
}
.pcard__level {
  margin: 7px 0 0;
  display: flex;
  align-items: center;
  gap: 9px;
  font-size: 11.5px;
  letter-spacing: 0.12em;
  color: rgba(226, 232, 255, 0.55);
}
.pcard__level strong {
  color: #fff;
  font-size: 13px;
}
.pcard__expbar {
  flex: 1;
  max-width: 150px;
  height: 5px;
  border-radius: 4px;
  background: rgba(255, 255, 255, 0.1);
  overflow: hidden;
}
.pcard__expbar i {
  display: block;
  height: 100%;
  border-radius: 4px;
  background: linear-gradient(90deg, color-mix(in srgb, var(--aura) 65%, #000 35%), var(--aura));
  box-shadow: 0 0 10px var(--aura);
  transition: width 0.5s;
}
.pcard__nums {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
  margin-top: 14px;
  padding-top: 13px;
  border-top: 1px solid rgba(255, 255, 255, 0.07);
}
.num {
  display: flex;
  flex-direction: column;
  gap: 3px;
}
.num em {
  font-style: normal;
  font-size: 10px;
  letter-spacing: 0.2em;
  color: rgba(226, 232, 255, 0.4);
}
.num strong {
  font-size: 13px;
  font-variant-numeric: tabular-nums;
  color: rgba(238, 242, 255, 0.92);
}

/* --------------------------- 模式 --------------------------- */
.modes {
  display: flex;
  flex-direction: column;
  gap: 9px;
}
.mode {
  position: relative;
  display: flex;
  align-items: center;
  gap: 13px;
  padding: 11px 13px;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.09);
  background: rgba(255, 255, 255, 0.03);
  color: rgba(238, 242, 255, 0.86);
  font-family: inherit;
  text-align: left;
  cursor: pointer;
  overflow: hidden;
  transition: all 0.2s cubic-bezier(0.22, 1, 0.36, 1);
}
.mode::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(100deg, color-mix(in srgb, var(--aura) 30%, transparent), transparent 68%);
  opacity: 0;
  transition: opacity 0.22s;
}
.mode:hover {
  transform: translateX(4px);
  border-color: color-mix(in srgb, var(--aura) 55%, transparent);
  background: rgba(255, 255, 255, 0.06);
}
.mode:hover::before {
  opacity: 1;
}
.mode.is-hot {
  border-color: color-mix(in srgb, #ffd35c 40%, transparent);
}
.mode__icon {
  display: grid;
  place-items: center;
  width: 38px;
  height: 38px;
  border-radius: 11px;
  background: color-mix(in srgb, var(--aura) 18%, rgba(255, 255, 255, 0.05));
  border: 1px solid color-mix(in srgb, var(--aura) 38%, transparent);
  flex: none;
  position: relative;
}
.mode__icon :deep(svg) {
  width: 20px;
  height: 20px;
  color: var(--aura);
}
.mode__text {
  display: flex;
  flex-direction: column;
  gap: 2px;
  position: relative;
}
.mode__text strong {
  font-size: 14px;
  letter-spacing: 0.08em;
  display: flex;
  align-items: baseline;
  gap: 8px;
}
.mode__text strong i {
  font-style: normal;
  font-size: 9.5px;
  letter-spacing: 0.2em;
  color: rgba(226, 232, 255, 0.4);
}
.mode__text small {
  font-size: 11.5px;
  color: rgba(226, 232, 255, 0.5);
}
.mode__badge {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 9.5px;
  letter-spacing: 0.14em;
  padding: 3px 8px;
  border-radius: 999px;
  background: linear-gradient(180deg, #ffd35c, #f2601f);
  color: #2a1002;
  font-weight: 800;
}

/* --------------------------- 任务 --------------------------- */
.quests {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 11px;
}
.quest {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 4px 10px;
  align-items: center;
}
.quest__name {
  grid-column: 1 / -1;
  font-size: 12.5px;
  letter-spacing: 0.06em;
  color: rgba(238, 242, 255, 0.78);
}
.quest__bar {
  height: 5px;
  border-radius: 4px;
  background: rgba(255, 255, 255, 0.1);
  overflow: hidden;
}
.quest__bar i {
  display: block;
  height: 100%;
  border-radius: 4px;
  background: #4dffa5;
  box-shadow: 0 0 8px rgba(77, 255, 165, 0.6);
  transition: width 0.4s;
}
.quest__num {
  font-size: 10.5px;
  letter-spacing: 0.1em;
  color: rgba(226, 232, 255, 0.5);
  font-variant-numeric: tabular-nums;
}
.quest__num.is-done {
  color: #4dffa5;
}

/* --------------------------- 3D 舞台 --------------------------- */
.stage-wrap {
  position: relative;
  flex: 1;
  min-height: 320px;
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  background:
    radial-gradient(90% 70% at 50% 108%, color-mix(in srgb, var(--aura) 26%, transparent), transparent 62%),
    linear-gradient(180deg, rgba(16, 18, 30, 0.5), rgba(4, 5, 10, 0.72));
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.06);
  overflow: hidden;
}
.stage-wrap__hud {
  position: absolute;
  top: 12px;
  left: 14px;
  right: 14px;
  display: flex;
  justify-content: space-between;
  z-index: 3;
  pointer-events: none;
}
.tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.18em;
  color: rgba(238, 242, 255, 0.72);
  background: rgba(6, 8, 15, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(6px);
}
.tag--live i {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #ff4a4a;
  box-shadow: 0 0 8px #ff4a4a;
  animation: blink 1.2s infinite;
}
.nameplate {
  position: absolute;
  left: 16px;
  bottom: 22px;
  z-index: 3;
  pointer-events: none;
}
.nameplate__cn {
  margin: 0;
  font-size: 12px;
  letter-spacing: 0.4em;
  color: rgba(226, 232, 255, 0.55);
}
.nameplate__en {
  margin: 2px 0 0;
  font-size: clamp(28px, 3.2vw, 42px);
  font-weight: 900;
  font-style: italic;
  letter-spacing: 0.03em;
  line-height: 1;
  color: #fff;
  text-shadow:
    0 0 26px color-mix(in srgb, var(--aura) 75%, transparent),
    0 4px 12px rgba(0, 0, 0, 0.7);
}
.nameplate__title {
  margin: 6px 0 0;
  font-size: 12px;
  letter-spacing: 0.16em;
  color: color-mix(in srgb, var(--aura) 82%, #fff 18%);
}
.nameplate__special {
  margin: 10px 0 0;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 5px 11px;
  border-radius: 999px;
  font-size: 11.5px;
  letter-spacing: 0.1em;
  color: #fff;
  background: color-mix(in srgb, var(--aura) 22%, rgba(6, 8, 15, 0.8));
  border: 1px solid color-mix(in srgb, var(--aura) 55%, transparent);
}
.nameplate__special span {
  font-size: 9px;
  letter-spacing: 0.2em;
  padding: 1px 5px;
  border-radius: 4px;
  background: var(--aura);
  color: #06070c;
  font-weight: 800;
}
.stats {
  position: absolute;
  right: 16px;
  bottom: 22px;
  z-index: 3;
  width: 168px;
  display: flex;
  flex-direction: column;
  gap: 7px;
  pointer-events: none;
}
.stats__row {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 4px 8px;
  align-items: center;
}
.stats__label {
  grid-column: 1 / -1;
  font-size: 9.5px;
  letter-spacing: 0.16em;
  color: rgba(226, 232, 255, 0.45);
}
.stats__bar {
  height: 6px;
  border-radius: 4px;
  background: rgba(255, 255, 255, 0.1);
  overflow: hidden;
}
.stats__bar i {
  display: block;
  height: 100%;
  border-radius: 4px;
  background: linear-gradient(90deg, color-mix(in srgb, var(--aura) 70%, #000 30%), var(--aura));
  box-shadow: 0 0 12px var(--aura);
  transition: width 0.55s cubic-bezier(0.22, 1, 0.36, 1);
}
.stats__num {
  font-size: 11px;
  font-variant-numeric: tabular-nums;
  color: rgba(238, 242, 255, 0.8);
}

.picker {
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  background: rgba(8, 9, 16, 0.55);
  padding: 12px 14px 14px;
  backdrop-filter: blur(8px);
}
.picker__head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 10px;
}
.picker__head span {
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.24em;
  color: rgba(226, 232, 255, 0.62);
}
.picker__head small {
  font-size: 10.5px;
  letter-spacing: 0.06em;
  color: rgba(226, 232, 255, 0.35);
}

/* --------------------------- 底部公告 --------------------------- */
.foot {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 10px 30px 16px;
}
.foot__label {
  flex: none;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.24em;
  color: #ffd35c;
}
.foot__marquee {
  flex: 1;
  overflow: hidden;
  -webkit-mask-image: linear-gradient(90deg, transparent, #000 4%, #000 96%, transparent);
  mask-image: linear-gradient(90deg, transparent, #000 4%, #000 96%, transparent);
}
.foot__track {
  display: flex;
  width: max-content;
  animation: marquee 34s linear infinite;
}
.foot__track span {
  font-size: 11.5px;
  letter-spacing: 0.08em;
  color: rgba(226, 232, 255, 0.42);
  white-space: nowrap;
  padding-right: 30px;
}
@keyframes marquee {
  to {
    transform: translateX(-50%);
  }
}

/* --------------------------- 弹窗 --------------------------- */
.modal {
  position: fixed;
  inset: 0;
  z-index: 50;
  display: grid;
  place-items: center;
  background: rgba(3, 4, 9, 0.72);
  backdrop-filter: blur(7px);
  padding: 20px;
}
.modal__box {
  width: min(420px, 92vw);
  padding: 28px 26px 24px;
  border-radius: 20px;
  border: 1px solid color-mix(in srgb, var(--aura) 38%, transparent);
  background: linear-gradient(160deg, rgba(20, 23, 36, 0.96), rgba(8, 9, 16, 0.97));
  box-shadow: 0 40px 90px -30px #000, 0 0 60px -26px var(--aura);
  text-align: center;
  animation: boxIn 0.34s cubic-bezier(0.22, 1, 0.36, 1) both;
}
.modal__box--wide {
  width: min(520px, 94vw);
  text-align: left;
}
@keyframes boxIn {
  from {
    opacity: 0;
    transform: translateY(18px) scale(0.96);
  }
}
.modal__title {
  margin: 18px 0 6px;
  font-size: 15px;
  letter-spacing: 0.14em;
}
.modal__sub {
  margin: 0 0 20px;
  font-size: 10px;
  letter-spacing: 0.34em;
  color: rgba(226, 232, 255, 0.4);
}
.modal__found {
  margin: 0 0 16px;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.28em;
  color: #4dffa5;
}
.modal__actions {
  display: flex;
  gap: 10px;
  justify-content: center;
  margin-top: 20px;
}
.modal__actions .btn-ghost,
.modal__actions .btn-primary {
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
  filter: saturate(1.1);
}

/* 雷达 */
.radar {
  position: relative;
  width: 96px;
  height: 96px;
  margin: 4px auto 0;
  display: grid;
  place-items: center;
}
.radar__ring,
.radar__core {
  position: absolute;
  border-radius: 50%;
}
.radar__core {
  width: 22px;
  height: 22px;
  background: var(--aura);
  box-shadow: 0 0 24px var(--aura);
  animation: corePulse 1.2s ease-in-out infinite;
}
@keyframes corePulse {
  50% {
    transform: scale(0.72);
    opacity: 0.75;
  }
}
.radar__ring {
  width: 40px;
  height: 40px;
  border: 1px solid color-mix(in srgb, var(--aura) 65%, transparent);
  animation: ringOut 1.9s ease-out infinite;
}
.radar__ring--2 {
  animation-delay: 0.95s;
}
@keyframes ringOut {
  from {
    width: 30px;
    height: 30px;
    opacity: 0.9;
  }
  to {
    width: 96px;
    height: 96px;
    opacity: 0;
  }
}

/* 对阵 */
.versus {
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  gap: 12px;
  margin: 4px 0 4px;
}
.versus__side {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
}
.versus__pic {
  width: 54px;
  height: 62px;
  display: grid;
  place-items: center;
}
.versus__pic svg {
  width: 100%;
  height: 100%;
  fill: currentColor;
  filter: drop-shadow(0 0 12px currentColor);
}
.versus__side strong {
  font-size: 13px;
  letter-spacing: 0.06em;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.versus__side small {
  font-size: 10.5px;
  letter-spacing: 0.1em;
  color: rgba(226, 232, 255, 0.5);
}
.versus__vs {
  font-size: 22px;
  font-weight: 900;
  font-style: italic;
  color: #ffd35c;
  text-shadow: 0 0 18px rgba(255, 211, 92, 0.7);
}

/* 排行榜 */
.ranks {
  list-style: none;
  margin: 14px 0 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 7px;
}
.rank {
  display: grid;
  grid-template-columns: 30px 1fr auto auto;
  align-items: center;
  gap: 12px;
  padding: 9px 12px;
  border-radius: 11px;
  background: rgba(255, 255, 255, 0.035);
  border: 1px solid rgba(255, 255, 255, 0.06);
}
.rank.is-me {
  border-color: color-mix(in srgb, var(--aura) 60%, transparent);
  background: color-mix(in srgb, var(--aura) 12%, rgba(255, 255, 255, 0.03));
}
.rank__no {
  display: grid;
  place-items: center;
  width: 24px;
  height: 24px;
  border-radius: 7px;
  font-size: 11px;
  font-weight: 900;
  background: rgba(255, 255, 255, 0.1);
  color: rgba(238, 242, 255, 0.7);
}
.rank__no--1 {
  background: linear-gradient(180deg, #ffe07a, #e09a1c);
  color: #2a1c02;
}
.rank__no--2 {
  background: linear-gradient(180deg, #e6ecf5, #9aa7bd);
  color: #14181f;
}
.rank__no--3 {
  background: linear-gradient(180deg, #e0a878, #a5612f);
  color: #241004;
}
.rank__name {
  font-size: 13px;
  letter-spacing: 0.06em;
  font-weight: 700;
}
.rank__char {
  font-size: 11px;
  letter-spacing: 0.1em;
  color: rgba(226, 232, 255, 0.5);
}
.rank__score {
  font-size: 13px;
  font-variant-numeric: tabular-nums;
  color: #ffd35c;
  font-weight: 700;
}

.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.25s;
}
.modal-enter-active .modal__box,
.modal-leave-active .modal__box {
  transition: transform 0.25s cubic-bezier(0.22, 1, 0.36, 1);
}
.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}
.modal-enter-from .modal__box,
.modal-leave-to .modal__box {
  transform: translateY(16px) scale(0.97);
}

/* ------------------------------ 响应式 ------------------------------ */
@media (max-width: 1080px) {
  .main {
    grid-template-columns: minmax(0, 1fr);
    gap: 18px;
  }
  .col--stage {
    order: -1;
    max-height: none;
  }
  .stage-wrap {
    min-height: 340px;
  }
  .nav,
  .foot {
    padding-left: 20px;
    padding-right: 20px;
  }
}
@media (max-width: 560px) {
  .stage-wrap {
    min-height: 300px;
  }
  .stats {
    display: none;
  }
  .pcard__nums {
    grid-template-columns: repeat(3, 1fr);
    gap: 6px;
  }
  .num strong {
    font-size: 11.5px;
  }
}
</style>
