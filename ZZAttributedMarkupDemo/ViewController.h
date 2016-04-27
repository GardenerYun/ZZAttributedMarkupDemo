//
//  ViewController.h
//  AttributedMarkupDemo
//
//  Created by Zhangziyun on 16/3/14.
//  Copyright © 2016年 Zhangziyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZAttributedMarkupActionLabel.h"

@interface ViewController : UIViewController {

    __weak IBOutlet UILabel *_label1;
    
    __weak IBOutlet UILabel *_label2;

    __weak IBOutlet ZZAttributedMarkupActionLabel *_label3;
}


@end

