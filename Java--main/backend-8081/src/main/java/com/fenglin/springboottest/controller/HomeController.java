package com.fenglin.springboottest.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.HomeCrew;
import com.fenglin.springboottest.entity.HomeRoute;
import com.fenglin.springboottest.entity.HomeShop;
import com.fenglin.springboottest.entity.HomeStory;
import com.fenglin.springboottest.entity.HomeWanted;
import com.fenglin.springboottest.mapper.HomeCrewMapper;
import com.fenglin.springboottest.mapper.HomeRouteMapper;
import com.fenglin.springboottest.mapper.HomeShopMapper;
import com.fenglin.springboottest.mapper.HomeStoryMapper;
import com.fenglin.springboottest.mapper.HomeWantedMapper;
import com.fenglin.springboottest.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 首页接口（均需登录态，由 WebConfig 拦截 /api/home/**）
 *
 * <ul>
 *   <li>GET /api/home/summary          首页统计 + 榜单</li>
 *   <li>GET /api/home/crews            船员名册列表</li>
 *   <li>GET /api/home/routes           航线图鉴列表</li>
 *   <li>GET /api/home/wanteds          悬赏令列表</li>
 *   <li>GET /api/home/shops            杂货小镇列表</li>
 *   <li>GET /api/home/stories          篇章故事列表</li>
 *   <li>GET /api/home/search?keyword=  五路模糊搜索</li>
 * </ul>
 */
@RestController
@RequestMapping("/api/home")
public class HomeController {

    /** 首页榜单各取前几名 */
    private static final int TOP_N = 3;

    @Autowired
    private HomeRouteMapper homeRouteMapper;

    @Autowired
    private HomeWantedMapper homeWantedMapper;

    @Autowired
    private HomeCrewMapper homeCrewMapper;

    @Autowired
    private HomeShopMapper homeShopMapper;

    @Autowired
    private HomeStoryMapper homeStoryMapper;

    @Autowired
    private UserMapper userMapper;

    /* ---------------- 列表接口 ---------------- */

    @GetMapping("/crews")
    public Result<List<HomeCrew>> crews() {
        return Result.ok(homeCrewMapper.selectList(
                new LambdaQueryWrapper<HomeCrew>().orderByAsc(HomeCrew::getSortNo)));
    }

    @GetMapping("/routes")
    public Result<List<HomeRoute>> routes() {
        return Result.ok(homeRouteMapper.selectList(
                new LambdaQueryWrapper<HomeRoute>().orderByAsc(HomeRoute::getSortNo)));
    }

    @GetMapping("/wanteds")
    public Result<List<HomeWanted>> wanteds() {
        return Result.ok(homeWantedMapper.selectList(
                new LambdaQueryWrapper<HomeWanted>().orderByDesc(HomeWanted::getBounty)));
    }

    @GetMapping("/shops")
    public Result<List<HomeShop>> shops() {
        return Result.ok(homeShopMapper.selectList(
                new LambdaQueryWrapper<HomeShop>().orderByAsc(HomeShop::getSortNo)));
    }

    @GetMapping("/stories")
    public Result<List<HomeStory>> stories() {
        return Result.ok(homeStoryMapper.selectList(
                new LambdaQueryWrapper<HomeStory>().orderByAsc(HomeStory::getSortNo)));
    }

    /* ---------------- 汇总 ---------------- */

