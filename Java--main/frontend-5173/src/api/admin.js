/**
 * 后台管理系统接口封装
 *
 *  - POST /api/admin/login                 登录（公开，后台无注册）
 *  - POST /api/admin/logout                退出
 *  - GET  /api/admin/stats                 数据总览
 *  - GET/POST/PUT/DELETE /api/admin/{模块}   五模块增删改查
 *
 * 后台令牌与前台船员令牌分开存放（localStorage 键名不同），互不干扰
 */
/** 后台令牌 localStorage 键名 */
export const ADMIN_TOKEN_KEY = 'luffy_admin_token'
/** 后台管理员档案键名 */
export const ADMIN_PROFILE_KEY = 'luffy_admin_profile'

export function getAdminToken () {
  return localStorage.getItem(ADMIN_TOKEN_KEY) || ''
}

export function setAdminToken (token) {
  if (token) localStorage.setItem(ADMIN_TOKEN_KEY, token)
}

export function getAdminProfile () {
  const raw = localStorage.getItem(ADMIN_PROFILE_KEY)
  try {
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

export function clearAdminAuth () {
  localStorage.removeItem(ADMIN_TOKEN_KEY)
  localStorage.removeItem(ADMIN_PROFILE_KEY)
}

/**
 * 后台专用请求：令牌存于独立的 localStorage 键，不会带上前台船员令牌
 */
async function adminRequest (path, { method = 'GET', body } = {}) {
  const headers = {}
  if (body !== undefined) headers['Content-Type'] = 'application/json'

  const token = getAdminToken()
  if (token) headers['X-Token'] = token

  let res
  try {
    res = await fetch(path, {
      method,
      headers,
      body: body === undefined ? undefined : JSON.stringify(body)
    })
  } catch {
    throw new Error('连不上后端服务，确认 springBootTest 已在 8081 端口启动')
  }

  if (res.status === 401) {
    clearAdminAuth()
    throw new Error('后台登录已过期，请重新登录')
  }

  let payload
  try {
    payload = await res.json()
  } catch {
    throw new Error(`服务端返回了无法解析的内容（HTTP ${res.status}）`)
  }

  if (!payload || payload.code !== 200) {
    const err = new Error((payload && payload.msg) || `请求失败（HTTP ${res.status}）`)
    err.code = payload ? payload.code : res.status
    throw err
  }
  return payload.data
}

/** 五个可管理的数据模块 */
export const ADMIN_MODULES = [
  { key: 'crews', label: '船员名册', icon: '⚓' },
  { key: 'routes', label: '航线图鉴', icon: '🗺️' },
  { key: 'wanteds', label: '悬赏令', icon: '🏴‍☠️' },
  { key: 'shops', label: '杂货小镇', icon: '🏪' },
  { key: 'stories', label: '篇章故事', icon: '📖' }
]

export const adminApi = {
  /** 后台登录（仅登录） */
  async login ({ username, password }) {
    const data = await adminRequest('/api/admin/login', { method: 'POST', body: { username, password } })
    if (data && data.token) {
      setAdminToken(data.token)
      localStorage.setItem(ADMIN_PROFILE_KEY, JSON.stringify({
        username: data.username,
        realName: data.realName
      }))
    }
    return data
  },

  /** 退出后台 */
  async logout () {
    try {
      await adminRequest('/api/admin/logout', { method: 'POST' })
    } finally {
      clearAdminAuth()
    }
  },

  /** 数据总览 */
  stats () {
    return adminRequest('/api/admin/stats')
  },

  /** 列表 */
  list (module) {
    return adminRequest(`/api/admin/${module}`)
  },

  /** 新增（body 不带 id） */
  save (module, entity) {
    const body = { ...entity }
    delete body.id
    return adminRequest(`/api/admin/${module}`, { method: 'POST', body })
  },

  /** 修改（body 带 id） */
  update (module, entity) {
    return adminRequest(`/api/admin/${module}`, { method: 'PUT', body: entity })
  },

  /** 删除 */
  remove (module, id) {
    return adminRequest(`/api/admin/${module}/${id}`, { method: 'DELETE' })
  }
}

export default adminApi
