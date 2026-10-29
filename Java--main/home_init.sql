-- ============================================================
-- 首页数据初始化脚本（正本）
-- 表：home_route（航线）、home_wanted（悬赏令）
-- 特性：可重复执行 —— CREATE TABLE IF NOT EXISTS + INSERT IGNORE，
--       重跑不会清空已有数据（对比 luffy_register.sql 含 DROP TABLE 勿混用）
-- 执行：mysql -uroot -p123456 --default-character-set=utf8mb4 < home_init.sql
-- ============================================================

USE springboottest;

-- ---------------- 航线表 ----------------
CREATE TABLE IF NOT EXISTS home_route (
    id           BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    icon         VARCHAR(16)  NOT NULL DEFAULT '🗺️'      COMMENT '卡片图标(emoji)',
    name         VARCHAR(64)  NOT NULL                   COMMENT '航线名称',
    region       VARCHAR(64)  NOT NULL DEFAULT ''        COMMENT '所属海域/地区',
    danger_level INT          NOT NULL DEFAULT 3         COMMENT '危险等级 1-5',
    description  VARCHAR(255) NOT NULL DEFAULT ''        COMMENT '航线简介',
    sort_no      INT          NOT NULL DEFAULT 100       COMMENT '展示排序，越小越靠前',
    PRIMARY KEY (id),
    UNIQUE KEY uk_route_name (name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '航线图鉴';

-- ---------------- 悬赏令表 ----------------
CREATE TABLE IF NOT EXISTS home_wanted (
    id       BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键',
    icon     VARCHAR(16) NOT NULL DEFAULT '🏴‍☠️'     COMMENT '卡片图标(emoji)',
    name     VARCHAR(64) NOT NULL                COMMENT '海贼名',
    epithet  VARCHAR(64) NOT NULL DEFAULT ''     COMMENT '称号',
    crew     VARCHAR(64) NOT NULL DEFAULT ''     COMMENT '所属海贼团',
    bounty   BIGINT      NOT NULL DEFAULT 0      COMMENT '悬赏金额（贝利）',
    PRIMARY KEY (id),
    UNIQUE KEY uk_wanted_name (name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '悬赏令';

-- ---------------- 航线种子数据 ----------------
INSERT IGNORE INTO home_route (icon, name, region, danger_level, description, sort_no) VALUES
('🌊', '东海启程线', '东海',   1, '风平浪静的新手海域，从这里出发扬帆起航。',                 1),
('🏝️', '伟大航路前半', '伟大航路', 3, '双子岬入港，磁力指针指向七条航线之一的起点。',           2),
('🏜️', '阿拉巴斯坦线', '伟大航路', 4, '黄沙漫天的王国，反派势力克洛克达尔盘踞之地。',           3),
('⚙️', '水之都环岛线', '伟大航路', 3, '水上都市与船匠之乡，海列车在波涛间穿行。',               4),
('👹', '和之国航线', '新世界',   5, '闭关锁国的武士之国，四皇凯多的领地，最凶险的一段航程。', 5),
('❄️', '磁鼓王国线', '伟大航路', 2, '常年飘雪的冬岛，樱花与庸医的传说之地。',                 6);

-- ---------------- 悬赏令种子数据 ----------------
INSERT IGNORE INTO home_wanted (icon, name, epithet, crew, bounty) VALUES
('🎩', '蒙奇·D·路飞',   '草帽小子',   '草帽一伙',   3000000000),
('🗡️', '罗罗诺亚·索隆', '海贼猎人',   '草帽一伙',   1111000000),
('🍊', '娜美',         '小贼猫',     '草帽一伙',   366000000),
('🎯', '乌索普',       'GOD',        '草帽一伙',   500000000),
('🚬', '文斯莫克·山治', '黑脚',       '草帽一伙',   1032000000),
('🦌', '托尼托尼·乔巴', '爱之勇者',   '草帽一伙',   1000),
('📚', '妮可·罗宾',     '恶魔之子',   '草帽一伙',   930000000),
('🔧', '弗兰奇',       '铁人',       '草帽一伙',   394000000),
('🎻', '布鲁克',       '灵魂之王',   '草帽一伙',   383000000),
('☁️', '唐吉诃德·多弗朗明戈', '天夜叉', '唐吉诃德家族', 340000000);
