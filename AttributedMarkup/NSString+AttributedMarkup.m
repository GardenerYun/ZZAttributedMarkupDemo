//
//  NSString+AttributedMarkup.m
//  AttributedMarkupDemo
//
//  Created by Zhangziyun on 16/3/15.
//  Copyright © 2016年 Zhangziyun. All rights reserved.
//

#import "NSString+AttributedMarkup.h"



NSString* kWPAttributedMarkupLinkName = @"WPAttributedMarkupLinkName";

@implementation NSString (AttributedMarkup)

- (NSMutableString *)arrangeAllTagsWithArray:(NSMutableArray *)tagsArray {
    
    NSMutableString* mutableString = [self mutableCopy];
    
    NSArray *characterArray = @[@"œ",@"∑",@"®",@"†",@"¥",@"ø",@"π",@"å",@"ß",@"ƒ",@"©",@"¬",@"Ω",@"≈",@"√",@"∫",@"µ"];
    NSMutableArray *markArray = [NSMutableArray array];
    
    BOOL isFinish = NO;
    
    while (isFinish == NO) {
        
        // 起始标签的 <
        NSRange openTagLeftRange = [mutableString rangeOfString:@"<"];
        
        if (openTagLeftRange.length == 0) {
            isFinish = YES;
            break;
        }
        
        // 起始标签的 >
        NSRange openTagRightRange = [mutableString rangeOfString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(openTagLeftRange.location+openTagLeftRange.length, mutableString.length - (openTagLeftRange.location+openTagLeftRange.length))];
        if (openTagRightRange.length == 0) {
            isFinish = YES;
            break;
        }
        
        // 起始标签
        NSRange openTagStringRange = NSMakeRange(openTagLeftRange.location, openTagRightRange.location-openTagLeftRange.location+1);
        
        // 结束标签的 </
        NSRange closeTagLeftRange = [mutableString rangeOfString:@"</"];
        if (closeTagLeftRange.length == 0) {
            isFinish = YES;
            break;
        }
        
        // 结束标签的 >
        NSRange closeTagRightRange = NSMakeRange(closeTagLeftRange.location+openTagStringRange.length, 1);
        
        // 结束标签
        NSRange closeTagStringRange = NSMakeRange(closeTagLeftRange.location, closeTagRightRange.location-closeTagLeftRange.location+1);
        
        NSString* openTagString = [mutableString substringWithRange:openTagStringRange];
        
        NSString *closeTagString = @"</>";
        
        
        if (closeTagStringRange.length + closeTagStringRange.location <= mutableString.length) {
            closeTagString = [mutableString substringWithRange:closeTagStringRange];
        }
        
        
        
        // 如果’起始标签名‘ = ’结束标签名‘ 符合<标签名>内容</标签名>格式，避免某些情况<三国演义> </水浒传>
        if ([[openTagString substringWithRange:NSMakeRange(1, openTagString.length-2)] isEqualToString:[closeTagString substringWithRange:NSMakeRange(2, closeTagString.length-3)]] && [openTagString isEqualToString:[closeTagString stringByReplacingOccurrencesOfString:@"</" withString:@"<"]]) {
            
            
            [mutableString replaceCharactersInRange:closeTagStringRange withString:@""];
            [mutableString replaceCharactersInRange:openTagStringRange withString:@""];
            
            NSString *tagName = [openTagString substringWithRange:NSMakeRange(1, openTagString.length-2)];
            
            NSInteger location = openTagStringRange.location;
            NSInteger length = closeTagStringRange.location - openTagStringRange.length - location;
            NSRange tagRange = NSMakeRange(location, length);
            
            NSDictionary *tagDic = @{
                                     @"tagName" : tagName,
                                     @"tagRange": NSStringFromRange(tagRange)
                                     };
            [tagsArray addObject:tagDic];
            
        } else {
            NSMutableString *markString = [[NSMutableString alloc] initWithString:@""];
            if (markArray.count<10) {
                [markString appendString:@"0"];
                [markString appendString:[NSString stringWithFormat:@"%lu",(unsigned long)markArray.count]];
                for (int i=0; i<openTagString.length-2; i++) {
                    [markString appendString:characterArray[i%characterArray.count]];
                }
            } else {
                [markString appendString:[NSString stringWithFormat:@"%lu",(unsigned long)markArray.count]];
                for (int i=0; i<openTagString.length-2; i++) {
                    [markString appendString:characterArray[i%characterArray.count]];
                }
            }
            NSDictionary *markDic = @{
                                      @"realString" : openTagString,
                                      @"markRange"  : NSStringFromRange(openTagStringRange)
                                      };
            [markArray addObject:markDic];
            [mutableString replaceCharactersInRange:openTagStringRange withString:markString];
        }
        
    }
    
    
    for (NSDictionary *markDic in markArray) {
        [mutableString replaceCharactersInRange:NSRangeFromString(markDic[@"markRange"]) withString:markDic[@"realString"]];
    }
    
    
    return mutableString;
}


