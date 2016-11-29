//
//  HMMessageFrame.h
//  Chatqq
//
//  Created by 胡猛 on 2016/11/29.
//  Copyright © 2016年 HuMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

// 正文的字体
#define HMTextFont [UIFont systemFontOfSize:15]

// 正文的内边距
#define HMTextPadding 20

@class HMMessage;

@interface HMMessageFrame : NSObject


/**
 *  头像的frame
 */
@property (nonatomic, assign, readonly) CGRect iconF;
/**
 *  时间的frame
 */
@property (nonatomic, assign, readonly) CGRect timeF;
/**
 *  正文的frame
 */
@property (nonatomic, assign, readonly) CGRect textF;
/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/**
 *  数据模型
 */
@property (nonatomic, strong) HMMessage *message;

@end
