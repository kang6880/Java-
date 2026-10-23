-- ============================================================
-- 航海王 · 船员名册 —— 数据库初始化脚本
-- 后端：springBootTest（Spring Boot 3 + MyBatis-Plus）端口 8081
-- 前端：luffy-vue（Vue3 + Vite）/ Luffy.html（单文件页）
-- 字符集：utf8mb4（支持中文与 emoji）
--
-- 【执行方式】
--   1) 命令行：mysql -uroot -p123456 --default-character-set=utf8mb4 < luffy_register.sql
--   2) Navicat / IDEA Database 中打开本文件直接运行
--   3) 没有 mysql 客户端时，可用任意支持 JDBC 的方式执行
--
-- 【注意】脚本含 DROP TABLE IF EXISTS sys_user，重复执行会清空已注册的船员数据。
--        只想补建库表、不想动数据时，请把第 3 段的 DROP / CREATE 跳过。
--
-- 【接口映射】
--   POST /api/user/register  注册        -> INSERT sys_user
--   POST /api/user/login     登录        -> SELECT by username / email
--   POST /api/user/reset     重置密钥    -> UPDATE password（代号 + 邮箱双重验证）
--   GET  /api/user/profile   查询档案    -> SELECT by username（需 X-Token）
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
