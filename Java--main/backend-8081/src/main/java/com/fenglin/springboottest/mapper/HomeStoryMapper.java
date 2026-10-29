package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.HomeStory;
import org.apache.ibatis.annotations.Mapper;

/**
 * 篇章故事 Mapper
 */
@Mapper
public interface HomeStoryMapper extends BaseMapper<HomeStory> {
}
