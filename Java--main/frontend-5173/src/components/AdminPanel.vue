<script setup>
import { ref, onMounted } from 'vue'
import { adminApi, ADMIN_MODULES, getAdminProfile } from '../api/admin.js'
import { formatNumber } from '../api/home.js'

const emit = defineEmits(['logout'])

const profile = getAdminProfile()
const adminName = profile ? (profile.realName || profile.username) : '管理员'

/* ---------- 模块与字段定义 ---------- */
const FIELDS = {
  crews: [
    { key: 'icon', label: '图标' },
    { key: 'name', label: '角色名' },
    { key: 'alias', label: '称号' },
    { key: 'position', label: '职位/身份' },
    { key: 'affiliation', label: '所属势力' },
    { key: 'origin', label: '出身地' },
    { key: 'devilFruit', label: '恶魔果实' },
    { key: 'bounty', label: '悬赏金(贝利)', type: 'number' },
    { key: 'description', label: '人物简介', type: 'textarea' },
    { key: 'sortNo', label: '排序', type: 'number' }
  ],
  routes: [
    { key: 'icon', label: '图标' },
    { key: 'name', label: '航线名称' },
    { key: 'region', label: '所属海域' },
    { key: 'dangerLevel', label: '危险等级(1-5)', type: 'number' },
    { key: 'description', label: '航线简介', type: 'textarea' },
    { key: 'sortNo', label: '排序', type: 'number' }
  ],
  wanteds: [
    { key: 'icon', label: '图标' },
    { key: 'name', label: '海贼名' },
    { key: 'epithet', label: '称号' },
    { key: 'crew', label: '所属海贼团' },
    { key: 'bounty', label: '悬赏金(贝利)', type: 'number' }
  ],
  shops: [
    { key: 'icon', label: '图标' },
    { key: 'name', label: '店铺名' },
    { key: 'category', label: '类别' },
    { key: 'location', label: '所在地' },
    { key: 'item', label: '招牌商品' },
    { key: 'price', label: '售价(贝利)', type: 'number' },
    { key: 'description', label: '店铺简介', type: 'textarea' },
    { key: 'sortNo', label: '排序', type: 'number' }
  ],
  stories: [
    { key: 'icon', label: '图标' },
    { key: 'title', label: '篇章名' },
    { key: 'sea', label: '发生地/海域' },
    { key: 'chapters', label: '漫画章节' },
    { key: 'episodes', label: '动画集数' },
    { key: 'mainRoles', label: '主要登场' },
    { key: 'summary', label: '剧情概要', type: 'textarea' },
    { key: 'sortNo', label: '排序', type: 'number' }
  ]
}

/** 表格里展示的列（key 必须是字段里存在的） */
const COLUMNS = {
  crews: ['图标|icon', '角色名|name', '称号|alias', '势力|affiliation', '悬赏金|bounty', '排序|sortNo'],
  routes: ['图标|icon', '航线|name', '海域|region', '危险|dangerLevel', '排序|sortNo'],
  wanteds: ['图标|icon', '海贼名|name', '称号|epithet', '海贼团|crew', '悬赏金|bounty'],
  shops: ['图标|icon', '店铺|name', '类别|category', '所在地|location', '售价|price'],
  stories: ['图标|icon', '篇章|title', '海域|sea', '动画|episodes', '排序|sortNo']
}

const active = ref('crews')
const rows = ref([])
const loading = ref(false)
const stats = ref({ crewCount: 0, routeCount: 0, wantedCount: 0, shopCount: 0, storyCount: 0, userCount: 0 })

/** 正在编辑的记录：null 表示未打开弹窗；isNew=true 为新增 */
const editing = ref(null)

const fields = () => FIELDS[active.value] || []
const columns = () => (COLUMNS[active.value] || []).map(c => {
  const [label, key] = c.split('|')
  return { label, key }
})

async function load () {
  loading.value = true
  try {
    rows.value = await adminApi.list(active.value)
  } catch (e) {
    toast(e.message || '列表加载失败')
  } finally {
    loading.value = false
  }
}

async function loadStats () {
  try {
    stats.value = await adminApi.stats()
  } catch { /* 总览失败不影响主流程 */ }
}

function switchModule (key) {
  active.value = key
  load()
}

function blankRecord () {
  const rec = {}
  fields().forEach(f => {
    rec[f.key] = f.type === 'number' ? 0 : ''
  })
  if ('sortNo' in rec) rec.sortNo = 100
  return rec
}

function openNew () {
  editing.value = { isNew: true, data: blankRecord() }
}

function openEdit (row) {
  editing.value = { isNew: false, data: { ...row } }
}

function closeEdit () {
  editing.value = null
}

async function submitEdit () {
  const { isNew, data } = editing.value
  // 数值字段统一转成数字，空串按 0 处理
  fields().forEach(f => {
    if (f.type === 'number') {
      const v = Number(data[f.key])
      data[f.key] = Number.isFinite(v) ? v : 0
    }
  })
  try {
    if (isNew) {
      await adminApi.save(active.value, data)
      toast('已新增 1 条记录')
    } else {
      await adminApi.update(active.value, data)
      toast('修改已保存')
    }
    closeEdit()
    await Promise.all([load(), loadStats()])
  } catch (e) {
    toast(e.message || '保存失败')
  }
}

