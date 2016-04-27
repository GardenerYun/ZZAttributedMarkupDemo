//
//  ViewController.m
//  AttributedMarkupDemo
//
//  Created by Zhangziyun on 16/3/14.
//  Copyright © 2016年 Zhangziyun. All rights reserved.
//

#import "ViewController.h"
#import "NSString+ZZAttributedMarkup.h"
#import "ZZAttributedMarkupActionLabel.h"



@interface ViewController ()
 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSDictionary* style1 = @{
                             @"body":@[[UIFont systemFontOfSize:18],[UIColor grayColor]],
                             @"bold":[UIFont boldSystemFontOfSize:24],
                             @"red": [UIColor redColor]
                             };
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(2, 2);
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowBlurRadius = 3;
    
    NSDictionary* style2 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0],
                                   [UIColor darkGrayColor],
                                   ],
                             @"u": @[[UIColor blueColor],
                                     @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle|NSUnderlinePatternSolid)}
                                     ],
                             @"u2" : @[[UIColor yellowColor],
                                       @{NSBackgroundColorAttributeName : [UIColor grayColor]}],
                             @"u3" : @[[UIColor orangeColor],
                                       @{NSShadowAttributeName : shadow}],
                             @"thumb":[UIImage imageNamed:@"thumbIcon"] ,
                             @"expression" : [UIImage imageNamed:@"Expression"]
                             };
    
    NSDictionary* style3 = @{@"body":[UIFont fontWithName:@"HelveticaNeue" size:18.0],
                             @"help":[ZZAttributedMarkupAction styledActionWithAction:^{
                                        NSLog(@"点击了帮助文本");
                                 [[[UIAlertView alloc] initWithTitle:@"弹框：帮助" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                                        }],
                             @"settings":@[[ZZAttributedMarkupAction styledActionWithAction:^{
                                        NSLog(@"点击了设置文本");
                                 [[[UIAlertView alloc] initWithTitle:@"弹框：设置" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                                    }],[UIColor orangeColor]],
                             @"link":@[[UIFont systemFontOfSize:20],
                                       @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle|NSUnderlinePatternSolid)}
                                       ],
                             };

    NSString *text1 = @"一段普通 <bold>字体</bold> <red>颜色</red> 富文本";
    
    NSString *text2 = @"<thumb> </thumb><expression> </expression>不同表情<expression> </expression><thumb> </thumb> <u>多</u><u2>样式</u2><u3>文本</u3>";
    
    NSString *text3 = @"点击 <help>帮助</help> 显示帮助弹框\n\n或者 <settings>设置</settings> 显示设置弹框";
    
    _label1.attributedText = [text1 attributedStringWithStyleBook:style1];
    
    _label2.attributedText = [text2 attributedStringWithStyleBook:style2];
    
    _label3.attributedText = [text3 attributedStringWithStyleBook:style3];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
