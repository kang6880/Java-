package com.fenglin.springboottest.config;

import com.fenglin.springboottest.common.AdminTokenStore;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 后台登录态拦截器
 *
 * <p>只守卫 WebConfig 里登记的 /api/admin/**（登录接口本身被排除）。
 * 用的是管理员专属令牌表 AdminTokenStore，船员令牌在后台一律无效。</p>
 */
@Component
public class AdminLoginInterceptor implements HandlerInterceptor {

    /** 令牌请求头名称（与前台一致，便于前端 request 复用） */
    public static final String TOKEN_HEADER = "X-Token";

    /** 校验通过后，把管理员账号放进 request 属性 */
    public static final String ATTR_USERNAME = "adminUsername";

    @Autowired
    private AdminTokenStore adminTokenStore;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String username = adminTokenStore.verify(resolveToken(request));
        if (username == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"msg\":\"后台登录已过期，请重新登录\",\"data\":null}");
            response.getWriter().flush();
            return false;
        }

        request.setAttribute(ATTR_USERNAME, username);
        return true;
    }

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
}