-(NSAttributedString*)attributedStringWithStyleBook:(NSDictionary*)styleBook
{
    // Find string ranges
    NSMutableArray* tags = [[NSMutableArray alloc] initWithCapacity:16];
    
    NSMutableString *ms = [self arrangeAllTagsWithArray:tags];
    
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:ms];
    
    // Setup base attributes
    [as setAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone]} range:NSMakeRange(0,[as length])];
    
    
    NSObject* bodyStyle = styleBook[@"body"];
    if (bodyStyle) {
        [self styleAttributedString:as range:NSMakeRange(0, as.length) withStyle:bodyStyle withStyleBook:styleBook];
    }
    
    for (NSDictionary* tag in tags) {
        NSString* tagName = tag[@"tagName"];
        NSRange range = NSRangeFromString(tag[@"tagRange"]);
        if (range.length != 0) {
            NSObject* style = styleBook[tagName];
            if (style) {
                [self styleAttributedString:as range:range withStyle:style withStyleBook:styleBook];
            }
        }
    }
    
    return as;
}

-(void)styleAttributedString:(NSMutableAttributedString*)as range:(NSRange)range withStyle:(NSObject*)style withStyleBook:(NSDictionary*)styleBook
{
    if ([style isKindOfClass:[NSArray class]]) {
        for (NSObject* subStyle in (NSArray*)style) {
            [self styleAttributedString:as range:range withStyle:subStyle withStyleBook:styleBook];
        }
    }
    else if ([style isKindOfClass:[NSDictionary class]]) {
        [self setStyle:(NSDictionary*)style range:range onAttributedString:as];
    }
    else if ([style isKindOfClass:[UIFont class]]) {
        [self setFont:(UIFont*)style range:range onAttributedString:as];
    }
    else if ([style isKindOfClass:[UIColor class]]) {
        [self setTextColor:(UIColor*)style range:range onAttributedString:as];
    } else if ([style isKindOfClass:[NSURL class]]) {
        [self setLink:(NSURL*)style range:range onAttributedString:as];
    } else if ([style isKindOfClass:[NSString class]]) {
        [self styleAttributedString:as range:range withStyle:styleBook[(NSString*)style] withStyleBook:styleBook];
    } else if ([style isKindOfClass:[UIImage class]]) {
        NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
        attachment.image = (UIImage*)style;
        [as replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    }
}


-(void)setStyle:(NSDictionary*)style range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    for (NSString* key in [style allKeys]) {
        [self setTextStyle:key withValue:style[key] range:range onAttributedString:as];
    }
}

-(void)setFont:(UIFont*)font range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    [self setFontName:font.fontName size:font.pointSize range:range onAttributedString:as];
}


-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    // kCTFontAttributeName
    CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)fontName, size, NULL);
    if (aFont)
    {
        [as removeAttribute:(__bridge NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
        [as addAttribute:(__bridge NSString*)kCTFontAttributeName value:(__bridge id)aFont range:range];
        CFRelease(aFont);
    }
}

-(void)setTextColor:(UIColor*)color range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    // kCTForegroundColorAttributeName
    [as removeAttribute:NSForegroundColorAttributeName range:range];
    [as addAttribute:NSForegroundColorAttributeName value:color range:range];
}

-(void)setTextStyle:(NSString*)styleName withValue:(NSObject*)value range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    [as removeAttribute:styleName range:range]; // Work around for Apple leak
    [as addAttribute:styleName value:value range:range];
}

-(void)setLink:(NSURL*)url range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    [as removeAttribute:kWPAttributedMarkupLinkName range:range]; // Work around for Apple leak
    if (&link)
    {
        [as addAttribute:kWPAttributedMarkupLinkName value:[url absoluteString] range:range];
    }
}


@end
