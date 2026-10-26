/**
 * 船员名册接口封装
 *
 * 约定：
 *  - 开发环境由 Vite 代理把 /api 转发到 http://localhost:8081（见 vite.config.js）
 *  - 后端统一返回 { code, msg, data }，code === 200 表示成功
 *  - 登录令牌保存在 localStorage，请求时放在 X-Token 请求头
 */

const BASE_URL = '/api/user'

/** localStorage 中存放登录令牌的键名 */
const TOKEN_KEY = 'luffy_token'
/** localStorage 中存放当前船员档案的键名 */
const PROFILE_KEY = 'luffy_profile'

/* ---------------- 令牌与档案的本地存取 ---------------- */

export function getToken () {
  return localStorage.getItem(TOKEN_KEY) || ''
}

export function setToken (token) {
  if (token) {
    localStorage.setItem(TOKEN_KEY, token)
  }
}

export function saveProfile (profile) {
  if (profile) {
    localStorage.setItem(PROFILE_KEY, JSON.stringify(profile))
  }
}

export function getProfile () {
  const raw = localStorage.getItem(PROFILE_KEY)
  try {
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

export function clearAuth () {
  localStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(PROFILE_KEY)
}

/* ---------------- 底层请求 ---------------- */

/**
 * 发起一次请求并拆包 Result（供本模块与 home.js 等复用）
 * @param {string} path  完整的 /api 相对路径，例如 '/user/login'
 * @param {object} options { method, body, auth }
 * @returns {Promise<any>} 成功时返回 Result.data
 */
export async function request (path, { method = 'GET', body, auth = false } = {}) {
  const headers = {}
  if (body !== undefined) {
    headers['Content-Type'] = 'application/json'
  }
  // 需要登录态的接口带上令牌
  const token = getToken()
  if ((auth || token) && token) {
    headers['X-Token'] = token
  }

  let res
  try {
    // 已带 /api 前缀的完整路径直接使用（供 home.js 等其他模块复用），否则默认挂在 /api/user 下
    const url = path.startsWith('/api') ? path : BASE_URL + path
    res = await fetch(url, {
      method,
      headers,
      body: body === undefined ? undefined : JSON.stringify(body)
    })
  } catch {
    // fetch 抛错一般意味着后端没启动或网络不通
    throw new Error('连不上后端服务，确认 springBootTest 已在 8081 端口启动')
  }

  // 令牌失效：后端返回 401
  if (res.status === 401) {
    clearAuth()
    throw new Error('登录已过期，请重新登录')
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

/* ---------------- 业务接口 ---------------- */

export const userApi = {
  /** 登船注册 → 返回落库后的用户档案 */
  register ({ username, email, password }) {
    return request('/register', { method: 'POST', body: { username, email, password } })
  },

  /** 登船验证 → 返回 { token, username, email, createTime } */
  async login ({ account, password }) {
    const data = await request('/login', { method: 'POST', body: { account, password } })
    if (data && data.token) {
      setToken(data.token)
      saveProfile({ username: data.username, email: data.email, createTime: data.createTime })
    }
    return data
  },

  /** 密钥重置（代号 + 绑定邮箱双重验证） */
  resetPassword ({ username, email, password }) {
    return request('/reset', { method: 'POST', body: { username, email, password } })
  },

  /** 查询当前登录船员档案（需登录） */
  profile () {
    return request('/profile', { auth: true })
  },

  /** 修改船舱密钥（需登录，成功后旧令牌失效） */
  changePassword ({ oldPassword, newPassword }) {
    return request('/change-password', { method: 'POST', body: { oldPassword, newPassword }, auth: true })
  },

  /** 退出登船（需登录） */
  async logout () {
    try {
      await request('/logout', { method: 'POST', auth: true })
    } finally {
      clearAuth()
    }
  }
}

export default userApi
