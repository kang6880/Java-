package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.exception.BizException;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * 船员名册业务实现
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    /**
     * BCrypt 加密器：加盐哈希，同一明文每次加密结果都不同，
     * 校验用 encoder.matches(明文, 密文)，无法反推明文。
     */
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public User register(String username, String email, String rawPassword) {
        // 1. 代号查重
        Long usernameCount = userMapper.selectCount(
                new LambdaQueryWrapper<User>().eq(User::getUsername, username));
        if (usernameCount != null && usernameCount > 0) {
            throw new BizException("代号「" + username + "」已被占用，换一个吧");
        }

        // 2. 邮箱查重
        Long emailCount = userMapper.selectCount(
                new LambdaQueryWrapper<User>().eq(User::getEmail, email));
        if (emailCount != null && emailCount > 0) {
            throw new BizException("该邮箱已经登记过了，直接登录吧");
        }

        // 3. 落库（密钥加密后存储）
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(rawPassword));
        userMapper.insert(user);

        // 4. 回查补全 create_time 等数据库默认值，并抹掉密文
        User saved = userMapper.selectById(user.getId());
        saved.setPassword(null);
        return saved;
    }

    @Override
    public User login(String account, String rawPassword) {
        // 1. 按代号或邮箱查用户（两列都有唯一索引，最多一条）
        User user = userMapper.selectOne(
                new LambdaQueryWrapper<User>()
                        .eq(User::getUsername, account)
                        .or()
                        .eq(User::getEmail, account));

        // 2. 统一提示「代号或密钥不正确」，不区分是哪种错，避免暴露账号是否存在
        if (user == null) {
            throw new BizException("代号或密钥不正确，再想想");
        }

        // 3. BCrypt 比对：同一明文每次加密结果不同，只能用 matches 验证，不能查库比对
        if (!passwordEncoder.matches(rawPassword, user.getPassword())) {
            throw new BizException("代号或密钥不正确，再想想");
        }

        user.setPassword(null);
        return user;
    }

    @Override
    public void resetPassword(String username, String email, String rawPassword) {
        // 1. 按代号查用户
        User user = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getUsername, username));

        // 2. 代号 + 绑定邮箱双重验证（忽略邮箱大小写），不匹配时统一拒绝，避免泄露账号信息
        if (user == null || !user.getEmail().equalsIgnoreCase(email)) {
            throw new BizException("代号与绑定邮箱不匹配，罗宾小姐拒绝为你重置");
        }

        // 3. 设置新密钥（BCrypt 加密后更新）
        User update = new User();
        update.setId(user.getId());
        update.setPassword(passwordEncoder.encode(rawPassword));
        userMapper.updateById(update);
    }
}
