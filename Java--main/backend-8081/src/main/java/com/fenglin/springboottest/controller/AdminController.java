package com.fenglin.springboottest.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.common.AdminTokenStore;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.AdminLoginRequest;
import com.fenglin.springboottest.entity.AdminUser;
import com.fenglin.springboottest.entity.HomeCrew;
import com.fenglin.springboottest.entity.HomeRoute;
import com.fenglin.springboottest.entity.HomeShop;
import com.fenglin.springboottest.entity.HomeStory;
import com.fenglin.springboottest.entity.HomeWanted;
import com.fenglin.springboottest.exception.BizException;
import com.fenglin.springboottest.mapper.AdminUserMapper;
import com.fenglin.springboottest.mapper.HomeCrewMapper;
import com.fenglin.springboottest.mapper.HomeRouteMapper;
import com.fenglin.springboottest.mapper.HomeShopMapper;
import com.fenglin.springboottest.mapper.HomeStoryMapper;
import com.fenglin.springboottest.mapper.HomeWantedMapper;
import com.fenglin.springboottest.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 后台管理系统接口
 *
 * <p>登录接口公开，其余接口由 AdminLoginInterceptor 守卫（WebConfig 中排除 /api/admin/login）。</p>
 *
 * <ul>
 *   <li>POST   /api/admin/login                 管理员登录（仅登录，无注册）</li>
 *   <li>POST   /api/admin/logout                退出</li>
 *   <li>GET    /api/admin/stats                 数据总览</li>
 *   <li>GET    /api/admin/{模块}                 列表</li>
 *   <li>POST   /api/admin/{模块}                 新增</li>
 *   <li>PUT    /api/admin/{模块}                 修改（body 带 id）</li>
 *   <li>DELETE /api/admin/{模块}/{id}            删除</li>
 * </ul>
 * 模块名：crews（船员名册）| routes（航线图鉴）| wanteds（悬赏令）| shops（杂货小镇）| stories（篇章故事）
 */
@RestController
@RequestMapping("/api/admin")
public class AdminController {

    private static final BCryptPasswordEncoder PASSWORD_ENCODER = new BCryptPasswordEncoder();

    @Autowired
    private AdminUserMapper adminUserMapper;

    @Autowired
    private AdminTokenStore adminTokenStore;

    @Autowired
    private HomeCrewMapper homeCrewMapper;

    @Autowired
    private HomeRouteMapper homeRouteMapper;

    @Autowired
    private HomeWantedMapper homeWantedMapper;

    @Autowired
    private HomeShopMapper homeShopMapper;

    @Autowired
    private HomeStoryMapper homeStoryMapper;

    @Autowired
    private UserMapper userMapper;

    /* ==================== 登录 / 退出 ==================== */

