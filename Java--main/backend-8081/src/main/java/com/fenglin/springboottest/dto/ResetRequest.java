package com.fenglin.springboottest.dto;

/**
 * 密钥重置请求参数
 * 前端（luffy-vue / ResetModal.vue）提交的 JSON：
 * { "username": "航海士代号", "email": "绑定的贝利邮箱", "password": "新密钥" }
 */
public class ResetRequest {

    /** 航海士代号 */
    private String username;
    /** 绑定的贝利邮箱（与代号双重验证身份） */
    private String email;
    /** 新船舱密钥（明文，仅用于传输，落库前加密） */
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
