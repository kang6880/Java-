package com.fenglin.springboottest.config;

import com.fenglin.springboottest.common.TokenStore;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.nio.charset.StandardCharsets;

/**
 * 登录态拦截器
 *
 * <p>负责校验请求头中的令牌，只对 WebConfig 里登记的受保护接口生效
 * （档案查询 / 修改密钥 / 退出登船）。注册、登录、重置密钥是公开接口，不拦。</p>
 *
 * <p>令牌约定：前端从 localStorage 取出登录时拿到的 token，
 * 放在请求头 {@code X-Token} 中；同时兼容 {@code Authorization: Bearer <token>}。</p>
 */
@Component
public class LoginInterceptor implements HandlerInterceptor {

    /** 令牌请求头名称 */
    public static final String TOKEN_HEADER = "X-Token";

    /** 校验通过后，把船员代号放进 request 属性，供 Controller 取用 */
    public static final String ATTR_USERNAME = "loginUsername";

    @Autowired
    private TokenStore tokenStore;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        // 预检请求直接放行，否则跨域时浏览器拿不到响应
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String username = tokenStore.verify(resolveToken(request));
        if (username == null) {
            writeUnauthorized(response);
            return false;
        }

        request.setAttribute(ATTR_USERNAME, username);
        return true;
    }

    /**
     * 从请求头中提取令牌
     * 优先 X-Token，其次 Authorization: Bearer xxx
     */
    private String resolveToken(HttpServletRequest request) {
        String token = request.getHeader(TOKEN_HEADER);
        if (token != null && !token.trim().isEmpty()) {
            return token;
        }
        String authorization = request.getHeader("Authorization");
        if (authorization != null && authorization.regionMatches(true, 0, "Bearer ", 0, 7)) {
            return authorization.substring(7);
        }
        return null;
    }

    /**
     * 401 响应体，格式与 Result 保持一致，前端可按 code 统一处理
     * 注意：拦截器返回的是原始 JSON，不经过 Controller 返回值序列化，故手写字符串
     */
    private void writeUnauthorized(HttpServletResponse response) throws Exception {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"code\":401,\"msg\":\"登录已过期，请重新登船\",\"data\":null}");
        response.getWriter().flush();
    }
}
