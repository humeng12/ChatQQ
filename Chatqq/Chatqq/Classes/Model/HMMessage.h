//
//  HMMessage.h
//  Chatqq
//
//  Created by 胡猛 on 2016/11/29.
//  Copyright © 2016年 HuMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HMMessageTypeMe = 0, // 自己发的
    HMMessageTypeOther   // 别人发的
} HMMessageType;


@interface HMMessage : NSObject

/**
 *  聊天内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  发送时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  信息的类型
 */
@property (nonatomic, assign) HMMessageType type;

/**
 *  是否隐藏时间
 */
@property (nonatomic, assign) BOOL hideTime;

+ (instancetype)messageWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
