//
//  HMViewController.m
//  Chatqq
//
//  Created by 胡猛 on 2016/11/29.
//  Copyright © 2016年 HuMeng. All rights reserved.
//

#import "HMViewController.h"
#import "HMMessage.h"
#import "HMMessageFrame.h"
#import "HMMessageCell.h"

@interface HMViewController ()

@property (nonatomic, strong) NSMutableArray *message;

@end

@implementation HMViewController

- (NSMutableArray *)message
{
    if (_message == nil) {
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
        
        _message = mfArray;
    }
    return _message;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.message.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    HMMessageCell *cell = [HMMessageCell cellWithTableView:tableView];
    
    // 2.给cell传递模型
    cell.messageFrame = self.message[indexPath.row];
    
    // 3.返回cell
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
