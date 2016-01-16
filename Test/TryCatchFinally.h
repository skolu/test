//
//  TryCatchFinally.h
//  Test
//
//  Created by Sergey Kolupaev on 1/5/16.
//  Copyright © 2016 Sergey Kolupaev. All rights reserved.
//
// https://medium.com/swift-programming/adding-try-catch-to-swift-71ab27bcb5b8

#import <Foundation/Foundation.h>


@interface TryCatchFinally : NSObject

+ (void)tryBlock:(void (^)())try ;
+ (void)tryBlock:(void (^)())try catchBlock:(void (^)(NSException *))catch ;
+ (void)tryBlock:(void (^)())try catchBlock:(void (^)(NSException *))catch finallyBlock:(void (^)())finally;

@end

