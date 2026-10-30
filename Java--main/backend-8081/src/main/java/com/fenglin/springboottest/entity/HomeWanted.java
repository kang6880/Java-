package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 悬赏令（首页展示与搜索用）
 * 对应表：home_wanted
 */
@TableName("home_wanted")
public class HomeWanted {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 卡片小图标（emoji） */
    private String icon;

    /** 海贼名 */
    private String name;

    /** 称号，如「草帽小子」 */
    private String epithet;

    /** 所属海贼团 */
    private String crew;

    /** 悬赏金额（贝利） */
    private Long bounty;

    /** 悬赏理由 / 罪行描述 */
    private String description;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEpithet() {
        return epithet;
    }

    public void setEpithet(String epithet) {
        this.epithet = epithet;
    }

    public String getCrew() {
        return crew;
    }

    public void setCrew(String crew) {
        this.crew = crew;
    }

    public Long getBounty() {
        return bounty;
    }

    public void setBounty(Long bounty) {
        this.bounty = bounty;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
