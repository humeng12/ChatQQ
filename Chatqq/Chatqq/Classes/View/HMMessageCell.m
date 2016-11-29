//
//  HMMessageCell.m
//  Chatqq
//
//  Created by 胡猛 on 2016/11/29.
//  Copyright © 2016年 HuMeng. All rights reserved.
//

#import "HMMessageCell.h"
#import "HMMessageFrame.h"
#import "HMMessage.h"

@interface HMMessageCell ()

/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeView;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  正文
 */
@property (nonatomic, weak) UIButton *textView;

@end

@implementation HMMessageCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"message";
    HMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HMMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // 1.时间
        UILabel *timeView = [[UILabel alloc] init];
        timeView.textAlignment = NSTextAlignmentCenter;
        timeView.textColor = [UIColor grayColor];
        timeView.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:timeView];
        self.timeView = timeView;
        
        
        // 2.头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        
        // 3.正文
        UIButton *textView = [[UIButton alloc] init];
        textView.titleLabel.numberOfLines = 0; // 自动换行
        textView.titleLabel.font = HMTextFont;
        textView.contentEdgeInsets = UIEdgeInsetsMake(HMTextPadding, HMTextPadding, HMTextPadding, HMTextPadding);
        [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:textView];
        self.textView = textView;
        
        // 4.设置cell的背景色
        self.backgroundColor = [UIColor clearColor];
    }
    
    
    return self;
}


- (void)setMessageFrame:(HMMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    
    HMMessage *message = messageFrame.message;
    
    // 1.时间
    self.timeView.text = message.time;
    self.timeView.frame = messageFrame.timeF;
    
    // 2.头像
    NSString *icon = (message.type == HMMessageTypeMe) ? @"me" : @"other";
    self.iconView.image = [UIImage imageNamed:icon];
    self.iconView.frame = messageFrame.iconF;
    
    // 3.正文
    [self.textView setTitle:message.text forState:UIControlStateNormal];
    self.textView.frame = messageFrame.textF;
    
    // 4.正文的背景
    if (message.type == HMMessageTypeMe) { // 自己发的,蓝色
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_send_nor"] forState:UIControlStateNormal];
    } else { // 别人发的,白色
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_recive_nor"] forState:UIControlStateNormal];
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
