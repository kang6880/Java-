<script setup>
import { ref, computed } from 'vue'

/* ============================================================
 * 航海王全史 —— 时间线展示页（无需登录，纯静态叙事）
 * 以罗杰时代 → 东海 → 伟大航道 → 顶上战争 → 新世界 → 新时代 为主线
 * ============================================================ */

const eras = [
  {
    year: '海圆历 1490 年前后',
    title: '海贼王哥尔·D·罗杰时代',
    icon: '☠️',
    color: '#c0392b',
    desc: '哥尔·D·罗杰征服伟大航道，抵达拉夫德鲁，知晓世界的真相，成为史上唯一的海贼王。',
    points: [
      '罗杰海贼团完成伟大航道的全程航行，发现 One Piece',
      '罗杰身患绝症，解散海贼团，向海军自首',
      '处刑前留下遗言「想要我的财宝吗？想要的话可以全部给你，去找吧！我把一切都放在那里了」',
      '大海贼时代开启，无数人扬帆出海追寻 One Piece'
    ]
  },
  {
    year: '海圆历 1520 年前后',
    title: '东海的启航',
    icon: '🌊',
    color: '#2980b9',
    desc: '少年蒙奇·D·路飞吃下橡胶果实，与香克斯立下约定，独自出航，踏上成为海贼王之路。',
    points: [
      '路飞吃下橡胶果实，与红发香克斯定下「归还草帽」的约定',
      '先后招募剑士索隆、航海士娜美、狙击手乌索普、厨师山治',
      '在东海击败克里克、阿龙等强敌，救下娜美的故乡可可亚西村',
      '五人草帽海贼团正式成立，向着伟大航道进发'
    ]
  },
  {
    year: '海圆历 1521 年',
    title: '伟大航道前半段',
    icon: '🧭',
    color: '#16a085',
    desc: '进入伟大航道，结识乔巴、罗宾，历经阿拉巴斯坦、空岛、司法岛等重大冒险。',
    points: [
      '在磁鼓岛招募船医乔巴，在阿拉巴斯坦击败七武海克洛克达尔',
      '空岛篇揭示黄金钟与「D」之一族的伏笔',
      '司法岛篇为救罗宾向世界政府宣战，草帽一伙全员悬赏',
      '建造新船「万里阳光号」，弗兰奇与布鲁克加入'
    ]
  },
  {
    year: '海圆历 1522 年',
    title: '顶上战争',
    icon: '⚔️',
    color: '#8e44ad',
    desc: '为救兄长艾斯，路飞闯入海军本部，引发席卷世界的大战。',
    points: [
      '白胡子海贼团与海军本部、七武海全面开战',
      '艾斯为保护路飞牺牲，白胡子战死，新时代开启',
      '路飞在雷利指导下进行两年修行，掌握霸气',
      '香克斯介入，战争落幕'
    ]
  },
  {
    year: '海圆历 1524 年',
    title: '新世界·四皇争霸',
    icon: '👑',
    color: '#d35400',
    desc: '修行归来的草帽一伙再聚香波地，进入新世界，挑战四皇。',
    points: [
      '鱼人岛、庞克哈萨德、德雷斯罗萨，击败多弗朗明哥',
      '路飞成立草帽大船团，成为七武海之外的超新星之首',
      '佐乌、万国篇，向四皇大妈宣战',
      '和之国篇决战凯多，路飞觉醒太阳神尼卡形态'
    ]
  },
  {
    year: '现在',
    title: '最终之岛 · 新时代',
    icon: '🏴‍☠️',
    color: '#c0392b',
    desc: '通往拉夫德鲁的秘密逐步揭开，One Piece 的真相即将揭晓，大海贼时代迎来终章。',
    points: [
      '四皇格局重塑，路飞成为新四皇',
      '乔伊波伊、空白的一百年、D 之一族的真相浮出水面',
      '草帽一伙向最终之岛拉夫德鲁进发',
      '「一个人的梦想只是梦想，一群人的梦想将成为现实」'
    ]
  }
]

const activeIdx = ref(0)
const active = computed(() => eras[activeIdx.value])

function select (i) {
  activeIdx.value = i
}

function next () {
  activeIdx.value = (activeIdx.value + 1) % eras.length
}

function prev () {
  activeIdx.value = (activeIdx.value - 1 + eras.length) % eras.length
}
</script>

