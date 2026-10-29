package com.fenglin.springboottest.common;

import org.springframework.stereotype.Component;

/**
 * 后台管理员令牌仓库
 *
 * <p>与前台船员用的 TokenStore 完全隔离：各自维护一张内存表，
 * 避免船员令牌被拿去操作后台接口（两个入口的账号体系互不相通）。</p>
 *
 * <p>实现上直接继承 TokenStore 的签发 / 校验 / 注销逻辑，
 * 只是作为独立 Bean 持有另一份 sessions 映射。</p>
 */
@Component
public class AdminTokenStore extends TokenStore {
}
