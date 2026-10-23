package com.fenglin.springboottest.dto;

/**
 * 登录请求参数
 * 前端（luffy-vue / LoginView.vue）提交的 JSON：
 * { "account": "航海士代号或贝利邮箱", "password": "船舱密钥" }
 * 兼容旧页面：也接受 { "username": "...", "password": "..." }
 */
public class LoginRequest {

    /** 登录账号：航海士代号或贝利邮箱（新前端使用） */
    private String account;
    /** 航海士代号（旧版页面兼容字段，account 为空时启用） */
    private String username;
    /** 船舱密钥（明文，服务端用 BCrypt 与库中密文比对） */
    private String password;

    /** 取有效登录账号：优先 account，为空则回退 username */
    public String getEffectiveAccount() {
        return (account == null || account.trim().isEmpty()) ? username : account;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

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
