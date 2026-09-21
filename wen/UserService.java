package com.fenglin.springboottest.service;

import com.fenglin.springboottest.common.ApiResult;
import com.fenglin.springboottest.dto.RegisterRequest;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 用户业务：注册（校验 + 查重 + BCrypt 加密 + 落库）
 */
@Service
public class UserService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * 用户注册
     */
    public ApiResult<Map<String, Object>> register(RegisterRequest req) {
        if (req == null) {
            return ApiResult.fail(400, "请求参数不能为空");
        }

        String username = trim(req.getUsername());
        String password = req.getPassword();

        // ---- 参数校验 ----
        if (!StringUtils.hasText(username)) {
            return ApiResult.fail(400, "用户名不能为空");
        }
        if (username.length() < 3 || username.length() > 50) {
            return ApiResult.fail(400, "用户名长度需为 3~50 个字符");
        }
        if (!username.matches("[a-zA-Z0-9_\\u4e00-\\u9fa5]+")) {
            return ApiResult.fail(400, "用户名只能包含字母、数字、下划线或中文");
        }
        if (!StringUtils.hasText(password)) {
            return ApiResult.fail(400, "密码不能为空");
        }
        if (password.length() < 6 || password.length() > 32) {
            return ApiResult.fail(400, "密码长度需为 6~32 位");
        }
        String confirm = req.getConfirmPassword();
        if (StringUtils.hasText(confirm) && !password.equals(confirm)) {
            return ApiResult.fail(400, "两次输入的密码不一致");
        }

        // ---- 查重 ----
        if (userRepository.existsByUsername(username)) {
            return ApiResult.fail(409, "用户名已被注册");
        }

        String email = trim(req.getEmail());
        if (StringUtils.hasText(email)) {
            if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                return ApiResult.fail(400, "邮箱格式不正确");
            }
            if (userRepository.existsByEmail(email)) {
                return ApiResult.fail(409, "邮箱已被注册");
            }
        }

        String phone = trim(req.getPhone());
        if (StringUtils.hasText(phone)) {
            if (!phone.matches("^1[3-9]\\d{9}$")) {
                return ApiResult.fail(400, "手机号格式不正确");
            }
            if (userRepository.existsByPhone(phone)) {
                return ApiResult.fail(409, "手机号已被注册");
            }
        }

        // ---- 落库 ----
        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        String nickname = trim(req.getNickname());
        user.setNickname(StringUtils.hasText(nickname) ? nickname : username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setStatus(1);
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());

        try {
            User saved = userRepository.save(user);
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("id", saved.getId());
            data.put("username", saved.getUsername());
            data.put("nickname", saved.getNickname());
            data.put("email", saved.getEmail());
            data.put("phone", saved.getPhone());
            data.put("createTime", saved.getCreateTime() == null ? null : saved.getCreateTime().toString());
            log.info("注册成功：username={}, id={}", saved.getUsername(), saved.getId());
            return ApiResult.ok("注册成功", data);
        } catch (DataIntegrityViolationException e) {
            log.warn("注册冲突：username={}", username);
            return ApiResult.fail(409, "用户名或邮箱已被注册");
        } catch (Exception e) {
            log.error("注册失败：username=" + username, e);
            return ApiResult.fail(500, "注册失败：" + e.getMessage());
        }
    }

    private static String trim(String s) {
        return s == null ? null : s.trim();
    }
}