<template>
  <section class="panel onepiece-panel">
    <header class="panel-head onepiece-head">
      <h2>🏴‍☠️ 航海王全史</h2>
      <p>从大海贼时代开启，到通往最终之岛的航程 —— 沿着时间线，重温这部跨越二十余年的伟大冒险。</p>
    </header>

    <!-- 时代时间线导航 -->
    <div class="era-nav">
      <button
        v-for="(e, i) in eras"
        :key="e.title"
        type="button"
        class="era-dot"
        :class="{ active: activeIdx === i }"
        :style="activeIdx === i ? { '--era': e.color } : {}"
        @click="select(i)"
      >
        <span class="era-dot-icon">{{ e.icon }}</span>
        <span class="era-dot-label">{{ e.year }}</span>
      </button>
    </div>

    <!-- 当前时代展示 -->
    <transition name="panel-swap" mode="out-in">
      <article :key="active.title" class="era-card" :style="{ '--era': active.color }">
        <div class="era-hero">
          <span class="era-hero-icon">{{ active.icon }}</span>
          <div class="era-hero-text">
            <span class="era-year">{{ active.year }}</span>
            <h3 class="era-title">{{ active.title }}</h3>
          </div>
        </div>

        <p class="era-desc">{{ active.desc }}</p>

        <ul class="era-points">
          <li v-for="(p, i) in active.points" :key="i">
            <span class="era-point-num">{{ i + 1 }}</span>
            <span>{{ p }}</span>
          </li>
        </ul>

        <div class="era-ctrl">
          <button type="button" class="era-btn" @click="prev">‹ 上一时代</button>
          <span class="era-progress">{{ activeIdx + 1 }} / {{ eras.length }}</span>
          <button type="button" class="era-btn" @click="next">下一时代 ›</button>
        </div>
      </article>
    </transition>

    <p class="onepiece-foot">
      「世代传承的意志、时代的浪潮、人的梦想 —— 这些都是无法阻挡的。」<br>
      <small>ONEPIECE 是一切的开始，也是一切的终点。</small>
    </p>
  </section>
</template>

<style scoped>
.onepiece-panel {
  max-width: 960px;
  margin: 0 auto;
}

.onepiece-head {
  text-align: center;
}

/* 时间线导航 */
.era-nav {
  display: flex;
  justify-content: center;
  gap: 14px;
  flex-wrap: wrap;
  margin: 22px 0 28px;
}

.era-dot {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 6px 10px;
  border-radius: 12px;
  transition: transform .2s, background .2s;
  color: var(--ink, #2b3a4a);
}

.era-dot:hover {
  transform: translateY(-3px);
  background: rgba(0, 0, 0, .05);
}

.era-dot-icon {
  font-size: 26px;
  line-height: 1;
  opacity: .55;
  transition: opacity .2s, transform .2s;
}

.era-dot.active .era-dot-icon {
  opacity: 1;
  transform: scale(1.15);
}

.era-dot-label {
  font-size: 11px;
  white-space: nowrap;
  opacity: .7;
}

.era-dot.active .era-dot-label {
  opacity: 1;
  font-weight: 700;
  color: var(--era);
}

/* 时代卡片 */
.era-card {
  background: #fff;
  border: 1px solid rgba(0, 0, 0, .08);
  border-top: 4px solid var(--era);
  border-radius: 16px;
  padding: 30px 32px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, .06);
}

.era-hero {
  display: flex;
  align-items: center;
  gap: 18px;
  margin-bottom: 18px;
}

.era-hero-icon {
  font-size: 52px;
  line-height: 1;
}

.era-year {
  display: inline-block;
  font-size: 12px;
  letter-spacing: 1px;
  color: var(--era);
  font-weight: 700;
  text-transform: uppercase;
  margin-bottom: 4px;
}

.era-title {
  font-size: 26px;
  margin: 0;
  color: #1c2b3a;
}

.era-desc {
  font-size: 15px;
  line-height: 1.7;
  color: #4a5a6a;
  margin: 0 0 20px;
}

/* 要点列表 */
.era-points {
  list-style: none;
  padding: 0;
  margin: 0 0 24px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.era-points li {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  font-size: 14px;
  line-height: 1.6;
  color: #3a4a5a;
}

.era-point-num {
  flex-shrink: 0;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: var(--era);
  color: #fff;
  font-size: 12px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 1px;
}

/* 控制按钮 */
.era-ctrl {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-top: 1px dashed rgba(0, 0, 0, .12);
  padding-top: 18px;
}

.era-btn {
  background: var(--era);
  color: #fff;
  border: none;
  border-radius: 8px;
  padding: 9px 18px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: filter .2s, transform .2s;
}

.era-btn:hover {
  filter: brightness(1.08);
  transform: translateY(-1px);
}

.era-progress {
  font-size: 13px;
  color: #7a8a9a;
  font-weight: 600;
}

.onepiece-foot {
  text-align: center;
  color: #6a7a8a;
  font-size: 14px;
  line-height: 1.8;
  margin-top: 26px;
}

.onepiece-foot small {
  color: #9a9a9a;
  font-size: 12px;
}
</style>
