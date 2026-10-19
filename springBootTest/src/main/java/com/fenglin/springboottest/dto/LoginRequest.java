package com.fenglin.springboottest.dto;

/**
 * 登录请求参数
 * 前端（luffy-register-vue / LoginForm.vue）提交的 JSON：
 * { "username": "航海士代号", "password": "船舱密钥" }
 */
public class LoginRequest {

    /** 航海士代号（注册时登记的代号，即登录账号） */
    private String username;
    /** 船舱密钥（明文，服务端用 BCrypt 与库中密文比对） */
    private String password;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
