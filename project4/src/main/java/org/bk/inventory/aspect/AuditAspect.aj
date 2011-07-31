package org.bk.inventory.aspect;

import org.bk.inventory.types.Inventory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public aspect AuditAspect {
    private static Logger logger = LoggerFactory.getLogger(AuditAspect.class);

    pointcut serviceMethods() : execution(* org.bk.inventory.service.*.*(..));

    pointcut serviceMethodsWithInventoryAsParam(Inventory inventory) : execution(* org.bk.inventory.service.*.*(Inventory)) && args(inventory);

    before() : serviceMethods() {
        logger.info("before method");
    }

    Object around() : serviceMethods() {
        long start = System.nanoTime();
        Object result = proceed();
        long end = System.nanoTime();
        logger.info(String.format("%s took %d ns", thisJoinPointStaticPart.getSignature(),
                (end - start)));
        return result;
    }

    Object around(Inventory inventory) : serviceMethodsWithInventoryAsParam(inventory) {
        Object result = proceed(inventory);
        logger.info(String.format("WITH PARAM: %s", inventory.toString()));
        return result;
    }
    after() : serviceMethods() {
        logger.info("after method");
    }
}
