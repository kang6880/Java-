package com.fenglin.springboottest.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 跨域配置 + 登录态拦截
 * 开发时前端走 Vite 代理（同源），一般用不到；
 * 但直接打开前端页面（不同端口/不同主机）时会用到，故一并放开 /api/**。
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private LoginInterceptor loginInterceptor;

    @Autowired
    private AdminLoginInterceptor adminLoginInterceptor;

    /** 需要登录态的接口：档案查询、修改密钥、退出登船、首页展示与搜索（注册/登录/重置不拦截） */
    private static final String[] PROTECTED_PATHS = {
            "/api/user/profile",
            "/api/user/change-password",
            "/api/user/logout",
            "/api/home/**"
    };

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                .addPathPatterns(PROTECTED_PATHS);

        // 后台接口统一守卫，登录接口自身排除在外
        registry.addInterceptor(adminLoginInterceptor)
                .addPathPatterns("/api/admin/**")
                .excludePathPatterns("/api/admin/login");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // 开发/本地调试：放行所有本机来源（含 127.0.0.1、localhost、局域网/虚拟网卡 IP），
        // 避免前端经不同 IP（如 192.168.x.x:5173）访问时偶发 CORS 拒绝导致「有时注册/登录失败」
        registry.addMapping("/api/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }
}
