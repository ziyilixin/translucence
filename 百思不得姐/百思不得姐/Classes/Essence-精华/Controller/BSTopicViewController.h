//
//  BSTopicViewController.h
//  百思不得姐
//
//  Created by WCF on 2017/8/14.
//  Copyright © 2017年 WCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTopicViewController : UITableViewController
/** 帖子类型(交给子类去实现) */
@property (nonatomic,assign) BSTopicType type;
@end
