-- ============================================================
-- 船员名册：完整人物介绍（身世/性格/能力/成长/名场面）扩充
-- description 改为 TEXT 后可容纳完整长文
-- ============================================================
USE springboottest;
SET NAMES utf8mb4;

-- 草帽一伙
UPDATE home_crew SET description = '草帽海贼团船长，梦想成为海贼王。出生于东海风车村，自幼吃下橡胶果实（实为动物系·人人果实·幻兽种·尼卡形态），被红发香克斯寄托草帽。他单纯、热血、重情义，坚信伙伴高于一切，是能把所有人心凝聚起来的"天生的领袖"。在司法岛当众烧毁世界政府旗帜、在顶上战争为救艾斯孤身闯海军本部、在和之国觉醒尼卡形态以太阳神姿态击败凯多，一步步从东海小海贼成长为被称作"第五位海上皇帝"的男人。' WHERE id = 1;

UPDATE home_crew SET description = '草帽一伙剑士，梦想成为世界第一大剑豪。出生于东海霜月村，幼年挚友古伊娜意外离世后立下誓言，练成三刀流。他冷静坚毅、意志如铁，是路飞第一个伙伴，也是草帽团的战斗核心。在恐怖三桅帆船篇为保护伙伴承受路飞全部的伤痛，在司法岛、德雷斯罗萨、和之国屡次以惊人剑术击溃强敌，最终目标是超越"鹰眼"米霍克。' WHERE id = 2;

UPDATE home_crew SET description = '草帽一伙航海士，梦想画出全世界的海图。出生于东海可可亚西村，幼年被鱼人阿龙胁迫，被迫绘制海图，后被路飞拯救。她精明、爱财、强悍，是掌控整艘船航行的大脑，擅长气象学，能感知天候变化。在和之国大战中使出雷云宙斯与天候术，实力早已今非昔比。' WHERE id = 3;

UPDATE home_crew SET description = '草帽一伙狙击手，自称"海上勇士"。出生于东海西罗布村，父亲是红发海贼团的耶稣布。他胆小却勇敢，在最关键的时刻从不退缩，名言是"狙击手，就是要在别人看不见的地方保护伙伴"。在德雷斯罗萨以超远距离狙杀砂糖、成为解放玩具士兵的关键，被称作"GOD乌索普"。' WHERE id = 4;

UPDATE home_crew SET description = '草帽一伙厨师，梦想找到传说之海"ALL BLUE"。出生于北海杰尔马王国的文斯莫克家族，自幼被家族虐待，后逃出师从红脚哲普。他尊重食物与女性，绝不浪费粮食，是船上无与伦比的厨师兼战斗员。在蛋糕岛篇与家族和解、在鬼岛大战中以"魔神风脚"击碎百兽凯多麾下强敌，黑脚山治的名号响彻新世界。' WHERE id = 5;

UPDATE home_crew SET description = '草帽一伙船医，一只吃下人人果实的驯鹿。出生于伟大航路磁鼓王国，被养父希鲁鲁克医生救下，继承了"万能药"的信念。他天真善良、医术高超，能变身多种形态，梦想成为能治愈一切疾病的医生。虽然悬赏金只有1000贝利，却是草帽团不可或缺的伙伴与团宠。' WHERE id = 6;

UPDATE home_crew SET description = '草帽一伙考古学家，梦想解读历史正文、寻找空白的一百年真相。出生于西海奥哈拉，8岁时奥哈拉被屠魔令毁灭，成为"恶魔之子"被世界政府通缉。她冷静聪慧、腹黑幽默，吃下花花果实，可在任意地方长出身体部位。在司法岛那句"说我想活下去"震撼人心，最终成为能读懂历史正文的关键人物。' WHERE id = 7;

UPDATE home_crew SET description = '草帽一伙船匠，梦想让"桑尼号"环绕世界一周。出生于南海，被海贼父母遗弃，师从鱼人汤姆，继承其造船技艺。他是改造人，身体藏有可乐驱动的武器系统，性格奔放热情，动手能力极强。在鬼岛大战中击碎杰尔马科技战舰，是草帽团最可靠的机械战力。' WHERE id = 8;

