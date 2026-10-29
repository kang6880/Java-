/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306_1
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : springboottest

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 29/10/2026 15:14:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin_user
-- ----------------------------
DROP TABLE IF EXISTS `admin_user`;
CREATE TABLE `admin_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员账号',
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'BCrypt 密文',
  `real_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '姓名/备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_admin_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '后台管理员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user
-- ----------------------------
INSERT INTO `admin_user` VALUES (1, 'admin', '$2b$10$tXW/3vZEJer/uGUFKFG7tOuJ6TzlvDRXfS2eD.3YA3XZAegoOqU5K', '伟大航道·总站长', '2026-10-29 14:50:18');

-- ----------------------------
-- Table structure for home_crew
-- ----------------------------
DROP TABLE IF EXISTS `home_crew`;
CREATE TABLE `home_crew`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '⚓' COMMENT '图标',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名',
  `alias` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '外号/称号',
  `position` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '船上职位/身份',
  `affiliation` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '所属势力',
  `origin` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '出身地',
  `devil_fruit` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '恶魔果实',
  `bounty` bigint NOT NULL DEFAULT 0 COMMENT '悬赏金（贝利）',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '人物简介',
  `sort_no` int NOT NULL DEFAULT 100 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_crew_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '船员名册' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_crew
-- ----------------------------
INSERT INTO `home_crew` VALUES (1, '🎩', '蒙奇·D·路飞', '草帽小子', '船长', '草帽一伙', '东海·风车村', '橡胶果实（人人果实·幻兽种·尼卡）', 3000000000, '立志成为海贼王的少年，吃下橡胶果实后身体能自由伸缩，把红发香克斯托付的草帽当作珍宝，最珍视的是伙伴与肉。', 1);
INSERT INTO `home_crew` VALUES (2, '🗡️', '罗罗诺亚·索隆', '海贼猎人', '剑士', '草帽一伙', '东海·霜月村', '无', 1111000000, '三刀流剑士，为完成与古伊娜的约定，誓要成为世界第一大剑豪。', 2);
INSERT INTO `home_crew` VALUES (3, '🍊', '娜美', '小贼猫', '航海士', '草帽一伙', '东海·可可亚西村', '无', 366000000, '天才航海士，能凭皮肤感知气流，梦想画出全世界的航海图。', 3);
INSERT INTO `home_crew` VALUES (4, '🎯', '乌索普', 'GOD', '狙击手', '草帽一伙', '东海·西罗布村', '无', 500000000, '弹弓与谎言的达人，胆小却总在关键时刻挺身而出，是勇敢的海上战士。', 4);
INSERT INTO `home_crew` VALUES (5, '🚬', '文斯莫克·山治', '黑脚', '厨师', '草帽一伙', '北海·杰尔马王国', '无', 1032000000, '只用手足战斗的厨子，为寻找传说之海「ALL BLUE」而踏上旅程，见女士必献殷勤。', 5);
INSERT INTO `home_crew` VALUES (6, '🦌', '托尼托尼·乔巴', '爱之勇者', '船医', '草帽一伙', '伟大航路·磁鼓王国', '人人果实', 1000, '吃了人人果实的驯鹿医生，被悬赏仅 1000 贝利，因为海军以为它只是宠物。', 6);
INSERT INTO `home_crew` VALUES (7, '📚', '妮可·罗宾', '恶魔之子', '考古学家', '草帽一伙', '西海·奥哈拉', '花花果实', 930000000, '奥哈拉唯一的幸存者，能读懂历史本文，追寻被抹去的空白一百年。', 7);
INSERT INTO `home_crew` VALUES (8, '🔧', '弗兰奇', '铁人', '船匠', '草帽一伙', '南海（出生）', '无（改造人）', 394000000, '改造人船匠，亲手造出桑尼号，口头禅是「SUPER」。', 8);
INSERT INTO `home_crew` VALUES (9, '🎻', '布鲁克', '灵魂之王', '音乐家', '草帽一伙', '西海', '黄泉果实', 383000000, '曾为伦巴海贼团团长，因黄泉果实只剩骨架，与鲸鱼拉布有着跨越五十年的约定。', 9);
INSERT INTO `home_crew` VALUES (10, '👊', '甚平', '海侠', '舵手', '草帽一伙', '伟大航路·鱼人岛', '无', 1100000000, '鱼人族战士，曾为王下七武海，为鱼人与人类的和解奔走一生。', 10);
INSERT INTO `home_crew` VALUES (11, '🔴', '香克斯', '红发', '船长', '红发海贼团', '西海', '无', 4048900000, '把草帽托付给路飞的男人，曾为罗杰海贼团见习生，顶上战争中以一己之力终止大战。', 11);
INSERT INTO `home_crew` VALUES (12, '🏔️', '爱德华·纽盖特', '白胡子', '船长', '白胡子海贼团', '伟大航路·斯芬克斯', '震震果实', 5046000000, '世界最强男人，把船员都称作「儿子」，为救艾斯发动顶上战争并战死沙场。', 12);
INSERT INTO `home_crew` VALUES (13, '🌑', '马歇尔·D·蒂奇', '黑胡子', '船长', '黑胡子海贼团', '伟大航路·暗暗岛', '暗暗果实＋震震果实', 3996000000, '潜伏白胡子海贼团数十年，为夺取暗暗果实杀害萨奇，是唯一拥有双果实的人。', 13);
INSERT INTO `home_crew` VALUES (14, '🐉', '凯多', '百兽', '总督', '百兽海贼团', '新世界·和之国', '鱼鱼果实·幻兽种·青龙', 4611100000, '最强生物，单挑不死的怪物，企图发动世界最大战争。', 14);
INSERT INTO `home_crew` VALUES (15, '🎂', '夏洛特·玲玲', 'BIG MOM', '船长', 'BIG MOM 海贼团', '新世界·万国', '魂魂果实', 4388000000, '为吃点心可以毁掉整个国家，用灵魂果实制造了霍米兹军团。', 15);
INSERT INTO `home_crew` VALUES (16, '♥️', '特拉法尔加·罗', '死亡外科医生', '船长', '心脏海贼团', '北海·弗雷凡斯', '手术果实', 3000000000, '曾为多弗朗明戈部下，与路飞结盟推翻四皇，持有不老手术的秘术。', 16);
INSERT INTO `home_crew` VALUES (17, '🧲', '尤斯塔斯·基德', '船长', '船长', '基德海贼团', '南海', '磁磁果实', 3000000000, '磁磁果实能力者，与路飞、罗同为「最恶世代」超新星，性格暴烈。', 17);
INSERT INTO `home_crew` VALUES (18, '🌋', '萨卡斯基', '赤犬', '海军元帅', '海军本部', '北海', '岩浆果实', 0, '绝对正义的执行者，顶上战争中重创白胡子并追杀路飞与艾斯。', 18);
INSERT INTO `home_crew` VALUES (19, '🧊', '库赞', '青雉', '原海军大将', '海军（已退役）', '南海', '冰冻果实', 0, '慵懒的正义，与赤犬决战后离开海军，后加入黑胡子海贼团。', 19);
INSERT INTO `home_crew` VALUES (20, '🟡', '波鲁萨利诺', '黄猿', '海军大将', '海军本部', '北海', '闪光果实', 0, '模棱两可的正义，说话慢条斯理却战力惊人。', 20);
INSERT INTO `home_crew` VALUES (21, '👊', '蒙奇·D·卡普', '铁拳', '海军中将', '海军本部', '东海·风车村', '无', 0, '路飞的祖父，曾数次将罗杰逼入绝境，被称为「海军英雄」。', 21);
INSERT INTO `home_crew` VALUES (22, '🦸', '克比', '英雄', '海军少将（SWORD）', '海军本部', '东海', '无', 0, '曾在亚尔丽塔手下打杂的少年，立志成为海军大将。', 22);
INSERT INTO `home_crew` VALUES (23, '🚭', '斯摩格', '白猎人', '海军中将', '海军本部', '伟大航路·罗格镇', '烟雾果实', 0, '执着追捕路飞的海军，烟烟果实能力者。', 23);
INSERT INTO `home_crew` VALUES (24, '👁️', '乔拉可尔·米霍克', '鹰眼', '王下七武海', '无', '伟大航路·克拉伊咖那岛', '无', 3590000000, '世界第一大剑豪，黑刀「夜」，也是索隆的剑术老师。', 24);