    /**
     * 首页汇总：各类数据条数 + 榜单卡片
     */
    @GetMapping("/summary")
    public Result<Map<String, Object>> summary() {
        Map<String, Object> data = new LinkedHashMap<>();
        // 已注册船员（sys_user）
        data.put("crewCount", userMapper.selectCount(null));
        // 名册收录角色数（home_crew）
        data.put("roleCount", homeCrewMapper.selectCount(null));
        data.put("routeCount", homeRouteMapper.selectCount(null));
        data.put("wantedCount", homeWantedMapper.selectCount(null));
        data.put("shopCount", homeShopMapper.selectCount(null));
        data.put("storyCount", homeStoryMapper.selectCount(null));

        data.put("topRoutes", homeRouteMapper.selectList(
                new LambdaQueryWrapper<HomeRoute>()
                        .orderByAsc(HomeRoute::getSortNo)
                        .last("LIMIT " + TOP_N)));

        data.put("topWanteds", homeWantedMapper.selectList(
                new LambdaQueryWrapper<HomeWanted>()
                        .orderByDesc(HomeWanted::getBounty)
                        .last("LIMIT " + TOP_N)));

        data.put("topCrews", homeCrewMapper.selectList(
                new LambdaQueryWrapper<HomeCrew>()
                        .orderByDesc(HomeCrew::getBounty)
                        .last("LIMIT " + TOP_N)));

        data.put("topStories", homeStoryMapper.selectList(
                new LambdaQueryWrapper<HomeStory>()
                        .orderByAsc(HomeStory::getSortNo)
                        .last("LIMIT " + TOP_N)));

        return Result.ok(data);
    }

    /* ---------------- 搜索 ---------------- */

    /**
     * 全站搜索：关键字同时模糊匹配
     * 航线（名称/海域/简介）、悬赏令（海贼名/称号/海贼团）、
     * 船员名册（角色名/外号/势力/恶魔果实）、杂货（店铺/类别/商品）、篇章（标题/概要/人物）
     */
    @GetMapping("/search")
    public Result<Map<String, Object>> search(@RequestParam("keyword") String keyword) {
        String kw = keyword == null ? "" : keyword.trim();
        if (kw.isEmpty()) {
            return Result.fail("关键字不能为空");
        }
        // 转义 LIKE 通配符，防止 % 和 _ 造成全表匹配
        String like = escapeLike(kw);

        List<HomeRoute> routes = homeRouteMapper.selectList(
                new LambdaQueryWrapper<HomeRoute>()
                        .and(w -> w.like(HomeRoute::getName, like)
                                .or().like(HomeRoute::getRegion, like)
                                .or().like(HomeRoute::getDescription, like))
                        .orderByAsc(HomeRoute::getSortNo));

        List<HomeWanted> wanteds = homeWantedMapper.selectList(
                new LambdaQueryWrapper<HomeWanted>()
                        .and(w -> w.like(HomeWanted::getName, like)
                                .or().like(HomeWanted::getEpithet, like)
                                .or().like(HomeWanted::getCrew, like))
                        .orderByDesc(HomeWanted::getBounty));

        List<HomeCrew> crews = homeCrewMapper.selectList(
                new LambdaQueryWrapper<HomeCrew>()
                        .and(w -> w.like(HomeCrew::getName, like)
                                .or().like(HomeCrew::getAlias, like)
                                .or().like(HomeCrew::getAffiliation, like)
                                .or().like(HomeCrew::getDevilFruit, like))
                        .orderByDesc(HomeCrew::getBounty));

        List<HomeShop> shops = homeShopMapper.selectList(
                new LambdaQueryWrapper<HomeShop>()
                        .and(w -> w.like(HomeShop::getName, like)
                                .or().like(HomeShop::getCategory, like)
                                .or().like(HomeShop::getItem, like)
                                .or().like(HomeShop::getLocation, like))
                        .orderByAsc(HomeShop::getSortNo));

        List<HomeStory> stories = homeStoryMapper.selectList(
                new LambdaQueryWrapper<HomeStory>()
                        .and(w -> w.like(HomeStory::getTitle, like)
                                .or().like(HomeStory::getSummary, like)
                                .or().like(HomeStory::getMainRoles, like))
                        .orderByAsc(HomeStory::getSortNo));

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("routes", routes);
        data.put("wanteds", wanteds);
        data.put("crews", crews);
        data.put("shops", shops);
        data.put("stories", stories);
        data.put("total", routes.size() + wanteds.size() + crews.size() + shops.size() + stories.size());
        return Result.ok(data);
    }

    /** 转义 LIKE 通配符（MySQL 默认转义符为 \） */
    private String escapeLike(String keyword) {
        return keyword.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
    }
}
