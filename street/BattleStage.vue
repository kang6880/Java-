<template>
  <div ref="wrapEl" class="bstage" :class="{ 'is-fallback': fallback }">
    <canvas ref="canvasEl" class="bstage__canvas"></canvas>

    <div v-if="fallback" class="bstage__fallback">
      <p>当前环境未启用 WebGL，3D 对战画面不可用。</p>
      <p class="bstage__fallback-sub">HUD 与操作依旧可用，请改用支持 WebGL 的浏览器。</p>
    </div>

    <div class="bstage__scan"></div>
  </div>
</template>

<script setup>
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import * as THREE from 'three'
import { createBattleFighter } from '../three/battleFighter.js'

const props = defineProps({
  engine: { type: Object, required: true },
  paused: { type: Boolean, default: false }
})

const wrapEl = ref(null)
const canvasEl = ref(null)
const fallback = ref(false)

let renderer, scene, camera, clock, raf
let ro
let f0 = null
let f1 = null
let playerLight, oppLight
let flashPlane, flashMat
let flashAmt = 0

const projMeshes = new Map()
const fxList = []

/* ------------------------------ 贴图 ------------------------------ */
function gridTexture() {
  const c = document.createElement('canvas')
  c.width = c.height = 256
  const ctx = c.getContext('2d')
  ctx.fillStyle = '#070a14'
  ctx.fillRect(0, 0, 256, 256)
  ctx.strokeStyle = 'rgba(90,170,255,0.22)'
  ctx.lineWidth = 2
  for (let i = 0; i <= 256; i += 32) {
    ctx.beginPath(); ctx.moveTo(i, 0); ctx.lineTo(i, 256); ctx.stroke()
    ctx.beginPath(); ctx.moveTo(0, i); ctx.lineTo(256, i); ctx.stroke()
  }
  const tex = new THREE.CanvasTexture(c)
  tex.wrapS = tex.wrapT = THREE.RepeatWrapping
  tex.repeat.set(8, 4)
  tex.colorSpace = THREE.SRGBColorSpace
  return tex
}

function backdropTexture() {
  const c = document.createElement('canvas')
  c.width = 512; c.height = 256
  const ctx = c.getContext('2d')
  // 天空渐变
  const g = ctx.createLinearGradient(0, 0, 0, 256)
  g.addColorStop(0, '#0a1226')
  g.addColorStop(0.45, '#1b2148')
  g.addColorStop(0.6, '#3a2a52')
  g.addColorStop(0.72, '#caa24e')
  g.addColorStop(0.8, '#7c5a2a')
  g.addColorStop(1, '#0b0d18')
  ctx.fillStyle = g
  ctx.fillRect(0, 0, 512, 256)
  // 落日
  const sun = ctx.createRadialGradient(256, 150, 6, 256, 150, 84)
  sun.addColorStop(0, 'rgba(255,225,150,0.95)')
  sun.addColorStop(1, 'rgba(255,150,60,0)')
  ctx.fillStyle = sun
  ctx.beginPath(); ctx.arc(256, 150, 84, 0, Math.PI * 2); ctx.fill()
  const tex = new THREE.CanvasTexture(c)
  tex.colorSpace = THREE.SRGBColorSpace
  return tex
}