-- ----------------------------
-- Table structure for home_route
-- ----------------------------
DROP TABLE IF EXISTS `home_route`;
CREATE TABLE `home_route`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '?️' COMMENT '卡片图标(emoji)',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '航线名称',
  `region` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '所属海域/地区',
  `danger_level` int NOT NULL DEFAULT 3 COMMENT '危险等级 1-5',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '航线简介',
  `sort_no` int NOT NULL DEFAULT 100 COMMENT '展示排序，越小越靠前',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_route_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '航线图鉴' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_route
-- ----------------------------
INSERT INTO `home_route` VALUES (1, '🌊', '东海启程线', '东海', 1, '风平浪静的新手海域，从这里出发扬帆起航。', 1);
INSERT INTO `home_route` VALUES (2, '🏝️', '伟大航路前半', '伟大航路', 3, '双子岬入港，磁力指针指向七条航线之一的起点。', 2);
INSERT INTO `home_route` VALUES (3, '🏜️', '阿拉巴斯坦线', '伟大航路', 4, '黄沙漫天的王国，反派势力克洛克达尔盘踞之地。', 3);
INSERT INTO `home_route` VALUES (4, '⚙️', '水之都环岛线', '伟大航路', 3, '水上都市与船匠之乡，海列车在波涛间穿行。', 4);
INSERT INTO `home_route` VALUES (5, '👹', '和之国航线', '新世界', 5, '闭关锁国的武士之国，四皇凯多的领地，最凶险的一段航程。', 5);
INSERT INTO `home_route` VALUES (6, '❄️', '磁鼓王国线', '伟大航路', 2, '常年飘雪的冬岛，樱花与庸医的传说之地。', 6);
INSERT INTO `home_route` VALUES (7, '⛅', '空岛航线', '伟大航路', 4, '乘上升海流直冲一万米高空，云海之上是神之国香狄亚。', 5);
INSERT INTO `home_route` VALUES (8, '🐟', '鱼人岛航线', '新世界', 4, '红土大陆之下的海底乐园，通往新世界的必经门户。', 7);
INSERT INTO `home_route` VALUES (9, '🎭', '德雷斯罗萨线', '新世界', 5, '热情洋溢的舞蹈之国，地下却藏着玩具奴隶与鸟笼的阴谋。', 8);
INSERT INTO `home_route` VALUES (10, '🐘', '佐乌岛线', '新世界', 4, '巨象背上的毛皮族之国，光月家族与历史本文在此相会。', 9);
INSERT INTO `home_route` VALUES (11, '🍰', '蛋糕岛航线', '新世界', 5, 'BIG MOM 万国的甜点城堡，用点心堆砌的致命陷阱。', 10);
INSERT INTO `home_route` VALUES (12, '🤖', '蛋头岛航线', '新世界', 5, '贝加庞克的未来岛，机器巨鲨与炽天使守卫着世界政府的秘密。', 11);
INSERT INTO `home_route` VALUES (13, '🏁', '拉夫坦路', '伟大航路终点', 5, '传说中伟大航路的尽头，只有海贼王罗杰抵达过的最终之岛。', 12);