UPDATE home_crew SET description = '草帽一伙音乐家，一个活了90多年的骷髅。出生于西海，吃下黄泉果实，死后灵魂回到骷髅复活。他乐观幽默、绅士礼貌，梦想是与拉布重逢。作为音乐家能演奏小提琴、能御剑，还能以灵魂能力攻击敌人，是草帽团里最年长也最快乐的一员。' WHERE id = 9;

UPDATE home_crew SET description = '草帽一伙舵手，原王下七武海、太阳海贼团舵手。出生于鱼人岛，是鲸鲨鱼人，侠肝义胆、稳重可靠，被称为"海侠"。他坚守鱼人的尊严与对艾斯的兄弟情，在鬼岛大战中以"鱼人空手道"击退凯多，正式加入草帽一伙，成为船上的舵手与定海神针。' WHERE id = 10;

-- 四皇与传奇
UPDATE home_crew SET description = '红发海贼团船长，四皇之一。出生于西海，曾是海贼王罗杰船上见习船员，后自立门户。他是路飞成为海贼的引路人，将草帽托付给路飞并约定在顶点重逢。他实力深不可测，霸气无人能敌，能用"面子"震慑海军与四皇，是当前大海上最神秘的强者之一。' WHERE id = 11;

UPDATE home_crew SET description = '白胡子海贼团船长，被称为"世界最强的男人"。出生于伟大航路斯芬克斯，吃下震震果实，能引发海啸与地震。他将所有船员视为儿子，一生只求一个家。顶上战争中为救艾斯孤身战海军本部，身中267处刀伤、152发子弹仍屹立不倒，最终以"我是旧时代的残党"悲壮谢幕。' WHERE id = 12;

UPDATE home_crew SET description = '黑胡子海贼团提督，四皇之一，史上唯一拥有两颗恶魔果实的人（暗暗果实+震震果实）。出生于伟大航路，隐忍二十年等待时机，野心勃勃、不择手段。他杀害了第四队队长萨奇夺取暗暗果实，抓住艾斯献给海军、引发顶上战争，最终夺取白胡子震震果实，一步步登上四皇宝座。' WHERE id = 13;

UPDATE home_crew SET description = '百兽海贼团总督，四皇之一，被称为"最强生物"。出生于新世界和之国，吃下鱼鱼果实·幻兽种·青龙形态，能化为巨龙呼风唤雨。他崇尚"战争才是世界的规则"，企图建立全动物系军团发动世界战争。在和之国大战中被路飞以觉醒尼卡形态击落，其海贼团随之瓦解。' WHERE id = 14;

UPDATE home_crew SET description = 'BIG MOM海贼团船长，四皇之一。出生于新世界万国，吃下魂魂果实，能操纵灵魂、赋予万物生命。她暴虐任性、贪食甜点，渴望建立所有种族和平共处的"万国"，但手段残忍。在与基德、罗的联手作战中被击败，退出了四皇之位。' WHERE id = 15;

-- 超新星
UPDATE home_crew SET description = '心脏海贼团船长，"极恶世代"十一超新星之一。出生于北海弗雷凡斯，幼年家乡因铂铅病被毁灭，怀抱着对多弗朗明哥的仇恨。吃下手术果实，能创造"ROOM"空间进行任意切割与交换，是价值50亿贝利的"究极恶魔果实"。在与凯多之战中与基德联手击落BIG MOM，是新时代的代表之一。' WHERE id = 16;

UPDATE home_crew SET description = '基德海贼团船长，"极恶世代"十一超新星之一，与路飞、罗齐名。出生于南海，吃下磁磁果实，能操纵金属。他桀骜不驯、残暴好斗，却也重情义。在万国篇被凯多击败后越狱，与罗联手在和之国击落BIG MOM，成为推翻旧时代的重要战力。' WHERE id = 17;

-- 海军
UPDATE home_crew SET description = '海军本部元帅，代号"赤犬"。出生于北海，吃下岩浆果实，能化为岩浆攻击，破坏力堪称海军之最。他信奉"绝对的正义"，手段极端狠辣，顶上战争中亲手击杀艾斯、重创路飞。在与青雉的十天大战中获胜升任元帅，是路飞等人的宿敌。' WHERE id = 18;