async function remove (row) {
  if (!confirm(`确定删除「${row.name || row.title}」这条记录吗？删除后不可恢复。`)) return
  try {
    await adminApi.remove(active.value, row.id)
    toast('已删除')
    await Promise.all([load(), loadStats()])
  } catch (e) {
    toast(e.message || '删除失败')
  }
}

async function doLogout () {
  try { await adminApi.logout() } catch { /* 忽略 */ }
  emit('logout')
}

/* ---------- 轻提示 ---------- */
const toastText = ref('')
let toastTimer = null

function toast (msg) {
  toastText.value = msg
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { toastText.value = '' }, 2200)
}

onMounted(() => {
  loadStats()
  load()
})
</script>

<template>
  <div class="admin">
    <nav class="admin-nav">
      <div class="admin-brand">
        <span class="admin-logo">⚙</span>
        <div>
          <b>后台管理系统</b>
          <small>伟大航道 · 首页数据管理</small>
        </div>
      </div>

      <div class="admin-user">
        <span class="admin-avatar">{{ (adminName || 'A').slice(0, 1) }}</span>
        <span class="admin-name">{{ adminName }}</span>
        <button class="admin-exit" type="button" @click="doLogout">退出后台</button>
      </div>
    </nav>

    <main class="admin-main">
      <!-- 数据总览 -->
      <div class="admin-stats">
        <div class="admin-stat" v-for="s in [
          { k: 'crewCount', label: '船员名册' },
          { k: 'routeCount', label: '航线图鉴' },
          { k: 'wantedCount', label: '悬赏令' },
          { k: 'shopCount', label: '杂货小镇' },
          { k: 'storyCount', label: '篇章故事' },
          { k: 'userCount', label: '注册船员' }
        ]" :key="s.k">
          <b>{{ stats[s.k] }}</b>
          <span>{{ s.label }}</span>
        </div>
      </div>

      <!-- 模块页签 -->
      <div class="admin-tabs">
        <button
          v-for="m in ADMIN_MODULES"
          :key="m.key"
          type="button"
          class="admin-tab"
          :class="{ active: active === m.key }"
          @click="switchModule(m.key)"
        >{{ m.icon }} {{ m.label }}</button>

        <button class="admin-new" type="button" @click="openNew">＋ 新增记录</button>
      </div>

      <!-- 数据表格 -->
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead>
            <tr>
              <th v-for="c in columns()" :key="c.key">{{ c.label }}</th>
              <th class="col-act">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="loading">
              <td :colspan="columns().length + 1" class="admin-loading">正在读取数据库……</td>
            </tr>
            <tr v-else-if="!rows.length">
              <td :colspan="columns().length + 1" class="admin-empty">暂无数据，点击右上角「＋ 新增记录」添加。</td>
            </tr>
            <tr v-for="r in rows" v-else :key="r.id">
              <td v-for="c in columns()" :key="c.key + r.id">
                <span v-if="c.key === 'bounty' || c.key === 'price'" class="admin-num">
                  ฿ {{ formatNumber(r[c.key]) }}
                </span>
                <span v-else class="admin-cell">{{ r[c.key] }}</span>
              </td>
              <td class="col-act">
                <button class="admin-btn edit" type="button" @click="openEdit(r)">编辑</button>
                <button class="admin-btn del" type="button" @click="remove(r)">删除</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <p class="admin-tip">这里的改动会立即写入数据库，前台首页与各功能页刷新后即可看到最新内容。</p>
    </main>

    <!-- 新增 / 编辑弹窗 -->
    <transition name="pop">
      <div v-if="editing" class="detail-mask" @click.self="closeEdit">
        <div class="admin-form">
          <h3>{{ editing.isNew ? '新增记录' : '编辑记录' }}</h3>

          <div class="admin-form-body">
            <div v-for="f in fields()" :key="f.key" class="admin-field" :class="{ wide: f.type === 'textarea' }">
              <label :for="'f_' + f.key">{{ f.label }}</label>
              <textarea
                v-if="f.type === 'textarea'"
                :id="'f_' + f.key"
                v-model="editing.data[f.key]"
                rows="3"
              ></textarea>
              <input
                v-else
                :id="'f_' + f.key"
                v-model="editing.data[f.key]"
                :type="f.type === 'number' ? 'number' : 'text'"
              >
            </div>
          </div>

          <div class="admin-form-foot">
            <button class="admin-btn cancel" type="button" @click="closeEdit">取消</button>
            <button class="admin-btn save" type="button" @click="submitEdit">保存</button>
          </div>
        </div>
      </div>
    </transition>

    <transition name="toast">
      <div v-if="toastText" class="toast">{{ toastText }}</div>
    </transition>
  </div>
</template>
