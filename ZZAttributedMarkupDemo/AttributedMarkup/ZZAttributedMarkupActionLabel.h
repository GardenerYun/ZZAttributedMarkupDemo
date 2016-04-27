//
//  ClickLabel.h
//  AttributedMarkupDemo
//
//  Created by Zhangziyun on 16/3/15.
//  Copyright © 2016年 Zhangziyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+ZZAttributedMarkup.h"


/**
 *  存储Action block的类
 */
@interface ZZAttributedMarkupAction : NSObject

@property (nonatomic, copy) void (^actionBlock) ();

+ (NSArray *)styledActionWithAction:(void (^)())actionBlock;

@end


/**
 *  指定文本可添加点击事件的Label
 */
@interface ZZAttributedMarkupActionLabel : UILabel

@end
