/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : springboottest

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 02/11/2026 09:59:46
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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '后台管理员' ROW_FORMAT = DYNAMIC;

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
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '动漫形象图URL',
  `bounty` bigint NOT NULL DEFAULT 0 COMMENT '悬赏金（贝利）',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '人物简介',
  `deeds` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '主要事迹',
  `sort_no` int NOT NULL DEFAULT 100 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_crew_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '船员名册' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of home_crew
-- ----------------------------
INSERT INTO `home_crew` VALUES (1, '🎩', '蒙奇·D·路飞', '草帽小子', '船长', '草帽一伙', '东海·风车村', '橡胶果实（人人果实·幻兽种·尼卡）', '', 3000000000, '草帽海贼团船长，梦想成为海贼王。出生于东海风车村，自幼吃下橡胶果实（实为动物系·人人果实·幻兽种·尼卡形态），被红发香克斯寄托草帽。他单纯、热血、重情义，坚信伙伴高于一切，是能把所有人心凝聚起来的\"天生的领袖\"。在司法岛当众烧毁世界政府旗帜、在顶上战争为救艾斯孤身闯海军本部、在和之国觉醒尼卡形态以太阳神姿态击败凯多，一步步从东海小海贼成长为被称作\"第五位海上皇帝\"的男人。', '击败东海恶徒、阿拉巴斯坦打飞克洛克达尔、司法岛救回罗宾、顶上战争失去哥哥艾斯后两年修行，觉醒尼卡形态一拳击落四皇凯多，被世人称为「第五皇」，朝着海贼王梦想全速前进。', 1);
INSERT INTO `home_crew` VALUES (2, '🗡️', '罗罗诺亚·索隆', '海贼猎人', '剑士', '草帽一伙', '东海·霜月村', '无', '', 1111000000, '草帽一伙剑士，梦想成为世界第一大剑豪。出生于东海霜月村，幼年挚友古伊娜意外离世后立下誓言，练成三刀流。他冷静坚毅、意志如铁，是路飞第一个伙伴，也是草帽团的战斗核心。在恐怖三桅帆船篇为保护伙伴承受路飞全部的伤痛，在司法岛、德雷斯罗萨、和之国屡次以惊人剑术击溃强敌，最终目标是超越\"鹰眼\"米霍克。', '立下「绝不再败」誓言，司法岛以「三千大千世界」苦战，和之国获得阎魔并砍伤四皇凯多，以成为世界第一大剑豪为目标一路变强。', 2);
INSERT INTO `home_crew` VALUES (3, '🍊', '娜美', '小贼猫', '航海士', '草帽一伙', '东海·可可亚西村', '无', '', 366000000, '草帽一伙航海士，梦想画出全世界的海图。出生于东海可可亚西村，幼年被鱼人阿龙胁迫，被迫绘制海图，后被路飞拯救。她精明、爱财、强悍，是掌控整艘船航行的大脑，擅长气象学，能感知天候变化。在和之国大战中使出雷云宙斯与天候术，实力早已今非昔比。', '从阿龙海贼团手中拯救可可亚西村，绘制世界海图的梦想从未改变，草帽团的航海士兼财务总管，一次次在风浪中指引航线。', 3);
INSERT INTO `home_crew` VALUES (4, '🎯', '乌索普', 'GOD', '狙击手', '草帽一伙', '东海·西罗布村', '无', '', 500000000, '草帽一伙狙击手，自称\"海上勇士\"。出生于东海西罗布村，父亲是红发海贼团的耶稣布。他胆小却勇敢，在最关键的时刻从不退缩，名言是\"狙击手，就是要在别人看不见的地方保护伙伴\"。在德雷斯罗萨以超远距离狙杀砂糖、成为解放玩具士兵的关键，被称作\"GOD乌索普\"。', '从爱说谎的胆小鬼成长为「大神乌索普」，德雷斯罗萨以见闻色霸气封神「GOD」，始终践行「勇敢的海上战士」的誓言。', 4);
INSERT INTO `home_crew` VALUES (5, '🚬', '文斯莫克·山治', '黑脚', '厨师', '草帽一伙', '北海·杰尔马王国', '无', '', 1032000000, '草帽一伙厨师，梦想找到传说之海\"ALL BLUE\"。出生于北海杰尔马王国的文斯莫克家族，自幼被家族虐待，后逃出师从红脚哲普。他尊重食物与女性，绝不浪费粮食，是船上无与伦比的厨师兼战斗员。在蛋糕岛篇与家族和解、在鬼岛大战中以\"魔神风脚\"击碎百兽凯多麾下强敌，黑脚山治的名号响彻新世界。', '坚守骑士道与厨师之魂，蛋糕岛篇为伙伴与家族两难抉择，觉醒杰尔马血统因子，梦想找到传说中的 All Blue。', 5);
INSERT INTO `home_crew` VALUES (6, '🦌', '托尼托尼·乔巴', '爱之勇者', '船医', '草帽一伙', '伟大航路·磁鼓王国', '人人果实', '', 1000, '草帽一伙船医，一只吃下人人果实的驯鹿。出生于伟大航路磁鼓王国，被养父希鲁鲁克医生救下，继承了\"万能药\"的信念。他天真善良、医术高超，能变身多种形态，梦想成为能治愈一切疾病的医生。虽然悬赏金只有1000贝利，却是草帽团不可或缺的伙伴与团宠。', '人人果实能力者，磁鼓岛为救希鲁鲁克医娘传承医术，是草帽团最可爱的船医，梦想成为能治愈一切疾病的万能药。', 6);
INSERT INTO `home_crew` VALUES (7, '📚', '妮可·罗宾', '恶魔之子', '考古学家', '草帽一伙', '西海·奥哈拉', '花花果实', '', 930000000, '草帽一伙考古学家，梦想解读历史正文、寻找空白的一百年真相。出生于西海奥哈拉，8岁时奥哈拉被屠魔令毁灭，成为\"恶魔之子\"被世界政府通缉。她冷静聪慧、腹黑幽默，吃下花花果实，可在任意地方长出身体部位。在司法岛那句\"说我想活下去\"震撼人心，最终成为能读懂历史正文的关键人物。', '奥哈拉唯一幸存者，能解读历史正文的考古学家，司法岛被路飞喊出「说你想活下去」后真心融入草帽团，探寻空白一百年的真相。', 7);
INSERT INTO `home_crew` VALUES (8, '🔧', '弗兰奇', '铁人', '船匠', '草帽一伙', '南海（出生）', '无（改造人）', '', 394000000, '草帽一伙船匠，梦想让\"桑尼号\"环绕世界一周。出生于南海，被海贼父母遗弃，师从鱼人汤姆，继承其造船技艺。他是改造人，身体藏有可乐驱动的武器系统，性格奔放热情，动手能力极强。在鬼岛大战中击碎杰尔马科技战舰，是草帽团最可靠的机械战力。', '天才船匠，用可乐驱动身体，为草帽团打造了桑尼号，和之国驾驶弗兰奇将军大放异彩，梦想乘着自己的船航行到世界尽头。', 8);
INSERT INTO `home_crew` VALUES (9, '🎻', '布鲁克', '灵魂之王', '音乐家', '草帽一伙', '西海', '黄泉果实', '', 383000000, '草帽一伙音乐家，一个活了90多年的骷髅。出生于西海，吃下黄泉果实，死后灵魂回到骷髅复活。他乐观幽默、绅士礼貌，梦想是与拉布重逢。作为音乐家能演奏小提琴、能御剑，还能以灵魂能力攻击敌人，是草帽团里最年长也最快乐的一员。', '黄泉果实能力者，五十年前与鲸鱼拉布的约定贯穿一生，一曲《宾克斯的美酒》连接两代人的思念，是草帽团的音乐家。', 9);
INSERT INTO `home_crew` VALUES (10, '👊', '甚平', '海侠', '舵手', '草帽一伙', '伟大航路·鱼人岛', '无', '', 1100000000, '草帽一伙舵手，原王下七武海、太阳海贼团舵手。出生于鱼人岛，是鲸鲨鱼人，侠肝义胆、稳重可靠，被称为\"海侠\"。他坚守鱼人的尊严与对艾斯的兄弟情，在鬼岛大战中以\"鱼人空手道\"击退凯多，正式加入草帽一伙，成为船上的舵手与定海神针。', '前七武海「海侠」，推进城与顶上战争多次救路飞于危难，鱼人岛篇正式加入草帽团，梦想人类与鱼人族和平共处。', 10);
INSERT INTO `home_crew` VALUES (11, '🔴', '香克斯', '红发', '船长', '红发海贼团', '西海', '无', '', 4048900000, '红发海贼团船长，四皇之一。出生于西海，曾是海贼王罗杰船上见习船员，后自立门户。他是路飞成为海贼的引路人，将草帽托付给路飞并约定在顶点重逢。他实力深不可测，霸气无人能敌，能用\"面子\"震慑海军与四皇，是当前大海上最神秘的强者之一。', '四皇「红发」，把草帽与梦想托付给路飞的引路人，顶上战争一出现便终结了战斗，是海贼世界举足轻重的传奇海贼。', 11);
INSERT INTO `home_crew` VALUES (12, '🏔️', '爱德华·纽盖特', '白胡子', '船长', '白胡子海贼团', '伟大航路·斯芬克斯', '震震果实', '', 5046000000, '白胡子海贼团船长，被称为\"世界最强的男人\"。出生于伟大航路斯芬克斯，吃下震震果实，能引发海啸与地震。他将所有船员视为儿子，一生只求一个家。顶上战争中为救艾斯孤身战海军本部，身中267处刀伤、152发子弹仍屹立不倒，最终以\"我是旧时代的残党\"悲壮谢幕。', '四皇「白胡子」，震震果实威震世界，顶上战争为救艾斯战死，临终喊出「ONE PIECE 是真实存在的」，再次引爆大海贼时代。', 12);
INSERT INTO `home_crew` VALUES (13, '🌑', '马歇尔·D·蒂奇', '黑胡子', '船长', '黑胡子海贼团', '伟大航路·暗暗岛', '暗暗果实＋震震果实', '', 3996000000, '黑胡子海贼团提督，四皇之一，史上唯一拥有两颗恶魔果实的人（暗暗果实+震震果实）。出生于伟大航路，隐忍二十年等待时机，野心勃勃、不择手段。他杀害了第四队队长萨奇夺取暗暗果实，抓住艾斯献给海军、引发顶上战争，最终夺取白胡子震震果实，一步步登上四皇宝座。', '四皇「黑胡子」，唯一同时拥有暗暗果实与震震果实的男人，野心勃勃、阴险狡诈，是路飞宿命中的最大对手之一。', 13);
INSERT INTO `home_crew` VALUES (14, '🐉', '凯多', '百兽', '总督', '百兽海贼团', '新世界·和之国', '鱼鱼果实·幻兽种·青龙', '', 4611100000, '百兽海贼团总督，四皇之一，被称为\"最强生物\"。出生于新世界和之国，吃下鱼鱼果实·幻兽种·青龙形态，能化为巨龙呼风唤雨。他崇尚\"战争才是世界的规则\"，企图建立全动物系军团发动世界战争。在和之国大战中被路飞以觉醒尼卡形态击落，其海贼团随之瓦解。', '四皇「百兽」，鱼鱼果实·青龙形态，和之国被路飞的尼卡形态一拳击落，统治和之国多年的暴君就此落幕。', 14);
INSERT INTO `home_crew` VALUES (15, '🎂', '夏洛特·玲玲', 'BIG MOM', '船长', 'BIG MOM 海贼团', '新世界·万国', '魂魂果实', '', 4388000000, 'BIG MOM海贼团船长，四皇之一。出生于新世界万国，吃下魂魂果实，能操纵灵魂、赋予万物生命。她暴虐任性、贪食甜点，渴望建立所有种族和平共处的\"万国\"，但手段残忍。在与基德、罗的联手作战中被击败，退出了四皇之位。', '四皇「BIG MOM」，魂魂果实能力者，万国的统治者，蛋糕岛篇与草帽团激战，是令人生畏的女海贼皇帝。', 15);
INSERT INTO `home_crew` VALUES (16, '♥️', '特拉法尔加·罗', '死亡外科医生', '船长', '心脏海贼团', '北海·弗雷凡斯', '手术果实', '', 3000000000, '心脏海贼团船长，\"极恶世代\"十一超新星之一。出生于北海弗雷凡斯，幼年家乡因铂铅病被毁灭，怀抱着对多弗朗明哥的仇恨。吃下手术果实，能创造\"ROOM\"空间进行任意切割与交换，是价值50亿贝利的\"究极恶魔果实\"。在与凯多之战中与基德联手击落BIG MOM，是新时代的代表之一。', '心脏海贼团船长，手术果实能力者，与路飞结盟对抗四皇，和之国联手击败大妈，是头脑与实力兼备的谋略家。', 16);
INSERT INTO `home_crew` VALUES (17, '🧲', '尤斯塔斯·基德', '船长', '船长', '基德海贼团', '南海', '磁磁果实', '', 3000000000, '基德海贼团船长，\"极恶世代\"十一超新星之一，与路飞、罗齐名。出生于南海，吃下磁磁果实，能操纵金属。他桀骜不驯、残暴好斗，却也重情义。在万国篇被凯多击败后越狱，与罗联手在和之国击落BIG MOM，成为推翻旧时代的重要战力。', '基德海贼团船长，磁磁果实能力者，和之国与路飞、罗联手击败双皇，脾气火爆但重情重义。', 17);
INSERT INTO `home_crew` VALUES (18, '🌋', '萨卡斯基', '赤犬', '海军元帅', '海军本部', '北海', '岩浆果实', '', 0, '海军本部元帅，代号\"赤犬\"。出生于北海，吃下岩浆果实，能化为岩浆攻击，破坏力堪称海军之最。他信奉\"绝对的正义\"，手段极端狠辣，顶上战争中亲手击杀艾斯、重创路飞。在与青雉的十天大战中获胜升任元帅，是路飞等人的宿敌。', '海军元帅「赤犬」，岩浆果实能力者，顶上战争击杀艾斯的元凶，坚持「绝对的正义」的强硬派代表。', 18);
INSERT INTO `home_crew` VALUES (19, '🧊', '库赞', '青雉', '原海军大将', '海军（已退役）', '南海', '冰冻果实', '', 0, '原海军大将，代号\"青雉\"。出生于南海，吃下冰冻果实，能冻结万物。他信奉\"懒散的正义\"，性格慵懒却洞察世事。在与赤犬争夺元帅之位的十天大战中败北，断腿后离开海军，成为自由人，暗中观察着世界的走向。', '原海军大将「青雉」，冰冻果实能力者，与赤犬争夺元帅失败后退役，坚持懒散的正义。', 19);
INSERT INTO `home_crew` VALUES (20, '🟡', '波鲁萨利诺', '黄猿', '海军大将', '海军本部', '北海', '闪光果实', '', 0, '海军本部大将，代号\"黄猿\"。出生于北海，吃下闪光果实，能以光速移动、发射激光。他总是一副漫不经心的懒散模样，实力却深不可测，信奉\"模糊的正义\"。作为海军最高战力之一，多次与海贼强者交锋，其真正立场始终成谜。', '海军大将「黄猿」，闪光果实能力者，实力深不可测，常常一副游刃有余的样子。', 20);
INSERT INTO `home_crew` VALUES (21, '👊', '蒙奇·D·卡普', '铁拳', '海军中将', '海军本部', '东海·风车村', '无', '', 0, '海军本部中将，被称为\"铁拳卡普\"，是路飞的爷爷、龙的父亲。他追击海贼王罗杰多年，曾多次将其逼入绝境，是海军中唯一能被称为\"英雄\"的人。他不使用恶魔果实，凭一双铁拳和霸王色霸气纵横大海，顶上战争时虽身居海军却放水救下路飞，是集正义与亲情于一身的老兵。', '海军英雄「铁拳」，路飞的爷爷，曾与罗杰多次交锋的传奇中将，实力不逊大将。', 21);
INSERT INTO `home_crew` VALUES (22, '🦸', '克比', '英雄', '海军少将（SWORD）', '海军本部', '东海', '无', '', 0, '海军本部少将，SWORD机密行动部队成员。出生于东海，是路飞、艾斯少年时代的伙伴，一路追随着路飞的脚步成长。他善良正直，从懦弱少年蜕变为独当一面的海军军官，梦想是成为海军大将。在蛋头岛篇加入SWORD，与路飞并肩作战对抗世界政府。', '从胆小少年成长为 SWORD 少将，路飞最早的伙伴之一，一路追寻梦想的海军新星。', 22);
INSERT INTO `home_crew` VALUES (23, '🚭', '斯摩格', '白猎人', '海军中将', '海军本部', '伟大航路·罗格镇', '烟雾果实', '', 0, '海军本部中将，代号\"白猎人\"。出生于伟大航路罗格镇，吃下烟雾果实，能化为烟雾战斗。他固执坚持自己的正义，在罗格镇曾差点抓住路飞，此后一路追击草帽团。他并非冷酷无情，对海贼也有自己的判断，是海军中难得的良知派。', '海军中将「白猎人」，烟雾果实能力者，从罗格镇起一路追捕路飞，坚守自己的正义。', 23);
INSERT INTO `home_crew` VALUES (24, '👁️', '乔拉可尔·米霍克', '鹰眼', '王下七武海', '无', '伟大航路·克拉伊咖那岛', '无', '', 3590000000, '王下七武海，被称为\"鹰眼\"，是世界第一大剑豪。出生于伟大航路克拉伊咖那岛，不使用恶魔果实，凭一把黑刀\"夜\"纵横大海，是索隆超越的目标。他孤高冷峻、深不可测，曾与红发香克斯多次交锋，是海上真正的剑术顶点。', '世界第一大剑豪「鹰眼」，索隆的目标与师父，原七武海，实力深不可测的孤高剑士。', 24);
INSERT INTO `home_crew` VALUES (25, '☠️', '哥尔·D·罗杰', '海贼王', '罗杰海贼团船长', '罗杰海贼团', '东海·罗格镇', '无', '', 5506480000, '史上第一位完成伟大航路、征服\"新世界\"的海贼王，被称为\"海贼王\"。他找到传说之岛拉夫坦路，洞悉了世界的真相，却身患绝症，主动向海军自首，在罗格镇被处刑前喊出\"去找吧！我把一切都放在那里了\"，开启了轰轰烈烈的大海贼时代。', '找到拉夫坦路、开创大海贼时代、临终遗言开启罗杰时代', 101);
INSERT INTO `home_crew` VALUES (26, '🔥', '波特卡斯·D·艾斯', '火拳', '白胡子海贼团二番队队长', '白胡子海贼团', '东海·哥亚王国', '烧烧果实', '', 550000000, '白胡子海贼团二番队队长，海贼王罗杰之子，路飞的义兄。吃下烧烧果实，能化为火焰，被称作\"火拳艾斯\"。他一生都在寻找自己存在的意义，最终为保护路飞挡下赤犬一击而牺牲，那句\"谢谢你们，如此爱着我\"让无数人落泪。', '顶上战争为救路飞牺牲、烧烧果实继承者萨博登场', 102);
INSERT INTO `home_crew` VALUES (27, '🧵', '多弗朗明哥', '天夜叉', '唐吉诃德海贼团船长', '唐吉诃德海贼团', '圣地·玛丽乔亚', '线线果实', '', 340000000, '原天龙人，唐吉诃德海贼团船长，也是德雷斯罗萨的国王。吃下线线果实，能操纵丝线操控他人。他狂妄残忍、把世界当作游戏，在德雷斯罗萨篇被路飞以四档\"大猿王枪\"击败，其罪恶的黑市帝国随之崩塌。', '操控德雷斯罗萨十年、被路飞四档击溃', 103);
INSERT INTO `home_crew` VALUES (28, '🐍', '波雅·汉库克', '海贼女帝', '九蛇海贼团船长', '九蛇海贼团', '亚马逊·百合', '甜甜果实', '', 1659000000, '女儿岛亚马逊·百合的皇帝，九蛇海贼团船长，被称为\"海贼女帝\"。吃下甜甜果实，凡是被她魅惑的人都将石化。她骄傲自恋，却对路飞一见钟情、死心塌地，是王下七武海中唯一的女性，也是路飞的坚定盟友。', '爱上路飞、为路飞对抗海军与天龙人', 104);
INSERT INTO `home_crew` VALUES (29, '🌊', '藤虎', '藤虎一笑', '海军本部大将', '海军本部', '无', '重力果实', '', 0, '海军本部大将，本名一笑，是个盲人剑客。吃下重力果实，能操纵重力引发陨石坠落。他信奉\"仁义的正义\"，在德雷斯罗萨篇当众下跪为海军的罪恶道歉，是海军中少有的敢于反抗世界政府的人。', '德雷斯罗萨当众下跪致歉、废除王下七武海制度', 105);
INSERT INTO `home_crew` VALUES (30, '🍀', '绿牛', '绿牛', '海军本部大将', '海军本部', '无', '森森果实', '', 0, '海军本部大将，本名荒卷，被称为\"绿牛\"。吃下森森果实，能操纵植物、化身为森林。他性格狂放不羁，对强者充满敬意，在蛋头岛篇登场，展现出与赤犬等人截然不同的海军大将风格。', '蛋头岛篇登场、展现森森果实威能', 106);
INSERT INTO `home_crew` VALUES (31, '💀', '凯多之子·大和', '鬼之女', '百兽海贼团', '百兽海贼团（叛逃）', '和之国', '犬犬果实·幻兽种·大口真神形态', '', 0, '凯多之女，崇拜光月御田，自称为\"御田\"。吃下大口真神果实，能化为白色巨狼、口吐寒冰。她在鬼岛大战中反抗父亲凯多，帮助路飞等人，战后留在和之国守护这个国家。', '反抗凯多、助路飞觉醒尼卡形态', 107);

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
) ENGINE = InnoDB AUTO_INCREMENT = 127 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '航线图鉴' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of home_route
-- ----------------------------
INSERT INTO `home_route` VALUES (1, '🌊', '东海启程线', '东海', 1, '路飞从风车村出海的第一段旅程，途径谢尔兹镇、橘子镇，击败斧手摩根、小丑巴基，收下索隆、娜美、乌索普、山治等最初的伙伴，是一切冒险的起点。', 1);
INSERT INTO `home_route` VALUES (2, '🏝️', '伟大航路前半', '伟大航路', 3, '进入伟大航路的入口，穿过双子岬、威士忌山峰，遇到鲸鱼拉布、与克比重逢，草帽团在这里正式踏上寻找海贼王之路，并立下各自的梦想誓言。', 2);
INSERT INTO `home_route` VALUES (3, '🏜️', '阿拉巴斯坦线', '伟大航路', 4, '草帽团登陆沙漠王国阿拉巴斯坦，与克洛克达尔的巴洛克工作社正面交锋，路飞首次击败王下七武海，拯救了薇薇公主与整个国家，也让草帽团声名大噪。', 3);
INSERT INTO `home_route` VALUES (4, '⚙️', '水之都环岛线', '伟大航路', 3, '环绕水之都的海上路线，草帽团在这里与CP9对决、失去梅利号，罗宾被抓走，路飞开发出二档、三档，是草帽团最惨痛也最成长的一段旅程。', 4);
INSERT INTO `home_route` VALUES (5, '👹', '和之国航线', '新世界', 5, '通往和之国的危险航线，沿途被凯多的百兽海贼团与和之国武士严密把守，是四皇凯多的地盘，也是路飞觉醒尼卡形态、击落凯多的决战之地。', 5);
INSERT INTO `home_route` VALUES (6, '❄️', '磁鼓王国线', '伟大航路', 2, '通往磁鼓王国的航线，草帽团在这里遇到船医乔巴，路飞背着重伤的娜美登上磁鼓山求医，乔巴加入，是草帽团收获\"万能药\"伙伴的地方。', 6);
INSERT INTO `home_route` VALUES (7, '⛅', '空岛航线', '伟大航路', 4, '通往空岛的天路航线，借助上升海流冲上万米高空，路飞在这里与神·艾尼路对决，为拉夫坦路的历史正文埋下伏笔，也是山治第一次展露厨艺之魂。', 5);
INSERT INTO `home_route` VALUES (8, '🐟', '鱼人岛航线', '新世界', 4, '深入海底一万米的鱼人岛航线，草帽团在这里与霍迪·琼斯对决，路飞展现霸王色霸气，甚平正式与草帽团结缘，也为鱼人与人类的和平埋下希望。', 7);
INSERT INTO `home_route` VALUES (9, '🎭', '德雷斯罗萨线', '新世界', 5, '通往德雷斯罗萨的航线，路飞在这里与多弗朗明哥决战，开启四档\"弹力人\"，乌索普觉醒见闻色霸气成为\"GOD\"，拯救了整个被玩具化的国家。', 8);
INSERT INTO `home_route` VALUES (10, '🐘', '佐乌岛线', '新世界', 4, '通往象背之岛佐乌的航线，草帽团在这里得知了历史正文、光月一族与和之国的秘密，路飞与毛皮族缔结同盟，为和之国决战集结力量。', 9);
INSERT INTO `home_route` VALUES (11, '🍰', '蛋糕岛航线', '新世界', 5, '通往BIG MOM领地蛋糕岛的航线，山治为救家人深陷其中，路飞与卡塔库栗史诗级对决，草帽团大闹茶会，最终救回山治并全身而退。', 10);
INSERT INTO `home_route` VALUES (12, '🤖', '蛋头岛航线', '新世界', 5, '通往最终章蛋头岛的航线，草帽团登陆天才贝加庞克的科学之岛，与海军大将绿牛、赤犬的正面对抗，最终章的大幕在这里缓缓拉开。', 11);
INSERT INTO `home_route` VALUES (13, '🏁', '拉夫坦路', '伟大航路终点', 5, '伟大航路的终点，海贼王罗杰留下ONE PIECE的传说之岛。只有集齐四块红色历史正文、破解其坐标的人才能抵达，是无数海贼梦寐以求的终点。', 12);

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
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '杂货小镇' ROW_FORMAT = DYNAMIC;

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
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '封面图URL',
  `video` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '解说视频URL',
  `summary` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '剧情概要',
  `full_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '完整情节长文',
  `sort_no` int NOT NULL DEFAULT 100 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_story_title`(`title` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '篇章故事' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of home_story
-- ----------------------------
INSERT INTO `home_story` VALUES (1, '🌊', '东海篇', '东海', '漫画 1-61 话', '动画 1-45 集', '路飞、索隆、娜美、乌索普、山治', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E4%B8%9C%E6%B5%B7%E7%AF%87%20%E8%A7%A3%E8%AF%B4', '橡胶少年路飞出海，接连打败亚尔丽塔与恶龙，先后收下剑士、航海士、狙击手与厨师，草帽一伙雏形初成。', '蒙奇·D·路飞，一个梦想成为海贼王的少年，从风车村出发，戴着红发香克斯托付的草帽，踏上了征服大海的旅程。在东海，他先后集结了伙伴：立志成为世界第一大剑豪的索隆、梦想绘制全世界海图的航海士娜美、梦想成为勇敢海上战士的乌索普、梦想找到传说之海All Blue的厨师山治。他们共同击败了阿龙、巴基、克洛等东海恶徒，历经可可西亚村的解放、乌索普故乡的守护、海上餐厅巴拉蒂的激战。当娜美哭喊着「路飞，救救我」的那一刻，草帽扣在她头上，伙伴的誓言就此立下。最终，五人乘坐黄金梅利号，穿越颠倒山，正式驶入伟大航路，开启真正的冒险。', 1);
INSERT INTO `home_story` VALUES (2, '🏜️', '阿拉巴斯坦篇', '伟大航路', '漫画 155-217 话', '动画 92-130 集', '路飞、薇薇、克洛克达尔', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E9%98%BF%E6%8B%89%E5%B7%B4%E6%96%AF%E5%9D%A6%E7%AF%87%20%E8%A7%A3%E8%AF%B4', '为帮助公主薇薇，草帽一伙潜入沙漠王国，揭穿王下七武海克洛克达尔的叛乱阴谋，路飞以橡胶果实之力击碎砂之国阴谋。', '草帽团进入伟大航路后，在威士忌山峰结识了阿拉巴斯坦王国的公主薇薇。她的国家正被七武海之一的沙鳄鱼克洛克达尔操控，陷入内战与干旱。为了拯救这个国家，草帽团对抗巴洛克工作社，乔巴也在磁鼓岛加入。路飞与克洛克达尔三度交锋，最终以「橡胶橡胶·暴风雨」将其击败，阿拉巴斯坦重降甘霖。离别时，薇薇在港口高举手臂，露出象征伙伴的X记号——「只要再见面，我们还是伙伴吗？」这一幕成为全作最动人的羁绊名场面之一。', 2);
INSERT INTO `home_story` VALUES (3, '⛅', '空岛篇', '伟大航路·加雅岛', '漫画 237-302 话', '动画 144-193 集', '路飞、艾尼路、山迪亚战士', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E7%A9%BA%E5%B2%9B%E7%AF%87%20%E8%A7%A3%E8%AF%B4', '乘上升海流抵达一万米高空，卷入神之国四百年战争，路飞以橡胶之身击败雷神艾尼路，敲响黄金钟。', '乘着冲天海流，草帽团抵达一万米高空的空岛。这里的神艾尼路以「神罚」统治着天空之民，山迪亚战士为夺回祖先的土地与黄金钟苦战四百年。路飞凭借橡胶果实天然克制雷电的能力，一拳「黄金回旋弹」击碎神艾尼路，敲响了黄金钟。钟声响彻大地，回应了四百年前大战士卡尔葛拉与罗兰度「一定再相见」的约定。天空之民与山迪亚人重归于好，历史正文与古代兵器的线索也首次浮出水面。', 3);
INSERT INTO `home_story` VALUES (4, '⚖️', '司法岛篇', '伟大航路·水之都', '漫画 375-430 话', '动画 263-312 集', '路飞、罗宾、弗兰奇、CP9', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E5%8F%B8%E6%B3%95%E5%B2%9B%E7%AF%87%20%E8%A7%A3%E8%AF%B4', '为夺回妮可·罗宾，草帽一伙闯入世界政府司法岛，向世界政府宣战并烧毁旗帜，桑尼号由此诞生。', '为了修船，草帽团来到水之七都，却得知黄金梅利号已无法修复。更沉重的打击是罗宾被CP9带走，宣称为了伙伴而「背叛」。草帽团闯入世界政府的司法岛，路飞下令乌索普烧毁政府旗帜，向全世界宣战。路飞喊出「罗宾，说你想活下去！」，罗宾含泪回答「我想活下去！」。二档、三档接连登场，路飞击败罗布·路奇，救回罗宾，弗兰奇加入。而黄金梅利号在火海中燃尽最后一程，向伙伴告别，催泪无数观众。桑尼号随后成为新的伙伴之船。', 4);
INSERT INTO `home_story` VALUES (5, '💀', '恐怖三桅帆船篇', '魔幻三角地带', '漫画 442-489 话', '动画 337-381 集', '路飞、布鲁克、月光·莫利亚', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E6%81%90%E6%80%96%E4%B8%89%E6%A1%85%E5%B8%86%E8%88%B9%E7%AF%87%20%E8%A7%A3%E8%AF%B4', '影子被夺走的恐怖之岛，路飞击败七武海莫利亚，布鲁克加入草帽一伙，甚平与小丑巴基亦在此现身。', '在魔幻三角地带，草帽团遭遇七武海月光·莫利亚，他能夺取他人的影子制造僵尸。众人为夺回影子与透明人阿布萨罗姆、幽灵公主佩罗娜等激战。关键时刻，路飞吸入一百个影子化身「梦魇路飞」，与巨大僵尸奥兹正面硬撼。最终路飞击败莫利亚，黄泉果实能力者布鲁克加入草帽团，他是五十年前与鲸鱼拉布约定的音乐家，一曲《宾克斯的美酒》连接着跨越半世纪的思念。', 5);
INSERT INTO `home_story` VALUES (6, '🔥', '顶上战争篇', '海军本部·马林梵多', '漫画 550-580 话', '动画 459-489 集', '白胡子、艾斯、赤犬、黑胡子', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E9%A1%B6%E4%B8%8A%E6%88%98%E4%BA%89%20%E8%A7%A3%E8%AF%B4', '为营救艾斯，白胡子海贼团与海军本部爆发史上最大战争，艾斯陨落，路飞失去兄长，时代开始剧烈崩塌。', '路飞的哥哥艾斯——海贼王罗杰之子，被海军捕获并判处公开处刑。为救艾斯，路飞闯入推进城越狱，联合白胡子海贼团，在海军本部马林梵多与海军、黑胡子爆发了改变世界格局的「顶上战争」。白胡子爱德华·纽盖特以震震果实威震全场，最终战死，临终前喊出「ONE PIECE是真实存在的！」，再次引爆大海贼时代。艾斯为保护路飞被赤犬贯穿胸膛，含笑而逝。路飞在绝望中崩溃，幸得甚平与伙伴的守护，从悲痛中走出，立下变强的誓言，开启两年修行。', 6);
INSERT INTO `home_story` VALUES (7, '🐟', '鱼人岛篇', '新世界·鱼人岛', '漫画 601-653 话', '动画 517-574 集', '路飞、甚平、白星、霍迪·琼斯', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E9%B1%BC%E4%BA%BA%E5%B2%9B%E7%AF%87%20%E8%A7%A3%E8%AF%B4', '穿越红土大陆抵达海底乐园，粉碎霍迪·琼斯的政变，揭开白星公主与诺亚方舟的古老誓约。', '两年修行后，草帽团在香波地群岛重逢，全员实力大增。他们潜入深海，抵达新世界的第一站鱼人岛。这里的人类与鱼人族矛盾深重，霍迪·琼斯煽动仇恨，企图颠覆鱼人岛。路飞以霸王色霸气与四档力挽狂澜，白星公主的「海王」之力觉醒。路飞宣扬「人类与鱼人平等」的信念，与甚平结下深厚情谊，最终甚平正式加入草帽团，成为第九位伙伴。古代兵器波塞冬的真相也在此揭晓。', 7);
INSERT INTO `home_story` VALUES (8, '🎭', '德雷斯罗萨篇', '新世界·德雷斯罗萨', '漫画 700-801 话', '动画 629-746 集', '路飞、多弗朗明戈、罗、蕾贝卡', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E5%BE%B7%E9%9B%B7%E6%96%AF%E7%BD%97%E8%90%A8%E7%AF%87%20%E8%A7%A3%E8%AF%B4', '路飞与罗的结盟之战，揭穿多弗朗明戈的黑暗交易，鸟笼笼罩全岛，最终以四档弹力终结其统治。', '与罗结成海贼同盟后，草帽团登陆德雷斯罗萨，对抗七武海多弗朗明哥的恐怖统治。明哥以「鸟笼」困住全岛，将无数人变成遗忘记忆的玩具。路飞开启四档，以「猿王枪」正面击碎明哥的明王，解放了玩具奴隶，居鲁士与蕾贝卡父女重逢。艾斯的兄弟萨博现身，继承了烧烧果实与艾斯的意志。路飞悬赏升至5亿贝里，向着「第五皇」迈进。', 8);
INSERT INTO `home_story` VALUES (9, '🐘', '佐乌篇', '新世界·佐乌', '漫画 802-822 话', '动画 751-779 集', '毛皮族、光月家族、锦卫门', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E4%BD%90%E4%B9%8C%E7%AF%87%20%E8%A7%A3%E8%AF%B4', '巨象背上的毛皮族之国，光月家臣在此重聚，众人得知路标历史本文与和之国的秘密。', '草帽团登上巨象之背的佐乌岛，遇见毛皮族与和之国遗孤桃之助。原来佐乌已遭百兽海贼团袭击，毛皮族为守护秘密而誓死抵抗。这里揭示了和之国被凯多与大蛇将军控制的真相，以及光月家族与「历史正文」的紧密关联。锦卫门等家臣向草帽团与罗、毛皮族发出联合讨伐凯多的请求，一场震动世界的和之国决战拉开序幕。', 9);
INSERT INTO `home_story` VALUES (10, '🍰', '蛋糕岛篇', '新世界·万国', '漫画 823-902 话', '动画 783-877 集', '山治、路飞、BIG MOM、卡塔库栗', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E8%9B%8B%E7%B3%95%E5%B2%9B%E7%AF%87%20%E8%A7%A3%E8%AF%B4', '为带回山治，草帽一伙闯入 BIG MOM 的茶会，在镜世界展开激战，山治以最温柔的踢技战胜最强将星。', '山治因杰尔马家族的婚约，被迫离开草帽团前往四皇BIG MOM的万国。为救回伙伴，路飞独闯蛋糕岛。山治在婚礼上真情流露，路飞与BIG MOM海贼团爆发激战。路飞以四档·蛇人形态与最强将星卡塔库栗血战，最终艰难取胜，觉醒见闻色霸气的极致。草帽团全身而退，路飞悬赏飙升至15亿贝里，正式被世人称为「第五皇」。', 10);
INSERT INTO `home_story` VALUES (11, '👹', '和之国篇', '新世界·和之国', '漫画 909-1057 话', '动画 890-1085 集', '路飞、凯多、光月日和、大和', '', 'https://search.bilibili.com/all?keyword=%E6%B5%B7%E8%B4%BC%E7%8E%8B%20%E5%92%8C%E4%B9%8B%E5%9B%BD%E7%AF%87%20%E8%A7%A3%E8%AF%B4', '讨伐百兽凯多的鬼岛大战，路飞觉醒尼卡形态，二十年的锁国终被打破，和之国迎来黎明。', '草帽团联合罗、基德、赤鞘九侠与毛皮族，向四皇凯多与大蛇将军发起总攻，解放闭关锁国的和之国。鬼岛决战中，凯多与大妈结成双皇同盟，战况惨烈。路飞在与凯多的死斗中觉醒「尼卡形态」——橡胶果实的真名「人人果实·幻兽种·尼卡形态」，太阳神之力降临，一拳「猿神枪」将凯多击落。索隆、山治、罗、基德等各有高光。战后凯多与大妈落败，和之国开国，路飞、罗、基德晋升为新四皇，世界政府震动，最终章的大幕随之拉开。', 11);
INSERT INTO `home_story` VALUES (12, '🤖', '蛋头岛篇', '新世界·蛋头岛', '漫画 1060 话起', '动画 1086 集起', '路飞、贝加庞克、乔伊波伊、五老星', '', 'BV1Mw4m1k7u5', '未来岛上遇见天才科学家贝加庞克，炽天使与机器巨鲨登场，世界政府最高战力五老星亲临，空白的一百年真相揭开。', '和之国战后，草帽团抵达天才科学家贝加庞克的未来岛蛋头岛。这里隐藏着恶魔果实的起源、空白一百年与世界政府最高机密。贝加庞克六卫星登场，路飞与黄猿、五老星正面交锋，揭示One Piece与「母火种」的关联。巨人族与古代机器人的秘密浮出水面，草帽团在多方势力的博弈中再度身陷危机。蛋头岛是最终章的第一篇章，路飞与伙伴们朝着「寻找One Piece、揭开世界真相、成为海贼王」的终极目标全速前进。', 12);

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
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '悬赏理由/罪行描述',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_wanted_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 211 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '悬赏令' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of home_wanted
-- ----------------------------
INSERT INTO `home_wanted` VALUES (1, '🎩', '蒙奇·D·路飞', '草帽小子', '草帽一伙', 3000000000, '多次公然对抗世界政府，火烧司法岛旗帜，闯入海军本部，觉醒太阳神尼卡形态，被认定为\"世界最凶恶罪犯\"级别的威胁。');
INSERT INTO `home_wanted` VALUES (2, '🗡️', '罗罗诺亚·索隆', '海贼猎人', '草帽一伙', 1111000000, '海贼猎人出身，三刀流剑士，屡次击溃海军与七武海，目标直指世界第一大剑豪，悬赏金随其剑术不断攀升。');
INSERT INTO `home_wanted` VALUES (3, '🍊', '娜美', '小贼猫', '草帽一伙', 366000000, '草帽团航海士，盗窃多起、操纵天候作战，虽悬赏金不高，却是掌控整艘船航行的关键人物。');
INSERT INTO `home_wanted` VALUES (4, '🎯', '乌索普', 'GOD', '草帽一伙', 500000000, '德雷斯罗萨之战中以超远距离狙杀砂糖、解放玩具士兵，被误认为\"神\"，悬赏金因\"GOD\"之名暴涨。');
INSERT INTO `home_wanted` VALUES (5, '🚬', '文斯莫克·山治', '黑脚', '草帽一伙', 1032000000, '文斯莫克家族第三子，草帽团厨师，屡次踢飞海军强者，黑脚山治之名令海军头痛。');
INSERT INTO `home_wanted` VALUES (6, '🦌', '托尼托尼·乔巴', '爱之勇者', '草帽一伙', 1000, '草帽团船医，人人果实能力者，虽被严重低估悬赏仅1000贝利，却是能治愈一切疾病的医生。');
INSERT INTO `home_wanted` VALUES (7, '📚', '妮可·罗宾', '恶魔之子', '草帽一伙', 930000000, '\"恶魔之子\"，能解读历史正文的考古学家，世界政府最想抹杀的存在之一，悬赏金随其重要性持续攀升。');
INSERT INTO `home_wanted` VALUES (8, '🔧', '弗兰奇', '铁人', '草帽一伙', 394000000, '改造人船匠，桑尼号的制造者，多次击碎海军战舰，是草帽团最可靠的机械战力。');
INSERT INTO `home_wanted` VALUES (9, '🎻', '布鲁克', '灵魂之王', '草帽一伙', 383000000, '黄泉果实能力者，骷髅音乐家，灵魂之王，虽已\"死\"却仍活跃在海上，是草帽团最年长的成员。');
INSERT INTO `home_wanted` VALUES (10, '☁️', '唐吉诃德·多弗朗明戈', '天夜叉', '唐吉诃德家族', 340000000, '唐吉诃德家族首领，线线果实能力者，原德雷斯罗萨国王，被路飞四档击溃。');
INSERT INTO `home_wanted` VALUES (11, '👊', '甚平', '海侠', '草帽一伙', 1100000000, '原王下七武海，太阳海贼团舵手，鱼人空手道大师，正式加入草帽团后成为舵手。');
INSERT INTO `home_wanted` VALUES (12, '🔴', '香克斯', '红发', '红发海贼团', 4048900000, '四皇之一，红发海贼团船长，路飞的引路人，拥有震慑海军的\"面子\"与无人能敌的霸气。');
INSERT INTO `home_wanted` VALUES (13, '🏔️', '爱德华·纽盖特', '白胡子', '白胡子海贼团', 5046000000, '\"世界最强的男人\"，震震果实能力者，白胡子海贼团船长，顶上战争中为救艾斯孤身战海军本部。');
INSERT INTO `home_wanted` VALUES (14, '🌑', '马歇尔·D·蒂奇', '黑胡子', '黑胡子海贼团', 3996000000, '黑胡子海贼团提督，史上唯一双果实能力者，夺取白胡子震震果实，野心勃勃的四皇。');
INSERT INTO `home_wanted` VALUES (15, '🐉', '凯多', '百兽', '百兽海贼团', 4611100000, '百兽海贼团总督，鱼鱼果实·青龙形态，\"最强生物\"，企图发动世界战争，被路飞觉醒尼卡形态击落。');
INSERT INTO `home_wanted` VALUES (16, '🎂', '夏洛特·玲玲', 'BIG MOM', 'BIG MOM 海贼团', 4388000000, 'BIG MOM海贼团船长，魂魂果实能力者，四皇之一，渴望建立万国，被基德与罗联手击落。');
INSERT INTO `home_wanted` VALUES (17, '♥️', '特拉法尔加·罗', '死亡外科医生', '心脏海贼团', 3000000000, '心脏海贼团船长，手术果实能力者，极恶世代十一超新星之一，与路飞、基德齐名。');
INSERT INTO `home_wanted` VALUES (18, '🧲', '尤斯塔斯·基德', '船长', '基德海贼团', 3000000000, '基德海贼团船长，磁磁果实能力者，极恶世代之一，与罗联手击落BIG MOM。');
INSERT INTO `home_wanted` VALUES (19, '🐊', '克洛克达尔', '沙漠王', '巴洛克工作社', 81000000, '巴洛克工作社首领，沙沙果实能力者，曾企图夺取阿拉巴斯坦，被路飞击败。');
INSERT INTO `home_wanted` VALUES (20, '👁️', '乔拉可尔·米霍克', '鹰眼', '无（七武海）', 3590000000, '王下七武海，世界第一大剑豪，索隆要超越的目标，孤高的剑术顶点。');
INSERT INTO `home_wanted` VALUES (21, '🤡', '巴基', '小丑', '巴基速递', 3189000000, '巴基速递首领，前罗杰海贼团见习船员，虽实力平平却凭运气登上七武海之位。');

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '船员名册（注册用户表）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, '路飞', 'luffy@onepiece.com', '$2b$10$izOLX7eLglz39jM2R9IVPekziQOOddxJV47S08pHjRCbOIdbbZRvK', '2026-10-29 13:52:50');
INSERT INTO `sys_user` VALUES (2, '罗宾酱', '123456@qq.com', '$2a$10$lJc943ntWjkfa1fYaVea3.0AjSwJZSpQ8xIJmXBa1f5PD5.seYusC', '2026-10-29 14:08:25');
INSERT INTO `sys_user` VALUES (3, '温文尔雅', '23456@qq.com', '$2a$10$QGMOkAYc8hXyd0BKGPDzBOF4Gy5qVdTItPsPjYxGtRXgYGZTDi1aq', '2026-11-02 08:57:37');

SET FOREIGN_KEY_CHECKS = 1;
