//
//  ZDDMenuCommentListController.m
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuCommentListController.h"
#import "ZDDInputView.h"
#import "ZDDMenuCommentCellNode.h"
#import "UIView+ZDD.h"
#import <MFNetworkManager/MFNetworkManager.h>
#import "FUCKNoteModel.h"

@interface ZDDMenuCommentListController ()<ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) ZDDInputView *inputView;
@property (nonatomic, assign) BOOL isForgiveFirstResponse;
@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation ZDDMenuCommentListController

- (NSMutableArray *)list {
    if (!_list) {
        _list = @[].mutableCopy;
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self addNotiObser];
    [self request];
}

- (void)setTargetId:(NSString *)targetId {
    _targetId = targetId;
    [self request];
}

- (void)request {
    [MFNETWROK post:@"Comment/ListCommentByTargetid" params:@{@"targetId": self.targetId}
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                NSLog(@"%@", result);
                if ([result[@"resultCode"] isEqualToString:@"0"]) {
                    if (self.list.count) {
                        [self.list removeAllObjects];
                    }
                    for (NSDictionary *dic in result[@"data"]) {
                        FUCKNoteModel *comment = [FUCKNoteModel yy_modelWithJSON:dic];
                        [self.list addObject:comment];
                    }
                    
                    [self.tableNode reloadData];
                }
            }
            failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MFHUDManager showError:@"加载失败"];
                });
            }];
}

- (void)setupUI {
    
    self.title = @"评论列表";
    
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(SafeAreaBottomHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(51);
    }];
    
    [self.view addSubview:self.tableNode.view];
    [self.tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.inputView.mas_top);
    }];
}

- (void)addNotiObser {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputView.textView resignFirstResponder];
}

#pragma mark - 发送评论
- (void)sendComment {
    [SVProgressHUD show];
    NSString *content = self.inputView.textView.text;
    [MFNETWROK post:@"http://120.78.124.36:10005/Comment/Create"
             params:@{
                      @"userId": [GODUserTool shared].user.user_id,
                      @"targetId": self.targetId,
                      @"content": content
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                [self request];
                dispatch_async(dispatch_get_main_queue(), ^{
                   self.inputView.textView.text = @"";
                    [SVProgressHUD dismiss];
                });
            }
            failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [SVProgressHUD dismiss];
                });
            }];
    [self.inputView.textView resignFirstResponder];
    
    
}


#pragma mark - noti Action
- (void)kbWillShow:(NSNotification *)noti {
    // 动画的持续时间
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.获取键盘的高度
    CGRect kbFrame =  [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbFrame.size.height;
    
    // 2.更改约束
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kbHeight);
        make.height.mas_equalTo(self.inputView.frame.size.height);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    self.isForgiveFirstResponse =  NO;
    
}

- (void)kbWillHide:(NSNotification *)noti {
    // 动画的持续时间
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.isForgiveFirstResponse) {
        return;
    }
    self.isForgiveFirstResponse =  YES;
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(self.inputView.height);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.inputView.textView resignFirstResponder];
}

#pragma mark - tableNodeDelegate
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%@", @(self.list.count));
    return self.list.count;
}


- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode * {
//        NSLog(@"%@", self.list[indexPath.row]);
        ZDDMenuCommentCellNode *cell = [[ZDDMenuCommentCellNode alloc] initWithComment:self.list[indexPath.row]];
//        cell.comment = self.list[indexPath.row];
        return cell;
    };
    
}



- (ZDDInputView *)inputView {
    if (!_inputView) {
        _inputView = [[ZDDInputView alloc] init];
        _inputView.textViewMaxLine = 4;
        __weak typeof(self)weakSelf = self;
        _inputView.sendBtnClickBlock = ^{
            [weakSelf sendComment];
        };
        _inputView.placeHolderString = @"一条吃货的看法~";
    }
    return _inputView;
}

-(ASTableNode *)tableNode {
    if (!_tableNode) {
        _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableNode.backgroundColor = [UIColor whiteColor];
        _tableNode.view.estimatedRowHeight = 0;
        _tableNode.leadingScreensForBatching = 1.0;
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableNode;
}

@end
