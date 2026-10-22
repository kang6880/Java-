package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.ResetRequest;
import com.fenglin.springboottest.exception.BizException;
import com.fenglin.springboottest.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 密钥重置接口
 * 前端页面：luffy-vue 登录页「忘记密钥？罗宾帮你重置」弹窗，通过 Vite 代理 /api 转发到本服务（dev 环境端口 8081）
 */
@RestController
@RequestMapping("/api/user")
public class ResetController {

    /** 邮箱校验：与前端的 /^[^\s@]+@[^\s@]+\.[^\s@]+$/ 保持一致 */
    private static final String EMAIL_REGEX = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";

    @Autowired
    private UserService userService;

    /**
     * 密钥重置（代号 + 绑定邮箱双重验证）
     * POST /api/user/reset
     * 请求体：{"username":"...","email":"...","password":"新密钥"}
     * 成功返回：{"code":200,"msg":"success","data":null}
     */
    @PostMapping("/reset")
    public Result<Void> reset(@RequestBody ResetRequest req) {
        String username = req.getUsername() == null ? "" : req.getUsername().trim();
        String email = req.getEmail() == null ? "" : req.getEmail().trim();
        String password = req.getPassword() == null ? "" : req.getPassword();

        if (username.isEmpty()) {
            throw new BizException("请输入航海士代号");
        }
        if (!email.matches(EMAIL_REGEX)) {
            throw new BizException("邮箱格式不正确");
        }
        if (password.length() < 6) {
            throw new BizException("新密钥至少 6 位");
        }

        userService.resetPassword(username, email, password);
        return Result.ok();
    }
}