-- ----------------------------
-- Table structure for home_shop
-- ----------------------------
DROP TABLE IF EXISTS `home_shop`;
CREATE TABLE `home_shop`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '?' COMMENT '图标',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '店铺/摊位名',
  `category` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '类别：武器/餐饮/杂货/造船/玩具…',
  `location` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '所在地',
  `item` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '招牌商品',
  `price` bigint NOT NULL DEFAULT 0 COMMENT '招牌商品价格（贝利）',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '店铺简介',
  `sort_no` int NOT NULL DEFAULT 100 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_shop_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '杂货小镇' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_shop
-- ----------------------------
INSERT INTO `home_shop` VALUES (1, '🍺', '风车村老伯酒馆', '餐饮', '东海·风车村', '海贼麦酒', 800, '村口的老酒馆，路飞常在这里听甚平与艾斯的故事，也在这里认识了大伙。', 1);
INSERT INTO `home_shop` VALUES (2, '🗡️', '罗格镇刀剑铺', '武器', '东海·罗格镇', '名刀「雪走」', 1000000, '罗格镇是海贼王罗杰的处刑地，也是索隆在此获得名刀的地方。', 2);
INSERT INTO `home_shop` VALUES (3, '🧵', '谢尔兹镇杂货铺', '杂货', '东海·谢尔兹镇', '手织草绳', 500, '小镇的杂货摊，草帽与绳索的来源地，老板娘总是絮叨个不停。', 3);
INSERT INTO `home_shop` VALUES (4, '⚓', '卡雷拉公司本社', '造船', '伟大航路·水之都', '定制帆船', 300000000, '世界第一造船公司，桑尼号由这里的船匠们倾力打造。', 4);
INSERT INTO `home_shop` VALUES (5, '🍬', '香波地杂货街', '杂货', '伟大航路·香波地群岛', '泡泡工艺饰品', 20000, '泡泡文化盛行的小商品街，出岛前最后的补给站。', 5);
INSERT INTO `home_shop` VALUES (6, '🍵', '绿洲茶馆', '餐饮', '伟大航路·阿拉巴斯坦', '沙漠凉茶', 1200, '沙漠绿洲边的茶馆，旅行者在这里交换情报也交换水。', 6);
INSERT INTO `home_shop` VALUES (7, '☁️', '云上杂货铺', '杂货', '空岛·神之国', '云贝（贝）', 3000, '贩卖储存风与音的贝壳，是空岛居民生活的必需品。', 7);
INSERT INTO `home_shop` VALUES (8, '🍰', '甜点工坊', '餐饮', '鱼人岛', '珊瑚蛋糕', 5000, '鱼人岛的点心铺，连人鱼女王也会派人来买。', 8);
INSERT INTO `home_shop` VALUES (9, '🧸', '玩具之家', '玩具', '新世界·德雷斯罗萨', '机关人偶', 15000, '看似温馨的玩具店，其实藏着被变成玩具的人类秘密。', 9);
INSERT INTO `home_shop` VALUES (10, '🍜', '阎魔荞麦面摊', '餐饮', '新世界·和之国', '热腾腾荞麦面', 800, '花之都街边的面摊，一碗热汤面能温暖一整天的疲惫。', 10);
INSERT INTO `home_shop` VALUES (11, '🕯️', '古董道具铺', '古董', '魔幻三角地带', '布鲁克遗物唱片', 30000, '恐怖三桅帆船靠岸处的老铺子，据说夜间会有影子来买东西。', 11);
INSERT INTO `home_shop` VALUES (12, '🔮', '未来岛研究所商店', '杂货', '新世界·蛋头岛', '自制万能工具', 50000, '贝加庞克研究所的贩卖机，什么都卖，包括失败的发明。', 12);

