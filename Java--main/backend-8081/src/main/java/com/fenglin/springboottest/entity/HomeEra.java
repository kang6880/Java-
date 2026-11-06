package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 航海王全史时间线（时代）
 * 对应表：home_era
 */
@TableName("home_era")
public class HomeEra {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 时代年份，如「海圆历 1490 年前后」 */
    private String year;

    /** 时代标题 */
    private String title;

    /** 图标 emoji */
    private String icon;

    /** 主题色（十六进制） */
    private String color;

    /** 时代描述 */
    private String description;

    /** 要点列表（JSON 数组字符串，如 ["a","b"]） */
    private String points;

    /** 展示排序 */
    private Integer sortNo;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPoints() {
        return points;
    }

    public void setPoints(String points) {
        this.points = points;
    }

    public Integer getSortNo() {
        return sortNo;
    }

    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
}
