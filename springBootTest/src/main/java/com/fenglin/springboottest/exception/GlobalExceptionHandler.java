package com.fenglin.springboottest.exception;

import com.fenglin.springboottest.common.Result;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常处理
 * 注意：basePackages 限定为 controller 包，避免影响原有 Thymeleaf 页面（/user/to_login）的返回行为。
 */
@RestControllerAdvice(basePackages = "com.fenglin.springboottest.controller")
public class GlobalExceptionHandler {

    private final Log log = LogFactory.getLog(GlobalExceptionHandler.class);

    /** 业务异常：直接返回提示语 */
    @ExceptionHandler(BizException.class)
    public Result<Void> handleBiz(BizException e) {
        return Result.fail(e.getCode(), e.getMessage());
    }

    /** 唯一索引冲突：兜底处理并发注册同名代号/邮箱 */
    @ExceptionHandler(DuplicateKeyException.class)
    public Result<Void> handleDuplicateKey(DuplicateKeyException e) {
        log.warn("唯一索引冲突：" + e.getMessage());
        return Result.fail("代号或邮箱已被占用，请更换后重试");
    }

    /** 其它未预期异常 */
    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e) {
        log.error("接口异常", e);
        return Result.fail(500, "服务器开小差了：" + e.getMessage());
    }
}
