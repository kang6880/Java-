package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.HomeShop;
import org.apache.ibatis.annotations.Mapper;

/**
 * 杂货小镇 Mapper
 */
@Mapper
public interface HomeShopMapper extends BaseMapper<HomeShop> {
}