/* ------------------------------ 初始化 ------------------------------ */
function initScene() {
  const el = wrapEl.value
  const canvas = canvasEl.value

  renderer = new THREE.WebGLRenderer({ canvas, antialias: true, alpha: false, powerPreference: 'high-performance' })
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2))
  renderer.outputColorSpace = THREE.SRGBColorSpace
  renderer.toneMapping = THREE.NoToneMapping

  scene = new THREE.Scene()
  scene.background = new THREE.Color(0x05060c)

  camera = new THREE.PerspectiveCamera(38, 1, 0.1, 100)
  camera.position.set(0, 1.35, 6.6)
  camera.lookAt(0, 1.0, 0)
  scene.add(camera) // 让闪光面片跟随相机

  scene.add(new THREE.AmbientLight(0xb7c4e6, 0.62))
  const key = new THREE.DirectionalLight(0xfff3e0, 1.4)
  key.position.set(2.4, 5, 4)
  scene.add(key)
  const rim = new THREE.DirectionalLight(0x8fa8ff, 0.5)
  rim.position.set(-3, 2, -4)
  scene.add(rim)

  // 双方角色光（颜色取自各自 aura）
  const [a, b] = props.engine.state.fighters
  const auraA = (a && a.spec && a.spec.aura) || 0x38a6ff
  const auraB = (b && b.spec && b.spec.aura) || 0xa855f7
  playerLight = new THREE.PointLight(auraA, 2.4, 9, 2)
  playerLight.position.set(-2.4, 2.2, 3)
  scene.add(playerLight)
  oppLight = new THREE.PointLight(auraB, 2.4, 9, 2)
  oppLight.position.set(2.4, 2.2, 3)
  scene.add(oppLight)

  // 地面
  const ground = new THREE.Mesh(
    new THREE.PlaneGeometry(20, 12),
    new THREE.MeshBasicMaterial({ map: gridTexture() })
  )
  ground.rotation.x = -Math.PI / 2
  ground.position.y = 0
  scene.add(ground)

  const glow = new THREE.Mesh(
    new THREE.CircleGeometry(3.2, 48),
    new THREE.MeshBasicMaterial({
      color: 0x2b6cff, transparent: true, opacity: 0.16,
      blending: THREE.AdditiveBlending, depthWrite: false
    })
  )
  glow.rotation.x = -Math.PI / 2
  glow.position.y = 0.02
  scene.add(glow)

  // 背景
  const back = new THREE.Mesh(
    new THREE.PlaneGeometry(34, 18),
    new THREE.MeshBasicMaterial({ map: backdropTexture() })
  )
  back.position.set(0, 4.2, -7)
  scene.add(back)

  // 立绘
  f0 = createBattleFighter(a.spec)
  f1 = createBattleFighter(b.spec)
  scene.add(f0.root)
  scene.add(f1.root)

  // KO / 命中白闪
  flashMat = new THREE.MeshBasicMaterial({
    color: 0xffffff, transparent: true, opacity: 0,
    blending: THREE.AdditiveBlending, depthWrite: false
  })
  flashPlane = new THREE.Mesh(new THREE.PlaneGeometry(40, 24), flashMat)
  flashPlane.position.set(0, 0, -0.5)
  flashPlane.visible = false
  camera.add(flashPlane)

  clock = new THREE.Clock()
  resize()
  ro = new ResizeObserver(resize)
  ro.observe(el)
  renderer.setAnimationLoop(tick)
}

function resize() {
  if (!renderer || !wrapEl.value) return
  const w = wrapEl.value.clientWidth || 1
  const h = wrapEl.value.clientHeight || 1
  renderer.setSize(w, h, false)
  camera.aspect = w / h
  camera.position.z = w / h < 0.9 ? 8.4 : 6.6
  camera.updateProjectionMatrix()
}

/* ------------------------------ 特效 ------------------------------ */
function spawnSpark(x, y, color, big = false) {
  const g = new THREE.Group()
  const coreMat = new THREE.MeshBasicMaterial({
    color, transparent: true, opacity: 1, blending: THREE.AdditiveBlending, depthWrite: false
  })
  const core = new THREE.Mesh(new THREE.SphereGeometry(big ? 0.22 : 0.14, 12, 10), coreMat)
  g.add(core)
  const ringMat = new THREE.MeshBasicMaterial({
    color, transparent: true, opacity: 0.9, side: THREE.DoubleSide,
    blending: THREE.AdditiveBlending, depthWrite: false
  })
  const ring = new THREE.Mesh(new THREE.RingGeometry(0.18, 0.26, 24), ringMat)
  ring.rotation.x = -Math.PI / 2
  g.add(ring)
  g.position.set(x, y, 0.45)
  scene.add(g)
  const life = big ? 0.5 : 0.34
  fxList.push({ g, life, max: life, core, ring, coreMat, ringMat, scale: big ? 1.7 : 1.0 })
}

function updateFx(dt) {
  for (let i = fxList.length - 1; i >= 0; i--) {
    const f = fxList[i]
    f.life -= dt
    const k = 1 - f.life / f.max
    f.core.scale.setScalar(1 + k * 2.2 * f.scale)
    f.coreMat.opacity = Math.max(0, 1 - k)
    f.ring.scale.setScalar(0.5 + k * 3 * f.scale)
    f.ringMat.opacity = Math.max(0, 0.9 * (1 - k))
    f.g.rotation.z += dt * 6
    if (f.life <= 0) {
      scene.remove(f.g)
      f.core.geometry.dispose(); f.ring.geometry.dispose()
      f.coreMat.dispose(); f.ringMat.dispose()
      fxList.splice(i, 1)
    }
  }
}

function handleEvent(e) {
  switch (e.type) {
    case 'hit':
      spawnSpark(e.x, e.y, 0xffd35c, !!e.heavy); break
    case 'superhit':
      spawnSpark(e.x, e.y, 0x9be8ff, true); break
    case 'clash':
      spawnSpark(e.x, e.y, 0xffffff, true); break
    case 'block':
      spawnSpark(e.x, e.y, 0x6fd0ff, false); break
    case 'ko':
      flashAmt = 0.7; break
    default:
      break
  }
}

