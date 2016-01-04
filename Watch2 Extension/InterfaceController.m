//
//  InterfaceController.m
//  Watch2 Extension
//
//  Created by Sergey Kolupaev on 10/30/15.
//  Copyright © 2015 Sergey Kolupaev. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController() {
    int rr;
}

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    [super willActivate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        for (int i = 0; i < 10; i++) {
            rr=i;
        }
    });
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



