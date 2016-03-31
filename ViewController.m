//
//  ViewController.m
//  AttributedMarkupDemo
//
//  Created by Zhangziyun on 16/3/14.
//  Copyright © 2016年 Zhangziyun. All rights reserved.
//

#import "ViewController.h"
#import "NSString+AttributedMarkup.h"
#import <CoreText/CoreText.h>
#import "ClickEventLabel.h"



@interface ViewController ()
 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSDictionary* style1 = @{@"body":[UIFont fontWithName:@"HelveticaNeue" size:18.0],
                             @"bold":[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0],
                             @"red": [UIColor redColor]};
    
    
    NSDictionary* style2 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0],
                                   [UIColor darkGrayColor],
                                   ],
                             @"u": @[[UIColor blueColor],
                                     @{NSUnderlineStyleAttributeName : @(kCTUnderlineStyleSingle|kCTUnderlinePatternSolid)}
                                     ],
                             @"thumb":[UIImage imageNamed:@"thumbIcon"] };
    
    NSDictionary* style3 = @{@"body":[UIFont fontWithName:@"HelveticaNeue" size:22.0],
                             @"help":[AttributedMarkupAction styledActionWithAction:^{
                                 NSLog(@"Help action");}],
                             @"settings":@[[AttributedMarkupAction styledActionWithAction:^{
                                 NSLog(@"settings action");}],[UIColor orangeColor]],
                             @"link":[UIFont systemFontOfSize:16]
                             };

    NSString *text1 = @"Attributed <三国> <bold>字体</bold> <red>颜色</red> text";
    
    NSString *text2 = @"<thumb> </thumb> Multiple <u>styles</u> text <thumb> </thumb>";
    
    NSString *text3 = @"Tap <help>here</help> to show help or <settings>here</settings> to show settings";
    
    
    _label1.attributedText = [text1 attributedStringWithStyleBook:style1];
    _label2.attributedText = [text2 attributedStringWithStyleBook:style2];
    _label3.attributedText = [text3 attributedStringWithStyleBook:style3];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
