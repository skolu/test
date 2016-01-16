//
//  ViewController.h
//  Test
//
//  Created by Sergey Kolupaev on 10/30/15.
//  Copyright © 2015 Sergey Kolupaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITextField *field;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)click:(id)sender;

@end