    /** 后台登录（仅提供登录，不开放注册） */
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody AdminLoginRequest req) {
        String username = req.getUsername() == null ? "" : req.getUsername().trim();
        String password = req.getPassword() == null ? "" : req.getPassword();

        if (username.isEmpty()) {
            throw new BizException("请输入管理员账号");
        }
        if (password.isEmpty()) {
            throw new BizException("请输入管理密钥");
        }

        AdminUser admin = adminUserMapper.selectOne(
                new LambdaQueryWrapper<AdminUser>().eq(AdminUser::getUsername, username));
        if (admin == null || !PASSWORD_ENCODER.matches(password, admin.getPassword())) {
            throw new BizException("账号或密钥不正确");
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("token", adminTokenStore.issue(admin.getUsername()));
        data.put("username", admin.getUsername());
        data.put("realName", admin.getRealName());
        return Result.ok(data);
    }

    /** 退出后台 */
    @PostMapping("/logout")
    public Result<Void> logout(@RequestHeader(value = "X-Token", required = false) String token) {
        adminTokenStore.remove(token);
        return Result.ok();
    }

    /* ==================== 数据总览 ==================== */

    @GetMapping("/stats")
    public Result<Map<String, Object>> stats() {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("crewCount", homeCrewMapper.selectCount(null));
        data.put("routeCount", homeRouteMapper.selectCount(null));
        data.put("wantedCount", homeWantedMapper.selectCount(null));
        data.put("shopCount", homeShopMapper.selectCount(null));
        data.put("storyCount", homeStoryMapper.selectCount(null));
        data.put("userCount", userMapper.selectCount(null));
        return Result.ok(data);
    }

    /* ==================== 船员名册 ==================== */

    @GetMapping("/crews")
    public Result<Object> listCrews() {
        return Result.ok(homeCrewMapper.selectList(
                new LambdaQueryWrapper<HomeCrew>().orderByAsc(HomeCrew::getSortNo)));
    }

    @PostMapping("/crews")
    public Result<Object> saveCrew(@RequestBody HomeCrew entity) {
        upsertCrew(entity);
        return Result.ok(entity);
    }

    @PutMapping("/crews")
    public Result<Object> updateCrew(@RequestBody HomeCrew entity) {
        upsertCrew(entity);
        return Result.ok(entity);
    }

    @DeleteMapping("/crews/{id}")
    public Result<Object> deleteCrew(@PathVariable("id") Long id) {
        homeCrewMapper.deleteById(id);
        return Result.ok();
    }

    private void upsertCrew(HomeCrew entity) {
        if (entity.getId() != null) {
            homeCrewMapper.updateById(entity);
        } else {
            homeCrewMapper.insert(entity);
        }
    }

    /* ==================== 航线图鉴 ==================== */

    @GetMapping("/routes")
    public Result<Object> listRoutes() {
        return Result.ok(homeRouteMapper.selectList(
                new LambdaQueryWrapper<HomeRoute>().orderByAsc(HomeRoute::getSortNo)));
    }

    @PostMapping("/routes")
    public Result<Object> saveRoute(@RequestBody HomeRoute entity) {
        upsertRoute(entity);
        return Result.ok(entity);
    }

    @PutMapping("/routes")
    public Result<Object> updateRoute(@RequestBody HomeRoute entity) {
        upsertRoute(entity);
        return Result.ok(entity);
    }

    @DeleteMapping("/routes/{id}")
    public Result<Object> deleteRoute(@PathVariable("id") Long id) {
        homeRouteMapper.deleteById(id);
        return Result.ok();
    }

    private void upsertRoute(HomeRoute entity) {
        if (entity.getId() != null) {
            homeRouteMapper.updateById(entity);
        } else {
            homeRouteMapper.insert(entity);
        }
    }

    /* ==================== 悬赏令 ==================== */

    @GetMapping("/wanteds")
    public Result<Object> listWanteds() {
        return Result.ok(homeWantedMapper.selectList(
                new LambdaQueryWrapper<HomeWanted>().orderByDesc(HomeWanted::getBounty)));
    }

    @PostMapping("/wanteds")
    public Result<Object> saveWanted(@RequestBody HomeWanted entity) {
        upsertWanted(entity);
        return Result.ok(entity);
    }

    @PutMapping("/wanteds")
    public Result<Object> updateWanted(@RequestBody HomeWanted entity) {
        upsertWanted(entity);
        return Result.ok(entity);
    }

    @DeleteMapping("/wanteds/{id}")
    public Result<Object> deleteWanted(@PathVariable("id") Long id) {
        homeWantedMapper.deleteById(id);
        return Result.ok();
    }

    private void upsertWanted(HomeWanted entity) {
        if (entity.getId() != null) {
            homeWantedMapper.updateById(entity);
        } else {
            homeWantedMapper.insert(entity);
        }
    }

    /* ==================== 杂货小镇 ==================== */

    @GetMapping("/shops")
    public Result<Object> listShops() {
        return Result.ok(homeShopMapper.selectList(
                new LambdaQueryWrapper<HomeShop>().orderByAsc(HomeShop::getSortNo)));
    }

    @PostMapping("/shops")
    public Result<Object> saveShop(@RequestBody HomeShop entity) {
        upsertShop(entity);
        return Result.ok(entity);
    }

    @PutMapping("/shops")
    public Result<Object> updateShop(@RequestBody HomeShop entity) {
        upsertShop(entity);
        return Result.ok(entity);
    }

    @DeleteMapping("/shops/{id}")
    public Result<Object> deleteShop(@PathVariable("id") Long id) {
        homeShopMapper.deleteById(id);
        return Result.ok();
    }

    private void upsertShop(HomeShop entity) {
        if (entity.getId() != null) {
            homeShopMapper.updateById(entity);
        } else {
            homeShopMapper.insert(entity);
        }
    }

    /* ==================== 篇章故事 ==================== */

    @GetMapping("/stories")
    public Result<Object> listStories() {
        return Result.ok(homeStoryMapper.selectList(
                new LambdaQueryWrapper<HomeStory>().orderByAsc(HomeStory::getSortNo)));
    }

    @PostMapping("/stories")
    public Result<Object> saveStory(@RequestBody HomeStory entity) {
        upsertStory(entity);
        return Result.ok(entity);
    }

    @PutMapping("/stories")
    public Result<Object> updateStory(@RequestBody HomeStory entity) {
        upsertStory(entity);
        return Result.ok(entity);
    }

    @DeleteMapping("/stories/{id}")
    public Result<Object> deleteStory(@PathVariable("id") Long id) {
        homeStoryMapper.deleteById(id);
        return Result.ok();
    }

    private void upsertStory(HomeStory entity) {
        if (entity.getId() != null) {
            homeStoryMapper.updateById(entity);
        } else {
            homeStoryMapper.insert(entity);
        }
    }
}
