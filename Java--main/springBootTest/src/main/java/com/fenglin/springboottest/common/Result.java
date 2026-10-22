package com.fenglin.springboottest.common;

/**
 * 统一返回结果
 * 约定：code=200 成功；code=400 参数或业务错误；code=500 服务器异常
 *
 * @param <T> 业务数据类型
 */
public class Result<T> {

    /** 状态码 */
    private int code;
    /** 提示信息 */
    private String msg;
    /** 业务数据 */
    private T data;

    public Result() {
    }

    public Result(int code, String msg, T data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    /** 成功（无数据） */
    public static <T> Result<T> ok() {
        return new Result<>(200, "success", null);
    }

    /** 成功（带数据） */
    public static <T> Result<T> ok(T data) {
        return new Result<>(200, "success", data);
    }

    /** 失败，默认 400 */
    public static <T> Result<T> fail(String msg) {
        return new Result<>(400, msg, null);
    }

    /** 失败，自定义状态码 */
    public static <T> Result<T> fail(int code, String msg) {
        return new Result<>(code, msg, null);
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
