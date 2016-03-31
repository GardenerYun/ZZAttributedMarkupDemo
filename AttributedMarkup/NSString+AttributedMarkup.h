//
//  NSString+AttributedMarkup.h
//  AttributedMarkupDemo
//
//  Created by Zhangziyun on 16/3/15.
//  Copyright © 2016年 Zhangziyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSString (AttributedMarkup)

- (NSAttributedString *)attributedStringWithStyleBook:(NSDictionary *)styleBook;


@end
