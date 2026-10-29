package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 篇章故事（动画 / 漫画章节）
 * 对应表：home_story
 */
@TableName("home_story")
public class HomeStory {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 图标 emoji */
    private String icon;

    /** 篇章名 */
    private String title;

    /** 发生地 / 海域 */
    private String sea;

    /** 漫画章节区间，如「漫画 1-61 话」 */
    private String chapters;

    /** 动画集数区间，如「动画 1-45 集」 */
    private String episodes;

    /** 主要登场人物 */
    private String mainRoles;

    /** 剧情概要 */
    private String summary;

    /** 展示排序 */
    private Integer sortNo;

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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSea() {
        return sea;
    }

    public void setSea(String sea) {
        this.sea = sea;
    }

    public String getChapters() {
        return chapters;
    }

    public void setChapters(String chapters) {
        this.chapters = chapters;
    }

    public String getEpisodes() {
        return episodes;
    }

    public void setEpisodes(String episodes) {
        this.episodes = episodes;
    }

    public String getMainRoles() {
        return mainRoles;
    }

    public void setMainRoles(String mainRoles) {
        this.mainRoles = mainRoles;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public Integer getSortNo() {
        return sortNo;
    }

    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
}
