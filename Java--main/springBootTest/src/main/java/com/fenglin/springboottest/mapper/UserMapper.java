package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.User;
import org.apache.ibatis.annotations.Mapper;

/**
 * 船员名册 Mapper
 * 继承 BaseMapper 后即拥有单表增删改查能力，无需再写 XML
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {
}
