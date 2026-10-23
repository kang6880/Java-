package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.common.TokenStore;
import com.fenglin.springboottest.config.LoginInterceptor;
import com.fenglin.springboottest.dto.ChangePasswordRequest;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.exception.BizException;
import com.fenglin.springboottest.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 船员档案接口（需要登录态）
 * 这三个接口被 WebConfig 登记为受保护路径，必须携带 X-Token 请求头，
 * 拦截器校验通过后会把船员代号写入 request 属性 loginUsername。
 */
@RestController
@RequestMapping("/api/user")
public class ProfileController {

    @Autowired
    private UserService userService;

    @Autowired
    private TokenStore tokenStore;

    /**
     * 查询当前登录船员的档案
     * GET /api/user/profile
     * 返回：{"code":200,"msg":"success","data":{"id":1,"username":"...","email":"...","createTime":"..."}}
     */
    @GetMapping("/profile")
    public Result<User> profile(HttpServletRequest request) {
        return Result.ok(userService.profile(currentUsername(request)));
    }

    /**
     * 修改船舱密钥
     * POST /api/user/change-password
     * 请求体：{"oldPassword":"...","newPassword":"..."}
     * 修改成功后旧令牌全部作废，前端需要重新登录
     */
    @PostMapping("/change-password")
    public Result<Void> changePassword(@RequestBody ChangePasswordRequest req, HttpServletRequest request) {
        String oldPassword = req.getOldPassword() == null ? "" : req.getOldPassword();
        String newPassword = req.getNewPassword() == null ? "" : req.getNewPassword();

        if (oldPassword.isEmpty()) {
            throw new BizException("请输入当前船舱密钥");
        }
        if (newPassword.length() < 6) {
            throw new BizException("新密钥至少 6 位");
        }
        if (oldPassword.equals(newPassword)) {
            throw new BizException("新密钥不能与当前密钥相同");
        }

        String username = currentUsername(request);
        userService.changePassword(username, oldPassword, newPassword);

        // 密钥已变更，作废该船员名下所有令牌，强制重新登录
        tokenStore.removeByUsername(username);
        return Result.ok();
    }

    /**
     * 退出登船（注销当前令牌）
     * POST /api/user/logout
     * 返回：{"code":200,"msg":"success","data":null}
     */
    @PostMapping("/logout")
    public Result<Void> logout(HttpServletRequest request) {
        // 拦截器已保证令牌有效，这里直接作废
        tokenStore.remove(request.getHeader(LoginInterceptor.TOKEN_HEADER));
        return Result.ok();
    }

    /** 取出拦截器写入的船员代号 */
    private String currentUsername(HttpServletRequest request) {
        Object username = request.getAttribute(LoginInterceptor.ATTR_USERNAME);
        if (username == null) {
            // 理论上不会走到这里（拦截器已拦），兜底防止空指针
            throw new BizException(401, "登录已过期，请重新登船");
        }
        return username.toString();
    }
}
