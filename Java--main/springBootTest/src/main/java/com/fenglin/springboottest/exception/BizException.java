package com.fenglin.springboottest.exception;

/**
 * 业务异常
 * 用于表达「参数不合法 / 代号已占用」这类可预期的失败，
 * 由 GlobalExceptionHandler 统一转成 Result 返回给前端。
 */
public class BizException extends RuntimeException {

    private final int code;

    public BizException(String msg) {
        this(400, msg);
    }

    public BizException(int code, String msg) {
        super(msg);
        this.code = code;
    }

    public int getCode() {
        return code;
    }
}
