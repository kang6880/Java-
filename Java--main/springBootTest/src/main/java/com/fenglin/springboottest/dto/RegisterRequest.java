package com.fenglin.springboottest.dto;

/**
 * 注册请求参数
 * 前端（luffy-register-vue / RegisterForm.vue）提交的 JSON：
 * { "username": "航海士代号", "email": "贝利邮箱", "password": "船舱密钥" }
 */
public class RegisterRequest {

    /** 航海士代号 */
    private String username;
    /** 贝利邮箱 */
    private String email;
    /** 船舱密钥（明文，仅用于传输，落库前加密） */
    private String password;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
