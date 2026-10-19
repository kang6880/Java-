package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.RegisterRequest;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.exception.BizException;
import com.fenglin.springboottest.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 船员招募登记接口
 * 前端页面：luffy-register-vue（Vue3），通过 Vite 代理 /api 转发到本服务（dev 环境端口 8081）
 */
@RestController
@RequestMapping("/api/user")
public class RegisterController {

    /** 邮箱校验：与前端的 /^[^\s@]+@[^\s@]+\.[^\s@]+$/ 保持一致 */
    private static final String EMAIL_REGEX = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";

    @Autowired
    private UserService userService;

    /**
     * 登船注册
     * POST /api/user/register
     * 请求体：{"username":"...","email":"...","password":"..."}
     * 返回：{"code":200,"msg":"success","data":{"id":1,"username":"...","email":"...","createTime":"..."}}
     */
    @PostMapping("/register")
    public Result<User> register(@RequestBody RegisterRequest req) {
        String username = req.getUsername() == null ? "" : req.getUsername().trim();
        String email = req.getEmail() == null ? "" : req.getEmail().trim();
        String password = req.getPassword() == null ? "" : req.getPassword();

        // 服务端兜底校验（前端已校验，但接口不能信任前端）
        if (username.length() < 3) {
            throw new BizException("代号至少 3 个字符");
        }
        if (username.length() > 50) {
            throw new BizException("代号最长 50 个字符");
        }
        if (!email.matches(EMAIL_REGEX)) {
            throw new BizException("邮箱格式不正确");
        }
        if (email.length() > 100) {
            throw new BizException("邮箱最长 100 个字符");
        }
        if (password.length() < 6) {
            throw new BizException("密钥至少 6 位");
        }

        User user = userService.register(username, email, password);
        return Result.ok(user);
    }
}
