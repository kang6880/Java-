package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 杂货小镇（店铺 / 摊位）
 * 对应表：home_shop
 */
@TableName("home_shop")
public class HomeShop {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 图标 emoji */
    private String icon;

    /** 店铺名 */
    private String name;

    /** 类别：武器 / 餐饮 / 杂货 / 造船 / 玩具… */
    private String category;

    /** 所在地 */
    private String location;

    /** 招牌商品 */
    private String item;

    /** 招牌商品价格（贝利） */
    private Long price;

    /** 店铺简介 */
    private String description;

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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getItem() {
        return item;
    }

    public void setItem(String item) {
        this.item = item;
    }

    public Long getPrice() {
        return price;
    }

    public void setPrice(Long price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getSortNo() {
        return sortNo;
    }

    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
}
