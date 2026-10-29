package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.HomeCrew;
import org.apache.ibatis.annotations.Mapper;

/**
 * 船员名册 Mapper
 */
@Mapper
public interface HomeCrewMapper extends BaseMapper<HomeCrew> {
}
