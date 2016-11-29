//
//  HMMessageCell.h
//  Chatqq
//
//  Created by 胡猛 on 2016/11/29.
//  Copyright © 2016年 HuMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMMessageFrame;

@interface HMMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) HMMessageFrame *messageFrame;

@end
