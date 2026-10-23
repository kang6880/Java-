package com.fenglin.springboottest.dto;

/**
 * 修改密钥请求参数
 * 前端提交的 JSON：
 * { "oldPassword": "当前密钥", "newPassword": "新密钥" }
 */
public class ChangePasswordRequest {

    /** 当前船舱密钥（明文，服务端用 BCrypt 比对） */
    private String oldPassword;
    /** 新船舱密钥（明文，落库前加密） */
    private String newPassword;

    public String getOldPassword() {
        return oldPassword;
    }

    public void setOldPassword(String oldPassword) {
        this.oldPassword = oldPassword;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }
}
