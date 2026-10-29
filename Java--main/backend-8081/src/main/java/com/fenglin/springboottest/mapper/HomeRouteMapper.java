package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.HomeRoute;
import org.apache.ibatis.annotations.Mapper;

/**
 * 航线 Mapper
 */
@Mapper
public interface HomeRouteMapper extends BaseMapper<HomeRoute> {
}
