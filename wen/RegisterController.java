package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.ApiResult;
import com.fenglin.springboottest.dto.RegisterRequest;
import com.fenglin.springboottest.service.UserService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 注册接口（兼容 fanren-login-vue 等前端）
 *
 * 同时映射以下路径，前端用哪个都能接到：
 *   POST /api/auth/register
 *   POST /api/user/register
 *   POST /api/register
 *   POST /user/register
 *
 * 同时支持三种传参方式：
 *   1) application/json  → {"username":"xx","password":"xx"}
 *   2) 表单 x-www-form-urlencoded / form-data
 *   3) GET query（仅方便自测，生产可删除）
 *
 * 字段名做了大小写与命名兼容：
 *   username / userName / user_name / account / loginName / name
 *   password / pwd / userPassword
 *   confirmPassword / repassword / password2
 *   email / mail
 *   phone / mobile / tel / phoneNumber
 *   nickname / nickName / realName
 */
@RestController
public class RegisterController {

    /** 注册接口路径（多个别名） */
    private static final String[] REGISTER_PATHS = {
            "/api/auth/register",
            "/api/user/register",
            "/api/register",
            "/user/register"
    };

    private final UserService userService;

    public RegisterController(UserService userService) {
        this.userService = userService;
    }

    /** 1) JSON 请求体 */
    @PostMapping(value = {"/api/auth/register", "/api/user/register", "/api/register", "/user/register"},
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ApiResult<Map<String, Object>> registerByJson(@RequestBody(required = false) Map<String, Object> body) {
        return userService.register(buildRequest(toStringMap(body)));
    }

    /** 2) 表单请求（form-urlencoded / form-data） */
    @PostMapping(value = {"/api/auth/register", "/api/user/register", "/api/register", "/user/register"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ApiResult<Map<String, Object>> registerByForm(@RequestParam(required = false) Map<String, String> params) {
        return userService.register(buildRequest(params));
    }

    /** 3) GET 便捷自测：/api/user/register?username=xx&password=xx */
    @GetMapping(value = {"/api/auth/register", "/api/user/register", "/api/register", "/user/register"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ApiResult<Map<String, Object>> registerByGet(@RequestParam(required = false) Map<String, String> params) {
        return userService.register(buildRequest(params));
    }

    /** 健康检查：确认后端活着 */
    @GetMapping(value = {"/api/user/ping", "/api/ping"}, produces = MediaType.APPLICATION_JSON_VALUE)
    public ApiResult<Map<String, Object>> ping() {
        Map<String, Object> data = new HashMap<>();
        data.put("service", "springBootTest");
        data.put("status", "UP");
        return ApiResult.ok("服务正常", data);
    }

    // ---------- 工具方法 ----------

    private static RegisterRequest buildRequest(Map<String, String> map) {
        RegisterRequest req = new RegisterRequest();
        if (map == null || map.isEmpty()) {
            return req;
        }
        req.setUsername(pick(map, "username", "userName", "user_name", "account", "loginName", "login_name", "name"));
        req.setPassword(pick(map, "password", "passWord", "pwd", "userPassword", "user_password", "password1"));
        req.setConfirmPassword(pick(map, "confirmPassword", "confirm_password", "repassword", "rePassword", "password2"));
        req.setEmail(pick(map, "email", "mail", "userEmail", "user_email"));
        req.setPhone(pick(map, "phone", "mobile", "tel", "telephone", "phoneNumber", "phone_number"));
        req.setNickname(pick(map, "nickname", "nickName", "nick", "realName", "real_name"));
        return req;
    }

    /** 忽略大小写取第一个非空值 */
    private static String pick(Map<String, String> map, String... keys) {
        for (String key : keys) {
            for (Map.Entry<String, String> entry : map.entrySet()) {
                String k = entry.getKey();
                if (k != null && k.equalsIgnoreCase(key)) {
                    String v = entry.getValue();
                    if (v != null && !v.isBlank()) {
                        return v.trim();
                    }
                }
            }
        }
        return null;
    }

    private static Map<String, String> toStringMap(Map<String, Object> body) {
        Map<String, String> result = new HashMap<>();
        if (body == null) {
            return result;
        }
        for (Map.Entry<String, Object> entry : body.entrySet()) {
            Object v = entry.getValue();
            result.put(entry.getKey(), v == null ? null : String.valueOf(v));
        }
        return result;
    }
}
