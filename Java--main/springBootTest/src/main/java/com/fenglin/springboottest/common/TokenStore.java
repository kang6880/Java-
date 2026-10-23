package com.fenglin.springboottest.common;

import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 登录令牌仓库（内存实现）
 *
 * <p>设计说明：本项目为教学/单机演示，没有引入 Redis 或 JWT，
 * 因此用 ConcurrentHashMap 在内存中保存「令牌 -> 船员代号」的映射。
 * 服务重启后所有令牌失效，前端重新登录即可。</p>
 *
 * <p>为什么不用 JWT：JWT 无法主动失效（退出登录只是前端删掉本地副本），
 * 而内存令牌表可以真正做到注销即失效；代价是不支持多实例部署。</p>
 */
@Component
public class TokenStore {

    /** 令牌有效期：7 天（毫秒） */
    private static final long TTL_MILLIS = 7L * 24 * 60 * 60 * 1000;

    /** 令牌 -> 会话信息 */
    private final Map<String, Session> sessions = new ConcurrentHashMap<>();

    /**
     * 为指定船员颁发一枚新令牌
     *
     * @param username 航海士代号
     * @return 令牌字符串（UUID 去掉横线，32 位）
     */
    public String issue(String username) {
        String token = UUID.randomUUID().toString().replace("-", "");
        sessions.put(token, new Session(username, System.currentTimeMillis() + TTL_MILLIS));
        return token;
    }

    /**
     * 校验令牌是否有效，并返回对应的船员代号
     *
     * @param token 前端通过 X-Token 请求头带来的令牌
     * @return 有效时返回航海士代号；令牌为空、不存在或已过期返回 null
     */
    public String verify(String token) {
        if (token == null || token.trim().isEmpty()) {
            return null;
        }
        Session session = sessions.get(token.trim());
        if (session == null) {
            return null;
        }
        // 过期即视为无效，顺手清理
        if (session.expireAt < System.currentTimeMillis()) {
            sessions.remove(token.trim());
            return null;
        }
        return session.username;
    }

    /**
     * 注销单个令牌（退出登录）
     *
     * @param token 要作废的令牌
     */
    public void remove(String token) {
        if (token != null) {
            sessions.remove(token.trim());
        }
    }

    /**
     * 作废某个船员名下的全部令牌（例如修改密钥后强制重新登录）
     *
     * @param username 航海士代号
     */
    public void removeByUsername(String username) {
        if (username == null) {
            return;
        }
        sessions.entrySet().removeIf(e -> username.equals(e.getValue().username));
    }

    /** 当前在线令牌数量，仅用于调试观察 */
    public int size() {
        return sessions.size();
    }

    /** 会话：船员代号 + 过期时间戳 */
    private static final class Session {
        private final String username;
        private final long expireAt;

        private Session(String username, long expireAt) {
            this.username = username;
            this.expireAt = expireAt;
        }
    }
}
