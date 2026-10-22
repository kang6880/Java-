package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.LoginRequest;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.exception.BizException;
import com.fenglin.springboottest.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 船员登船验证接口（登录）
 * 前端页面：luffy-register-vue 的「返回登录」页，通过 Vite 代理 /api 转发到本服务（端口 8081）
 */
@RestController
@RequestMapping("/api/user")
public class LoginController {

    @Autowired
    private UserService userService;

    /**
     * 登船验证
     * POST /api/user/login
     * 请求体：{"account":"代号或邮箱","password":"..."}（兼容 {"username":"...","password":"..."}）
     * 成功返回：{"code":200,"msg":"success","data":{"id":1,"username":"...","email":"...","createTime":"..."}}
     */
    @PostMapping("/login")
    public Result<User> login(@RequestBody LoginRequest req) {
        String account = req.getEffectiveAccount() == null ? "" : req.getEffectiveAccount().trim();
        String password = req.getPassword() == null ? "" : req.getPassword();

        if (account.isEmpty()) {
            throw new BizException("请输入航海士代号或贝利邮箱");
        }
        if (password.isEmpty()) {
            throw new BizException("请输入船舱密钥");
        }

        User user = userService.login(account, password);
        return Result.ok(user);
    }
}
