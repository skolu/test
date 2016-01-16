//
//  TryCatchFinally.m
//  Test
//
//  Created by Sergey Kolupaev on 1/5/16.
//  Copyright © 2016 Sergey Kolupaev. All rights reserved.
//

#import "TryCatchFinally.h"

@implementation TryCatchFinally

+ (void)tryBlock:(void (^)())try catchBlock:(void (^)(NSException *))catch finallyBlock:(void (^)())finally {
    @try {
        if (try != nil) {
            try();
        }
    }
    @catch (NSException *e) {
        if (catch != nil) {
            catch(e);
        }
    }
    @finally {
        if (finally != nil) {
            finally();
        }
    }
}

+ (void)tryBlock:(void (^)())try catchBlock:(void (^)(NSException *))catch {
    [TryCatchFinally tryBlock:try catchBlock:catch finallyBlock:nil];
}

+ (void)tryBlock:(void (^)())try {
    [TryCatchFinally tryBlock:try catchBlock:nil finallyBlock:nil];
}


@end