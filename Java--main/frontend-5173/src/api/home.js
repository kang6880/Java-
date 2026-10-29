/**
 * 首页接口封装（统计 + 五个内容页 + 搜索），复用 user.js 的 request 与令牌
 *
 *  - GET /api/home/summary           首页统计 + 榜单（需登录）
 *  - GET /api/home/crews             船员名册
 *  - GET /api/home/routes           航线图鉴
 *  - GET /api/home/wanteds          悬赏令
 *  - GET /api/home/shops            杂货小镇
 *  - GET /api/home/stories          篇章故事
 *  - GET /api/home/search?keyword=  五路搜索（需登录）
 *  - formatBounty                   贝利金额格式化（万 / 亿）
 */
import { request } from './user.js'

export const homeApi = {
  /** 首页汇总：{ crewCount, roleCount, routeCount, wantedCount, shopCount, storyCount, topRoutes, topWanteds, topCrews, topStories } */
  summary () {
    return request('/api/home/summary', { auth: true })
  },

  /** 船员名册 */
  crews () {
    return request('/api/home/crews', { auth: true })
  },

  /** 航线图鉴 */
  routes () {
    return request('/api/home/routes', { auth: true })
  },

  /** 悬赏令 */
  wanteds () {
    return request('/api/home/wanteds', { auth: true })
  },

  /** 杂货小镇 */
  shops () {
    return request('/api/home/shops', { auth: true })
  },

  /** 篇章故事 */
  stories () {
    return request('/api/home/stories', { auth: true })
  },

  /** 全站搜索：{ routes, wanteds, crews, shops, stories, total } */
  search (keyword) {
    return request(`/api/home/search?keyword=${encodeURIComponent(keyword)}`, { auth: true })
  }
}

/**
 * 悬赏金额格式化
 *   3000000000 -> 「30亿贝利」
 *     36600000 -> 「3660万贝利」
 *         1000 -> 「1000贝利」
 */
export function formatBounty (bounty) {
  const n = Number(bounty)
  if (!Number.isFinite(n) || n <= 0) return '悬赏未知'
  if (n >= 100000000) {
    return `${trimZero(n / 100000000)}亿贝利`
  }
  if (n >= 10000) {
    return `${trimZero(n / 10000)}万贝利`
  }
  return `${n}贝利`
}

/** 千分位：3000000000 -> 3,000,000,000 */
export function formatNumber (n) {
  return Number(n || 0).toLocaleString()
}

/** 去掉小数位多余的 0：3000 -> 「3000」，36.6 -> 「36.6」 */
function trimZero (num) {
  return Number(num.toFixed(2)).toString()
}

export default homeApi
