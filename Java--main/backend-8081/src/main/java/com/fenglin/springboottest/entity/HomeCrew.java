package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 船员名册（人物档案）
 * 对应表：home_crew
 */
@TableName("home_crew")
public class HomeCrew {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 图标 emoji */
    private String icon;

    /** 角色名 */
    private String name;

    /** 外号 / 称号 */
    private String alias;

    /** 船上职位或身份 */
    private String position;

    /** 所属势力 */
    private String affiliation;

    /** 出身地 */
    private String origin;

    /** 恶魔果实 */
    private String devilFruit;

    /** 动漫形象图 URL */
    private String image;

    /** 悬赏金（贝利） */
    private Long bounty;

    /** 人物简介 */
    private String description;

    /** 主要事迹 */
    private String deeds;

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

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getAffiliation() {
        return affiliation;
    }

    public void setAffiliation(String affiliation) {
        this.affiliation = affiliation;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getDevilFruit() {
        return devilFruit;
    }

    public void setDevilFruit(String devilFruit) {
        this.devilFruit = devilFruit;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
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

    public String getDeeds() {
        return deeds;
    }

    public void setDeeds(String deeds) {
        this.deeds = deeds;
    }

    public Integer getSortNo() {
        return sortNo;
    }

    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
}
