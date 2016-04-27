//
//  ClickLabel.m
//  AttributedMarkupDemo
//
//  Created by Zhangziyun on 16/3/15.
//  Copyright © 2016年 Zhangziyun. All rights reserved.
//

#import "ZZAttributedMarkupActionLabel.h"



#pragma mark -- 存储block的类 --

@implementation ZZAttributedMarkupAction

+ (NSArray *)styledActionWithAction:(void (^)())actionBlock {

    ZZAttributedMarkupAction *aciton = [[ZZAttributedMarkupAction alloc] init];
    aciton.actionBlock = actionBlock;
    
    return @[@{NSStringFromClass([ZZAttributedMarkupAction class]):aciton},@"link"];
}

@end

#pragma mark -- 指定文本可添加点击事件的Label --

@implementation ZZAttributedMarkupActionLabel

- (void)setAttributedText:(NSAttributedString *)attributedText {

    [super setAttributedText:attributedText];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClickEvent:)];
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
}


- (void)labelClickEvent:(UITapGestureRecognizer*)gesture {

    if (gesture.state == UIGestureRecognizerStateRecognized) {
        CGPoint point = [gesture locationInView:self];
        // Locate the text attributes at the touched position
        NSDictionary* attributes = [self textAttributesAtPoint:point];
        // If the touched attributes contains our custom action style, execute the action block
        ZZAttributedMarkupAction* action = attributes[NSStringFromClass([ZZAttributedMarkupAction class])];
        if (action) {
            action.actionBlock();
        }
    }
}

/**
 *  根据点击的point计算出所点击文本，然后获取文本的attributes属性
 */
-(NSDictionary*)textAttributesAtPoint:(CGPoint)point
{
    // Locate the attributes of the text within the label at the specified point
    // 在指点point的Label中，定位这个attributes的文本
    NSDictionary* dictionary = nil;
    
    // First, create a CoreText framesetter
    // 首先,创建一个 CoreText framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    // Get the frame that will do the rendering.
    // 获取将做渲染的frame
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get each of the typeset lines
    // 获取每个排版线
    NSArray *lines = (__bridge id)CTFrameGetLines(frameRef);
    
    CFIndex linesCount = [lines count];
    CGPoint *lineOrigins = (CGPoint *) malloc(sizeof(CGPoint) * linesCount);
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, linesCount), lineOrigins);
    
    CTLineRef line = NULL;
    CGPoint lineOrigin = CGPointZero;
    
    // Correct each of the typeset lines (which have origin (0,0)) to the correct orientation (typesetting offsets from the bottom of the frame)
    // 正确每一排版线（具有原点（0,0）），以正确的方向的（排版偏移从帧的底部）
    CGFloat bottom = self.frame.size.height;
    for(CFIndex i = 0; i < linesCount; ++i) {
        lineOrigins[i].y = self.frame.size.height - lineOrigins[i].y;
        bottom = lineOrigins[i].y;
    }
    
    // Offset the touch point by the amount of space between the top of the label frame and the text
    // 通过的空间量偏移标签框架的顶部和文字之间的接触点
    point.y -= (self.frame.size.height - bottom)/2;
    
    
    // Scan through each line to find the line containing the touch point y position
    for(CFIndex i = 0; i < linesCount; ++i) {
        line = (__bridge CTLineRef)[lines objectAtIndex:i];
        lineOrigin = lineOrigins[i];
        CGFloat descent, ascent;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, nil);
        
        if(point.y < (floor(lineOrigin.y) + floor(descent))) {
            
            // Cater for text alignment set in the label itself (not in the attributed string)
            // 迎合了标签本身（而不是在attributedstring）设置文本对齐方式
            if (self.textAlignment == NSTextAlignmentCenter) {
                point.x -= (self.frame.size.width - width)/2;
            } else if (self.textAlignment == NSTextAlignmentRight) {
                point.x -= (self.frame.size.width - width);
            }
            
            // Offset the touch position by the actual typeset line origin. pt is now the correct touch position with the line bounds
            // 偏移的实际排版行原点的触摸位置。 PT现已与边界线的正确触摸位置
            point.x -= lineOrigin.x;
            point.y -= lineOrigin.y;
            
            // Find the text index within this line for the touch position
            CFIndex i = CTLineGetStringIndexForPosition(line, point);
            
            // Iterate through each of the glyph runs to find the run containing the character index
            NSArray* glyphRuns = (__bridge id)CTLineGetGlyphRuns(line);
            CFIndex runCount = [glyphRuns count];
            for (CFIndex run=0; run<runCount; run++) {
                CTRunRef glyphRun = (__bridge CTRunRef)[glyphRuns objectAtIndex:run];
                CFRange range = CTRunGetStringRange(glyphRun);
                if (i >= range.location && i<= range.location+range.length) {
                    dictionary = (__bridge NSDictionary*)CTRunGetAttributes(glyphRun);
                    break;
                }
            }
            if (dictionary) {
                break;
            }
        }
    }
    
    free(lineOrigins);
    CFRelease(frameRef);
    CFRelease(framesetter);
    
    
    return dictionary;
}


@end
