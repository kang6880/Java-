-- ============================================================
-- 航海王 · 船员招募登记 —— 数据库初始化脚本
-- 前端页面：Desktop/luffy-register-vue（Vue3 + Vite）
-- 后端接口：POST /api/user/register
-- 字符集：utf8mb4（支持中文与 emoji）
-- 执行方式：
--   mysql -uroot -p123456 --default-character-set=utf8mb4 < luffy_register.sql
-- 或在 Navicat / IDEA Database 中直接运行本文件
-- ============================================================

-- 1. 创建数据库（若不存在）
CREATE DATABASE IF NOT EXISTS `springboottest`
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_general_ci;

USE `springboottest`;

-- 2. 船员名册表
--    说明：表名用 sys_user 而不是 user，因为 user 是 MySQL 保留字，直接建表会报语法错误
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`
(
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `username`    VARCHAR(50)  NOT NULL COMMENT '航海士代号（登录账号，唯一）',
    `email`       VARCHAR(100) NOT NULL COMMENT '贝利邮箱（唯一）',
    `password`    VARCHAR(100) NOT NULL COMMENT '船舱密钥（BCrypt 加密后存储，不可逆）',
    `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登记时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_sys_user_username` (`username`),
    UNIQUE KEY `uk_sys_user_email` (`email`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='船员名册（注册用户表）';

-- 3. 插入一条演示数据（可选）
--    密码明文为 123456，入库的是 BCrypt 密文（已用 Spring 的 BCryptPasswordEncoder 校验通过）
INSERT INTO `sys_user` (`username`, `email`, `password`)
VALUES ('路飞', 'luffy@onepiece.com', '$2b$10$izOLX7eLglz39jM2R9IVPekziQOOddxJV47S08pHjRCbOIdbbZRvK');

-- 4. 校验
SELECT `id`, `username`, `email`, `create_time` FROM `sys_user`;
