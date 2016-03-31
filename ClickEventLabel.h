//
//  ClickLabel.h
//  AttributedMarkupDemo
//
//  Created by Zhangziyun on 16/3/15.
//  Copyright © 2016年 Zhangziyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+AttributedMarkup.h"


/**
 *  存储block的类
 */
@interface AttributedMarkupAction : NSObject

@property (nonatomic, copy) void (^actionBlock) ();

+ (NSDictionary *)styledActionWithAction:(void (^)())actionBlock;

@end


/**
 *  指定文本可添加点击事件的Label
 */
@interface ClickEventLabel : UILabel

@end
