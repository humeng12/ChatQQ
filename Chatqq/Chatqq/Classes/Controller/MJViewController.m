//
//  MJViewController.m
//  01-QQ聊天布局
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"
#import "HMMessage.h"
#import "HMMessageFrame.h"
#import "HMMessageCell.h"

@interface MJViewController () <UITableViewDataSource, UITableViewDelegate, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;
@property (nonatomic, strong) NSMutableArray *messageFrames;

@property (weak, nonatomic) IBOutlet UITextField *inputView;
@property (weak, nonatomic) IBOutlet UITextField *MyInputView;

@property (nonatomic, strong) NSDictionary *autoreply;
@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.表格的设置
    // 去除分割线
    self.MyTableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.MyTableView.allowsSelection = NO; // 不允许选中
    self.MyTableView.delegate = self;
    
    // 2.监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 3.设置文本框左边显示的view
    self.MyInputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    // 永远显示
    self.MyInputView.leftViewMode = UITextFieldViewModeAlways;
    self.MyInputView.delegate = self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  发送一条消息
 */
- (void)addMessage:(NSString *)text type:(HMMessageType)type
{
    // 1.数据模型
    HMMessage *msg = [[HMMessage alloc] init];
    msg.type = type;
    msg.text = text;
    // 设置数据模型的时间
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    // NSDate  --->  NSString
    // NSString ---> NSDate
    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //  2014-08-09 15:45:56
    // 09/08/2014  15:45:56
    msg.time = [fmt stringFromDate:now];
    
    // 看是否需要隐藏时间
    HMMessageFrame *lastMf = [self.messageFrames lastObject];
    HMMessage *lastMsg = lastMf.message;
    msg.hideTime = [msg.time isEqualToString:lastMsg.time];
    
    // 2.frame模型
    HMMessageFrame *mf = [[HMMessageFrame alloc] init];
    mf.message = msg;
    [self.messageFrames addObject:mf];
    
    // 3.刷新表格
    [self.MyTableView reloadData];
    
    // 4.自动滚动表格到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.MyTableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/**
 *  根据自己发的内容取得自动回复的内容
 *
 *  @param text 自己发的内容
 */
- (NSString *)replayWithText:(NSString *)text
{
    for (int i = 0; i<text.length; i++) {
        NSString *word = [text substringWithRange:NSMakeRange(i, 1)];
        
        if (self.autoreply[word]) return self.autoreply[word];
    }
    
    return @"滚蛋";
}

#pragma mark - 文本框代理
/**
 *  点击了return按钮(键盘最右下角的按钮)就会调用
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 1.自己发一条消息
    [self addMessage:textField.text type:HMMessageTypeMe];
    
    // 2.自动回复一条消息
    NSString *reply = [self replayWithText:textField.text];
    [self addMessage:reply type:HMMessageTypeOther];
    
    // 3.清空文字
    self.MyInputView.text = nil;
    
    // 返回YES即可
    return YES;
}

/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.MyTableView.backgroundColor;
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

/*
 UIKeyboardAnimationCurveUserInfoKey = 7;  // 动画的执行节奏(速度)
 UIKeyboardAnimationDurationUserInfoKey = "0.25"; // 键盘弹出\隐藏动画所需要的时间
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 216}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 588}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 372}";
 UIKeyboardFrameChangedByUserInteraction = 0;
 
 // 键盘弹出
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 480}, {320, 216}}";// 键盘刚出来那一刻的frame
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 264}, {320, 216}}"; //  键盘显示完毕后的frame
 
 // 键盘隐藏
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 264}, {320, 216}}";
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 480}, {320, 216}}";
 */

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSDictionary *)autoreply
{
    if (_autoreply == nil) {
        _autoreply = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"autoreply.plist" ofType:nil]];
    }
    return _autoreply;
}

- (NSMutableArray *)messageFrames
{
    if (_messageFrames == nil) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil]];
        
        NSMutableArray *mfArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray) {
            // 消息模型
            HMMessage *msg = [HMMessage messageWithDict:dict];
            
            // 取出上一个模型
            HMMessageFrame *lastMf = [mfArray lastObject];
            HMMessage *lastMsg = lastMf.message;
            
            // 判断两个消息的时间是否一致
            msg.hideTime = [msg.time isEqualToString:lastMsg.time];
            
            // frame模型
            HMMessageFrame *mf = [[HMMessageFrame alloc] init];
            mf.message = msg;
            
            // 添加模型
            [mfArray addObject:mf];
        }
        
        _messageFrames = mfArray;
    }
    return _messageFrames;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    HMMessageCell *cell = [HMMessageCell cellWithTableView:tableView];
    
    // 2.给cell传递模型
    cell.messageFrame = self.messageFrames[indexPath.row];
    
    // 3.返回cell
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMMessageFrame *mf = self.messageFrames[indexPath.row];
    return mf.cellHeight;
}

/**
 *  当开始拖拽表格的时候就会调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 退出键盘
    [self.view endEditing:YES];
}
@end
