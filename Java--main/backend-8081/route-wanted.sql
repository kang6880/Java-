-- ============================================================
-- 航线图鉴 + 悬赏令 内容扩充
-- ============================================================
USE springboottest;
SET NAMES utf8mb4;

-- 航线描述扩充
UPDATE home_route SET description = '路飞从风车村出海的第一段旅程，途径谢尔兹镇、橘子镇，击败斧手摩根、小丑巴基，收下索隆、娜美、乌索普、山治等最初的伙伴，是一切冒险的起点。' WHERE name = '东海启程线';
UPDATE home_route SET description = '进入伟大航路的入口，穿过双子岬、威士忌山峰，遇到鲸鱼拉布、与克比重逢，草帽团在这里正式踏上寻找海贼王之路，并立下各自的梦想誓言。' WHERE name = '伟大航路前半';
UPDATE home_route SET description = '草帽团登陆沙漠王国阿拉巴斯坦，与克洛克达尔的巴洛克工作社正面交锋，路飞首次击败王下七武海，拯救了薇薇公主与整个国家，也让草帽团声名大噪。' WHERE name = '阿拉巴斯坦线';
UPDATE home_route SET description = '环绕水之都的海上路线，草帽团在这里与CP9对决、失去梅利号，罗宾被抓走，路飞开发出二档、三档，是草帽团最惨痛也最成长的一段旅程。' WHERE name = '水之都环岛线';
UPDATE home_route SET description = '通往和之国的危险航线，沿途被凯多的百兽海贼团与和之国武士严密把守，是四皇凯多的地盘，也是路飞觉醒尼卡形态、击落凯多的决战之地。' WHERE name = '和之国航线';
UPDATE home_route SET description = '通往空岛的天路航线，借助上升海流冲上万米高空，路飞在这里与神·艾尼路对决，为拉夫坦路的历史正文埋下伏笔，也是山治第一次展露厨艺之魂。' WHERE name = '空岛航线';
UPDATE home_route SET description = '通往磁鼓王国的航线，草帽团在这里遇到船医乔巴，路飞背着重伤的娜美登上磁鼓山求医，乔巴加入，是草帽团收获"万能药"伙伴的地方。' WHERE name = '磁鼓王国线';
UPDATE home_route SET description = '深入海底一万米的鱼人岛航线，草帽团在这里与霍迪·琼斯对决，路飞展现霸王色霸气，甚平正式与草帽团结缘，也为鱼人与人类的和平埋下希望。' WHERE name = '鱼人岛航线';
UPDATE home_route SET description = '通往德雷斯罗萨的航线，路飞在这里与多弗朗明哥决战，开启四档"弹力人"，乌索普觉醒见闻色霸气成为"GOD"，拯救了整个被玩具化的国家。' WHERE name = '德雷斯罗萨线';
UPDATE home_route SET description = '通往象背之岛佐乌的航线，草帽团在这里得知了历史正文、光月一族与和之国的秘密，路飞与毛皮族缔结同盟，为和之国决战集结力量。' WHERE name = '佐乌岛线';
UPDATE home_route SET description = '通往BIG MOM领地蛋糕岛的航线，山治为救家人深陷其中，路飞与卡塔库栗史诗级对决，草帽团大闹茶会，最终救回山治并全身而退。' WHERE name = '蛋糕岛航线';
UPDATE home_route SET description = '通往最终章蛋头岛的航线，草帽团登陆天才贝加庞克的科学之岛，与海军大将绿牛、赤犬的正面对抗，最终章的大幕在这里缓缓拉开。' WHERE name = '蛋头岛航线';
UPDATE home_route SET description = '伟大航路的终点，海贼王罗杰留下ONE PIECE的传说之岛。只有集齐四块红色历史正文、破解其坐标的人才能抵达，是无数海贼梦寐以求的终点。' WHERE name = '拉夫坦路';