/* ------------------------------ 波动拳 ------------------------------ */
function makeProjectileMesh(aura) {
  const g = new THREE.Group()
  const core = new THREE.Mesh(
    new THREE.SphereGeometry(0.22, 16, 14),
    new THREE.MeshBasicMaterial({ color: aura, transparent: true, opacity: 0.95, blending: THREE.AdditiveBlending, depthWrite: false })
  )
  g.add(core)
  const halo = new THREE.Mesh(
    new THREE.SphereGeometry(0.36, 16, 14),
    new THREE.MeshBasicMaterial({ color: aura, transparent: true, opacity: 0.32, blending: THREE.AdditiveBlending, depthWrite: false })
  )
  g.add(halo)
  const ring = new THREE.Mesh(
    new THREE.TorusGeometry(0.3, 0.05, 8, 24),
    new THREE.MeshBasicMaterial({ color: aura, transparent: true, opacity: 0.8, blending: THREE.AdditiveBlending, depthWrite: false })
  )
  g.add(ring)
  g.userData.ring = ring
  return g
}

function updateProjectiles() {
  const live = new Set()
  for (const p of props.engine.state.projectiles) {
    live.add(p)
    let m = projMeshes.get(p)
    if (!m) {
      m = makeProjectileMesh(p.aura)
      scene.add(m)
      projMeshes.set(p, m)
    }
    m.position.set(p.x, p.y, 0)
    m.rotation.z += 0.3
    if (m.userData.ring) m.userData.ring.rotation.z += 0.2
  }
  for (const [p, m] of projMeshes) {
    if (!live.has(p)) {
      scene.remove(m)
      m.traverse((o) => {
        if (o.geometry) o.geometry.dispose()
        if (o.material) o.material.dispose()
      })
      projMeshes.delete(p)
    }
  }
}

/* ------------------------------ 主循环 ------------------------------ */
function tick() {
  const dt = Math.min(clock.getDelta(), 1 / 30)
  const t = clock.elapsedTime
  const eng = props.engine

  if (!props.paused) eng.step(dt)

  const evs = eng.state.events.splice(0)
  for (const e of evs) handleEvent(e)

  if (f0 && eng.state.fighters[0]) f0.pose(eng.state.fighters[0], dt, t)
  if (f1 && eng.state.fighters[1]) f1.pose(eng.state.fighters[1], dt, t)

  updateProjectiles()
  updateFx(dt)

  // 相机抖动
  const sh = eng.state.shake || 0
  camera.position.x = (Math.random() - 0.5) * sh * 0.5
  camera.position.y = 1.35 + (Math.random() - 0.5) * sh * 0.4

  // 白闪衰减
  flashAmt = Math.max(0, flashAmt - dt * 1.8)
  if (flashMat) {
    flashMat.opacity = flashAmt
    flashPlane.visible = flashAmt > 0.01
  }

  renderer.render(scene, camera)
}

watch(
  () => props.paused,
  () => { if (clock) clock.getDelta() }
)

onMounted(() => {
  try {
    initScene()
  } catch (err) {
    console.warn('[BattleStage] WebGL 初始化失败：', err)
    fallback.value = true
  }
})

onBeforeUnmount(() => {
  if (renderer) renderer.setAnimationLoop(null)
  if (ro) ro.disconnect()
  if (f0) f0.dispose()
  if (f1) f1.dispose()
  for (const [, m] of projMeshes) scene && scene.remove(m)
  projMeshes.clear()
  for (const f of fxList) scene && scene.remove(f.g)
  fxList.length = 0
  if (scene) scene.traverse((o) => o.geometry && o.geometry.dispose())
  if (renderer) renderer.dispose()
})
</script>

<style scoped>
.bstage {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
  background: radial-gradient(120% 80% at 50% 110%, rgba(43, 108, 255, 0.18), transparent 60%), #05060c;
}
.bstage__canvas {
  display: block;
  width: 100%;
  height: 100%;
}
.bstage__scan {
  position: absolute;
  inset: 0;
  pointer-events: none;
  background: repeating-linear-gradient(to bottom, rgba(255, 255, 255, 0.025) 0 1px, transparent 1px 3px);
  mix-blend-mode: overlay;
}
.bstage__fallback {
  position: absolute;
  inset: 0;
  display: grid;
  place-content: center;
  gap: 8px;
  text-align: center;
  padding: 24px;
  color: rgba(226, 232, 255, 0.7);
  font-size: 13px;
  letter-spacing: 0.08em;
}
.bstage__fallback-sub {
  font-size: 11px;
  color: rgba(226, 232, 255, 0.45);
}
</style>