UPDATE home_crew SET description = '原海军大将，代号"青雉"。出生于南海，吃下冰冻果实，能冻结万物。他信奉"懒散的正义"，性格慵懒却洞察世事。在与赤犬争夺元帅之位的十天大战中败北，断腿后离开海军，成为自由人，暗中观察着世界的走向。' WHERE id = 19;

UPDATE home_crew SET description = '海军本部大将，代号"黄猿"。出生于北海，吃下闪光果实，能以光速移动、发射激光。他总是一副漫不经心的懒散模样，实力却深不可测，信奉"模糊的正义"。作为海军最高战力之一，多次与海贼强者交锋，其真正立场始终成谜。' WHERE id = 20;

UPDATE home_crew SET description = '海军本部中将，被称为"铁拳卡普"，是路飞的爷爷、龙的父亲。他追击海贼王罗杰多年，曾多次将其逼入绝境，是海军中唯一能被称为"英雄"的人。他不使用恶魔果实，凭一双铁拳和霸王色霸气纵横大海，顶上战争时虽身居海军却放水救下路飞，是集正义与亲情于一身的老兵。' WHERE id = 21;

UPDATE home_crew SET description = '海军本部少将，SWORD机密行动部队成员。出生于东海，是路飞、艾斯少年时代的伙伴，一路追随着路飞的脚步成长。他善良正直，从懦弱少年蜕变为独当一面的海军军官，梦想是成为海军大将。在蛋头岛篇加入SWORD，与路飞并肩作战对抗世界政府。' WHERE id = 22;

UPDATE home_crew SET description = '海军本部中将，代号"白猎人"。出生于伟大航路罗格镇，吃下烟雾果实，能化为烟雾战斗。他固执坚持自己的正义，在罗格镇曾差点抓住路飞，此后一路追击草帽团。他并非冷酷无情，对海贼也有自己的判断，是海军中难得的良知派。' WHERE id = 23;

UPDATE home_crew SET description = '王下七武海，被称为"鹰眼"，是世界第一大剑豪。出生于伟大航路克拉伊咖那岛，不使用恶魔果实，凭一把黑刀"夜"纵横大海，是索隆超越的目标。他孤高冷峻、深不可测，曾与红发香克斯多次交锋，是海上真正的剑术顶点。' WHERE id = 24;

-- ============================================================
-- 新增经典角色（丰富船员名册）
-- ============================================================
INSERT INTO home_crew (icon, name, alias, position, affiliation, origin, devil_fruit, image, bounty, description, deeds, sort_no)
SELECT * FROM (SELECT '☠️' icon, '哥尔·D·罗杰' name, '海贼王' alias, '罗杰海贼团船长' position, '罗杰海贼团' affiliation, '东海·罗格镇' origin, '无' devil_fruit, NULL image, 5506480000 bounty, '史上第一位完成伟大航路、征服"新世界"的海贼王，被称为"海贼王"。他找到传说之岛拉夫坦路，洞悉了世界的真相，却身患绝症，主动向海军自首，在罗格镇被处刑前喊出"去找吧！我把一切都放在那里了"，开启了轰轰烈烈的大海贼时代。' description, '找到拉夫坦路、开创大海贼时代、临终遗言开启罗杰时代' deeds, 101 sort_no) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM home_crew WHERE name = '哥尔·D·罗杰');

INSERT INTO home_crew (icon, name, alias, position, affiliation, origin, devil_fruit, image, bounty, description, deeds, sort_no)
SELECT * FROM (SELECT '🔥' icon, '波特卡斯·D·艾斯' name, '火拳' alias, '白胡子海贼团二番队队长' position, '白胡子海贼团' affiliation, '东海·哥亚王国' origin, '烧烧果实' devil_fruit, NULL image, 550000000 bounty, '白胡子海贼团二番队队长，海贼王罗杰之子，路飞的义兄。吃下烧烧果实，能化为火焰，被称作"火拳艾斯"。他一生都在寻找自己存在的意义，最终为保护路飞挡下赤犬一击而牺牲，那句"谢谢你们，如此爱着我"让无数人落泪。' description, '顶上战争为救路飞牺牲、烧烧果实继承者萨博登场' deeds, 102 sort_no) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM home_crew WHERE name = '波特卡斯·D·艾斯');

