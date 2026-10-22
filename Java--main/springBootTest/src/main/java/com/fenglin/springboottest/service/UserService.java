package com.fenglin.springboottest.service;

import com.fenglin.springboottest.entity.User;

/**
 * 船员名册业务接口
 */
public interface UserService {

    /**
     * 注册一名船员
     *
     * @param username    航海士代号（已去空格）
     * @param email       贝利邮箱（已去空格）
     * @param rawPassword 船舱密钥明文
     * @return 落库后的用户对象（含自增 id 与登记时间）
     */
    User register(String username, String email, String rawPassword);

    /**
     * 船员登船验证（登录）
     *
     * @param account     航海士代号或贝利邮箱（已去空格）
     * @param rawPassword 船舱密钥明文
     * @return 校验通过的用户对象（不含密钥密文）
     */
    User login(String account, String rawPassword);

    /**
     * 密钥重置：航海士代号 + 绑定邮箱双重验证后设置新密钥
     *
     * @param username    航海士代号（已去空格）
     * @param email       绑定的贝利邮箱（已去空格）
     * @param rawPassword 新密钥明文
     */
    void resetPassword(String username, String email, String rawPassword);
}
