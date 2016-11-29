//
//  HMMessageFrame.m
//  Chatqq
//
//  Created by 胡猛 on 2016/11/29.
//  Copyright © 2016年 HuMeng. All rights reserved.
//

#import "HMMessageFrame.h"
#import "HMMessage.h"

@implementation HMMessageFrame

- (void)setMessage:(HMMessage *)message
{
    _message = message;
    // 间距
    CGFloat padding = 10;
    // 屏幕的宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1.时间
    if (message.hideTime == NO) { // 显示时间
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = screenW;
        CGFloat timeH = 40;
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    // 2.头像
    CGFloat iconY = CGRectGetMaxY(_timeF) + padding;
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconX;
    if (message.type == HMMessageTypeOther) {// 别人发的
        iconX = padding;
    } else { // 自己的发的
        iconX = screenW - padding - iconW;
    }
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 3.正文
    CGFloat textY = iconY;
    // 文字计算的最大尺寸
    CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
    // 文字计算出来的真实尺寸(按钮内部label的尺寸)
    CGSize textRealSize = [message.text sizeWithFont:HMTextFont maxSize:textMaxSize];
    // 按钮最终的真实尺寸
    CGSize textBtnSize = CGSizeMake(textRealSize.width + HMTextPadding * 2, textRealSize.height + HMTextPadding * 2);
    CGFloat textX;
    if (message.type == HMMessageTypeOther) {// 别人发的
        textX = CGRectGetMaxX(_iconF) + padding;
    } else {// 自己的发的
        textX = iconX - padding - textBtnSize.width;
    }
    //    _textF = CGRectMake(textX, textY, textSize.width + 40, textSize.height + 40);
    _textF = (CGRect){{textX, textY}, textBtnSize};
    
    // 4.cell的高度
    CGFloat textMaxY = CGRectGetMaxY(_textF);
    CGFloat iconMaxY = CGRectGetMaxY(_iconF);
    _cellHeight = MAX(textMaxY, iconMaxY) + padding;
}


@end