INSERT INTO home_crew (icon, name, alias, position, affiliation, origin, devil_fruit, image, bounty, description, deeds, sort_no)
SELECT * FROM (SELECT '🧵' icon, '多弗朗明哥' name, '天夜叉' alias, '唐吉诃德海贼团船长' position, '唐吉诃德海贼团' affiliation, '圣地·玛丽乔亚' origin, '线线果实' devil_fruit, NULL image, 340000000 bounty, '原天龙人，唐吉诃德海贼团船长，也是德雷斯罗萨的国王。吃下线线果实，能操纵丝线操控他人。他狂妄残忍、把世界当作游戏，在德雷斯罗萨篇被路飞以四档"大猿王枪"击败，其罪恶的黑市帝国随之崩塌。' description, '操控德雷斯罗萨十年、被路飞四档击溃' deeds, 103 sort_no) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM home_crew WHERE name = '多弗朗明哥');

INSERT INTO home_crew (icon, name, alias, position, affiliation, origin, devil_fruit, image, bounty, description, deeds, sort_no)
SELECT * FROM (SELECT '🐍' icon, '波雅·汉库克' name, '海贼女帝' alias, '九蛇海贼团船长' position, '九蛇海贼团' affiliation, '亚马逊·百合' origin, '甜甜果实' devil_fruit, NULL image, 1659000000 bounty, '女儿岛亚马逊·百合的皇帝，九蛇海贼团船长，被称为"海贼女帝"。吃下甜甜果实，凡是被她魅惑的人都将石化。她骄傲自恋，却对路飞一见钟情、死心塌地，是王下七武海中唯一的女性，也是路飞的坚定盟友。' description, '爱上路飞、为路飞对抗海军与天龙人' deeds, 104 sort_no) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM home_crew WHERE name = '波雅·汉库克');

INSERT INTO home_crew (icon, name, alias, position, affiliation, origin, devil_fruit, image, bounty, description, deeds, sort_no)
SELECT * FROM (SELECT '🌊' icon, '藤虎' name, '藤虎一笑' alias, '海军本部大将' position, '海军本部' affiliation, '无' origin, '重力果实' devil_fruit, NULL image, 0 bounty, '海军本部大将，本名一笑，是个盲人剑客。吃下重力果实，能操纵重力引发陨石坠落。他信奉"仁义的正义"，在德雷斯罗萨篇当众下跪为海军的罪恶道歉，是海军中少有的敢于反抗世界政府的人。' description, '德雷斯罗萨当众下跪致歉、废除王下七武海制度' deeds, 105 sort_no) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM home_crew WHERE name = '藤虎一笑');

INSERT INTO home_crew (icon, name, alias, position, affiliation, origin, devil_fruit, image, bounty, description, deeds, sort_no)
SELECT * FROM (SELECT '🍀' icon, '绿牛' name, '绿牛' alias, '海军本部大将' position, '海军本部' affiliation, '无' origin, '森森果实' devil_fruit, NULL image, 0 bounty, '海军本部大将，本名荒卷，被称为"绿牛"。吃下森森果实，能操纵植物、化身为森林。他性格狂放不羁，对强者充满敬意，在蛋头岛篇登场，展现出与赤犬等人截然不同的海军大将风格。' description, '蛋头岛篇登场、展现森森果实威能' deeds, 106 sort_no) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM home_crew WHERE name = '绿牛');

INSERT INTO home_crew (icon, name, alias, position, affiliation, origin, devil_fruit, image, bounty, description, deeds, sort_no)
SELECT * FROM (SELECT '💀' icon, '凯多之子·大和' name, '鬼之女' alias, '百兽海贼团' position, '百兽海贼团（叛逃）' affiliation, '和之国' origin, '犬犬果实·幻兽种·大口真神形态' devil_fruit, NULL image, 0 bounty, '凯多之女，崇拜光月御田，自称为"御田"。吃下大口真神果实，能化为白色巨狼、口吐寒冰。她在鬼岛大战中反抗父亲凯多，帮助路飞等人，战后留在和之国守护这个国家。' description, '反抗凯多、助路飞觉醒尼卡形态' deeds, 107 sort_no) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM home_crew WHERE name = '凯多之子·大和');
