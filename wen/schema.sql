-- 注册功能：建库 + 建表（MySQL 8）
CREATE DATABASE IF NOT EXISTS fanren_login
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE fanren_login;

CREATE TABLE IF NOT EXISTS t_user (
  id          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  username    VARCHAR(50)  NOT NULL                COMMENT '用户名/账号',
  password    VARCHAR(100) NOT NULL                COMMENT '密码(BCrypt加密)',
  nickname    VARCHAR(50)  DEFAULT NULL            COMMENT '昵称',
  email       VARCHAR(100) DEFAULT NULL            COMMENT '邮箱',
  phone       VARCHAR(20)  DEFAULT NULL            COMMENT '手机号',
  avatar      VARCHAR(255) DEFAULT NULL            COMMENT '头像地址',
  status      TINYINT      NOT NULL DEFAULT 1      COMMENT '状态：1-正常 0-禁用',
  create_time DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (id),
  UNIQUE KEY uk_username (username),
  KEY idx_email (email),
  KEY idx_phone (phone)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = '用户表';