-- 悬赏令罪行描述扩充
UPDATE home_wanted SET description = '多次公然对抗世界政府，火烧司法岛旗帜，闯入海军本部，觉醒太阳神尼卡形态，被认定为"世界最凶恶罪犯"级别的威胁。' WHERE name = '蒙奇·D·路飞';
UPDATE home_wanted SET description = '海贼猎人出身，三刀流剑士，屡次击溃海军与七武海，目标直指世界第一大剑豪，悬赏金随其剑术不断攀升。' WHERE name = '罗罗诺亚·索隆';
UPDATE home_wanted SET description = '草帽团航海士，盗窃多起、操纵天候作战，虽悬赏金不高，却是掌控整艘船航行的关键人物。' WHERE name = '娜美';
UPDATE home_wanted SET description = '德雷斯罗萨之战中以超远距离狙杀砂糖、解放玩具士兵，被误认为"神"，悬赏金因"GOD"之名暴涨。' WHERE name = '乌索普';
UPDATE home_wanted SET description = '文斯莫克家族第三子，草帽团厨师，屡次踢飞海军强者，黑脚山治之名令海军头痛。' WHERE name = '文斯莫克·山治';
UPDATE home_wanted SET description = '草帽团船医，人人果实能力者，虽被严重低估悬赏仅1000贝利，却是能治愈一切疾病的医生。' WHERE name = '托尼托尼·乔巴';
UPDATE home_wanted SET description = '"恶魔之子"，能解读历史正文的考古学家，世界政府最想抹杀的存在之一，悬赏金随其重要性持续攀升。' WHERE name = '妮可·罗宾';
UPDATE home_wanted SET description = '改造人船匠，桑尼号的制造者，多次击碎海军战舰，是草帽团最可靠的机械战力。' WHERE name = '弗兰奇';
UPDATE home_wanted SET description = '黄泉果实能力者，骷髅音乐家，灵魂之王，虽已"死"却仍活跃在海上，是草帽团最年长的成员。' WHERE name = '布鲁克';
UPDATE home_wanted SET description = '原王下七武海，太阳海贼团舵手，鱼人空手道大师，正式加入草帽团后成为舵手。' WHERE name = '甚平';
UPDATE home_wanted SET description = '四皇之一，红发海贼团船长，路飞的引路人，拥有震慑海军的"面子"与无人能敌的霸气。' WHERE name = '香克斯';
UPDATE home_wanted SET description = '"世界最强的男人"，震震果实能力者，白胡子海贼团船长，顶上战争中为救艾斯孤身战海军本部。' WHERE name = '爱德华·纽盖特';
UPDATE home_wanted SET description = '黑胡子海贼团提督，史上唯一双果实能力者，夺取白胡子震震果实，野心勃勃的四皇。' WHERE name = '马歇尔·D·蒂奇';
UPDATE home_wanted SET description = '百兽海贼团总督，鱼鱼果实·青龙形态，"最强生物"，企图发动世界战争，被路飞觉醒尼卡形态击落。' WHERE name = '凯多';
UPDATE home_wanted SET description = 'BIG MOM海贼团船长，魂魂果实能力者，四皇之一，渴望建立万国，被基德与罗联手击落。' WHERE name = '夏洛特·玲玲';
UPDATE home_wanted SET description = '心脏海贼团船长，手术果实能力者，极恶世代十一超新星之一，与路飞、基德齐名。' WHERE name = '特拉法尔加·罗';
UPDATE home_wanted SET description = '基德海贼团船长，磁磁果实能力者，极恶世代之一，与罗联手击落BIG MOM。' WHERE name = '尤斯塔斯·基德';
UPDATE home_wanted SET description = '唐吉诃德家族首领，线线果实能力者，原德雷斯罗萨国王，被路飞四档击溃。' WHERE name = '唐吉诃德·多弗朗明戈';
UPDATE home_wanted SET description = '巴洛克工作社首领，沙沙果实能力者，曾企图夺取阿拉巴斯坦，被路飞击败。' WHERE name = '克洛克达尔';
UPDATE home_wanted SET description = '王下七武海，世界第一大剑豪，索隆要超越的目标，孤高的剑术顶点。' WHERE name = '乔拉可尔·米霍克';
UPDATE home_wanted SET description = '巴基速递首领，前罗杰海贼团见习船员，虽实力平平却凭运气登上七武海之位。' WHERE name = '巴基';