-- ----------------------------
-- Table structure for home_story
-- ----------------------------
DROP TABLE IF EXISTS `home_story`;
CREATE TABLE `home_story`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '?' COMMENT '图标',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '篇章名',
  `sea` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '发生地/海域',
  `chapters` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '漫画章节区间',
  `episodes` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '动画集数区间',
  `main_roles` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '主要登场人物',
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '剧情概要',
  `sort_no` int NOT NULL DEFAULT 100 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_story_title`(`title` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '篇章故事' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_story
-- ----------------------------
INSERT INTO `home_story` VALUES (1, '🌊', '东海篇', '东海', '漫画 1-61 话', '动画 1-45 集', '路飞、索隆、娜美、乌索普、山治', '橡胶少年路飞出海，接连打败亚尔丽塔与恶龙，先后收下剑士、航海士、狙击手与厨师，草帽一伙雏形初成。', 1);
INSERT INTO `home_story` VALUES (2, '🏜️', '阿拉巴斯坦篇', '伟大航路', '漫画 155-217 话', '动画 92-130 集', '路飞、薇薇、克洛克达尔', '为帮助公主薇薇，草帽一伙潜入沙漠王国，揭穿王下七武海克洛克达尔的叛乱阴谋，路飞以橡胶果实之力击碎砂之国阴谋。', 2);
INSERT INTO `home_story` VALUES (3, '⛅', '空岛篇', '伟大航路·加雅岛', '漫画 237-302 话', '动画 144-193 集', '路飞、艾尼路、山迪亚战士', '乘上升海流抵达一万米高空，卷入神之国四百年战争，路飞以橡胶之身击败雷神艾尼路，敲响黄金钟。', 3);
INSERT INTO `home_story` VALUES (4, '⚖️', '司法岛篇', '伟大航路·水之都', '漫画 375-430 话', '动画 263-312 集', '路飞、罗宾、弗兰奇、CP9', '为夺回妮可·罗宾，草帽一伙闯入世界政府司法岛，向世界政府宣战并烧毁旗帜，桑尼号由此诞生。', 4);
INSERT INTO `home_story` VALUES (5, '💀', '恐怖三桅帆船篇', '魔幻三角地带', '漫画 442-489 话', '动画 337-381 集', '路飞、布鲁克、月光·莫利亚', '影子被夺走的恐怖之岛，路飞击败七武海莫利亚，布鲁克加入草帽一伙，甚平与小丑巴基亦在此现身。', 5);
INSERT INTO `home_story` VALUES (6, '🔥', '顶上战争篇', '海军本部·马林梵多', '漫画 550-580 话', '动画 459-489 集', '白胡子、艾斯、赤犬、黑胡子', '为营救艾斯，白胡子海贼团与海军本部爆发史上最大战争，艾斯陨落，路飞失去兄长，时代开始剧烈崩塌。', 6);
INSERT INTO `home_story` VALUES (7, '🐟', '鱼人岛篇', '新世界·鱼人岛', '漫画 601-653 话', '动画 517-574 集', '路飞、甚平、白星、霍迪·琼斯', '穿越红土大陆抵达海底乐园，粉碎霍迪·琼斯的政变，揭开白星公主与诺亚方舟的古老誓约。', 7);
INSERT INTO `home_story` VALUES (8, '🎭', '德雷斯罗萨篇', '新世界·德雷斯罗萨', '漫画 700-801 话', '动画 629-746 集', '路飞、多弗朗明戈、罗、蕾贝卡', '路飞与罗的结盟之战，揭穿多弗朗明戈的黑暗交易，鸟笼笼罩全岛，最终以四档弹力终结其统治。', 8);
INSERT INTO `home_story` VALUES (9, '🐘', '佐乌篇', '新世界·佐乌', '漫画 802-822 话', '动画 751-779 集', '毛皮族、光月家族、锦卫门', '巨象背上的毛皮族之国，光月家臣在此重聚，众人得知路标历史本文与和之国的秘密。', 9);
INSERT INTO `home_story` VALUES (10, '🍰', '蛋糕岛篇', '新世界·万国', '漫画 823-902 话', '动画 783-877 集', '山治、路飞、BIG MOM、卡塔库栗', '为带回山治，草帽一伙闯入 BIG MOM 的茶会，在镜世界展开激战，山治以最温柔的踢技战胜最强将星。', 10);
INSERT INTO `home_story` VALUES (11, '👹', '和之国篇', '新世界·和之国', '漫画 909-1057 话', '动画 890-1085 集', '路飞、凯多、光月日和、大和', '讨伐百兽凯多的鬼岛大战，路飞觉醒尼卡形态，二十年的锁国终被打破，和之国迎来黎明。', 11);
INSERT INTO `home_story` VALUES (12, '🤖', '蛋头岛篇', '新世界·蛋头岛', '漫画 1060 话起', '动画 1086 集起', '路飞、贝加庞克、乔伊波伊、五老星', '未来岛上遇见天才科学家贝加庞克，炽天使与机器巨鲨登场，世界政府最高战力五老星亲临，空白的一百年真相揭开。', 12);

-- ----------------------------
-- Table structure for home_wanted
-- ----------------------------
DROP TABLE IF EXISTS `home_wanted`;
CREATE TABLE `home_wanted`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '?‍☠️' COMMENT '卡片图标(emoji)',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '海贼名',
  `epithet` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '称号',
  `crew` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '所属海贼团',
  `bounty` bigint NOT NULL DEFAULT 0 COMMENT '悬赏金额（贝利）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_wanted_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 211 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '悬赏令' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_wanted
-- ----------------------------
INSERT INTO `home_wanted` VALUES (1, '🎩', '蒙奇·D·路飞', '草帽小子', '草帽一伙', 3000000000);
INSERT INTO `home_wanted` VALUES (2, '🗡️', '罗罗诺亚·索隆', '海贼猎人', '草帽一伙', 1111000000);
INSERT INTO `home_wanted` VALUES (3, '🍊', '娜美', '小贼猫', '草帽一伙', 366000000);
INSERT INTO `home_wanted` VALUES (4, '🎯', '乌索普', 'GOD', '草帽一伙', 500000000);
INSERT INTO `home_wanted` VALUES (5, '🚬', '文斯莫克·山治', '黑脚', '草帽一伙', 1032000000);
INSERT INTO `home_wanted` VALUES (6, '🦌', '托尼托尼·乔巴', '爱之勇者', '草帽一伙', 1000);
INSERT INTO `home_wanted` VALUES (7, '📚', '妮可·罗宾', '恶魔之子', '草帽一伙', 930000000);
INSERT INTO `home_wanted` VALUES (8, '🔧', '弗兰奇', '铁人', '草帽一伙', 394000000);
INSERT INTO `home_wanted` VALUES (9, '🎻', '布鲁克', '灵魂之王', '草帽一伙', 383000000);
INSERT INTO `home_wanted` VALUES (10, '☁️', '唐吉诃德·多弗朗明戈', '天夜叉', '唐吉诃德家族', 340000000);
INSERT INTO `home_wanted` VALUES (11, '👊', '甚平', '海侠', '草帽一伙', 1100000000);
INSERT INTO `home_wanted` VALUES (12, '🔴', '香克斯', '红发', '红发海贼团', 4048900000);
INSERT INTO `home_wanted` VALUES (13, '🏔️', '爱德华·纽盖特', '白胡子', '白胡子海贼团', 5046000000);
INSERT INTO `home_wanted` VALUES (14, '🌑', '马歇尔·D·蒂奇', '黑胡子', '黑胡子海贼团', 3996000000);
INSERT INTO `home_wanted` VALUES (15, '🐉', '凯多', '百兽', '百兽海贼团', 4611100000);
INSERT INTO `home_wanted` VALUES (16, '🎂', '夏洛特·玲玲', 'BIG MOM', 'BIG MOM 海贼团', 4388000000);
INSERT INTO `home_wanted` VALUES (17, '♥️', '特拉法尔加·罗', '死亡外科医生', '心脏海贼团', 3000000000);
INSERT INTO `home_wanted` VALUES (18, '🧲', '尤斯塔斯·基德', '船长', '基德海贼团', 3000000000);
INSERT INTO `home_wanted` VALUES (19, '🐊', '克洛克达尔', '沙漠王', '巴洛克工作社', 81000000);
INSERT INTO `home_wanted` VALUES (20, '👁️', '乔拉可尔·米霍克', '鹰眼', '无（七武海）', 3590000000);
INSERT INTO `home_wanted` VALUES (21, '🤡', '巴基', '小丑', '巴基速递', 3189000000);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '航海士代号（登录账号，唯一）',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '贝利邮箱（唯一）',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '船舱密钥（BCrypt 加密后存储，不可逆）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登记时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_sys_user_username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `uk_sys_user_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '船员名册（注册用户表）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, '路飞', 'luffy@onepiece.com', '$2b$10$izOLX7eLglz39jM2R9IVPekziQOOddxJV47S08pHjRCbOIdbbZRvK', '2026-10-29 13:52:50');
INSERT INTO `sys_user` VALUES (2, '罗宾酱', '123456@qq.com', '$2a$10$lJc943ntWjkfa1fYaVea3.0AjSwJZSpQ8xIJmXBa1f5PD5.seYusC', '2026-10-29 14:08:25');

SET FOREIGN_KEY_CHECKS = 1;
