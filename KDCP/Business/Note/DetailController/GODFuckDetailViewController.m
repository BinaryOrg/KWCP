//
//  GODFuckDetailViewController.m
//  KDCP
//
//  Created by ZDD on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import "GODFuckDetailViewController.h"
#import <YYWebImage/YYWebImage.h>
#import <MJRefresh/MJRefresh.h>

#import <MFNetworkManager/MFNetworkManager.h>
#import "ZDDMenuLogInController.h"

#import "FUCKIngLifeTableViewCell.h"
#import "FUCKIngLife2TableViewCell.h"

#import "FUCKCommentTableViewCell.h"
@interface GODFuckDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation GODFuckDetailViewController

- (NSMutableArray *)list {
    if (!_list) {
        _list = @[].mutableCopy;
    }
    return _list;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - STATUSBARANDNAVIGATIONBARHEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        __weak typeof(self) weakSelf = self;
        MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf refreshPage];
        }];
        
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i <= 19; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"HAO-%@", @(i)]];
            [idleImages addObject:image];
        }
        
        [gifHeader setImages:idleImages forState:MJRefreshStateIdle];
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 4; i <= 19; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"HAO-%@", @(i)]];
            [refreshingImages addObject:image];
        }
        [gifHeader setImages:refreshingImages forState:MJRefreshStatePulling];
        
        // 设置正在刷新状态的动画图片
        [gifHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
        
        //隐藏时间
        gifHeader.lastUpdatedTimeLabel.hidden = YES;
        //隐藏状态
        gifHeader.stateLabel.hidden = YES;
        
        
        _tableView.mj_header = gifHeader;
        
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(commentClick)];
    [self.view addSubview:self.tableView];
    [self sendRequest];
}

- (void)commentClick {
    if ([MFHUDManager isShowing]) {
        return;
    }
    if ([GODUserTool isLogin]) {
        //改名
        [self presentAlertController];
    }else {
        //login
        [self presentViewController:[ZDDMenuLogInController new] animated:YES completion:nil];
    }
}

- (void)startLoadingWithText:(NSString *)text {
    //    [QMUITips showLoading:text inView:self.view];
    //    [self.tips showLoading:text];
    [MFHUDManager showLoading:text];
}

- (void)showErrorWithText:(NSString *)text {
    //    [self.tips showError:text];
    [MFHUDManager showError:text];
}

- (void)showSuccessWithText:(NSString *)text {
    //    [self.tips showSucceed:text];
    [MFHUDManager showSuccess:text];
    
}

- (void)stopLoading {
    //    [QMUITips hideAllToastInView:self.view animated:YES];
    //    [self.tips hideAnimated:YES];
    [MFHUDManager dismiss];
}

- (void)presentAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入要评论内容" preferredStyle:UIAlertControllerStyleAlert];
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tintColor = theme.selectTabColor;
    }];
    __weak typeof(alert) weakAlert = alert;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakAlert) strongAlert = weakAlert;
        [self startLoadingWithText:@"评论中..."];
        NSString *comments = strongAlert.textFields[0].text;
        [MFNETWROK post:@"Comment/Create"
                 params:@{
                          @"userId": [GODUserTool shared].user.user_id,
                          @"targetId": self.note.note_id,
                          @"content": comments
                          }
                success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                    NSLog(@"%@", result);
                    if ([result[@"resultCode"] isEqualToString:@"0"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopLoading];
                            [self reloadNewData];
                            [[NSNotificationCenter defaultCenter] postNotificationName:FBSuccessNotification object:nil];
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showErrorWithText:@"评论失败！"];
                        });
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self stopLoading];
                        });
                    }
                }
                failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showErrorWithText:@"评论失败！"];
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self stopLoading];
                    });
                }];
    }];
    [cancel setValue:[UIColor zdd_blueColor] forKey:@"_titleTextColor"];
    [ensure setValue:[UIColor zdd_blueColor] forKey:@"_titleTextColor"];
    [alert addAction:cancel];
    [alert addAction:ensure];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)reloadNewData {
    [self sendRequest];
}

- (void)refreshPage {
    [self.tableView.mj_header beginRefreshing];
    [self sendRequest];
}

- (void)sendRequest {
    [MFNETWROK post:@"http://120.78.124.36:10005/Comment/ListCommentByTargetid"
             params:@{
                      @"targetId": self.note.note_id
                      }
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
                    
                    [self.tableView reloadData];
                }else {
                    
                }
                if ([self.tableView.mj_header isRefreshing]) {
                    [self.tableView.mj_header endRefreshing];
                }
            } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                NSLog(@"%@", error.userInfo);
                if ([self.tableView.mj_header isRefreshing]) {
                    [self.tableView.mj_header endRefreshing];
                }
            }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        if (self.note.picture_path.count == 1) {
            FUCKIngLifeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fuck1"];
            if (!cell) {
                cell = [[FUCKIngLifeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fuck1"];
            }
            [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, self.note.user.avater]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            cell.nameLabel.text = self.note.user.user_name;
            [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, self.note.picture_path[0]]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            cell.summaryLabel.text = self.note.content;
            cell.dateLabel.text = [self formatFromTS:self.note.create_date];
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", @(self.note.star_num)];
            cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(self.note.comment_num)];
            if (self.note.is_star) {
                cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
            }else {
                cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
            }
            [cell.summaryLabel setHeight:self.note.content_height + 10];
            return cell;
        }else {
            FUCKIngLife2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fuck2"];
            if (!cell) {
                cell = [[FUCKIngLife2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fuck2"];
            }
            [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, self.note.user.avater]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            cell.nameLabel.text = self.note.user.user_name;
            [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, self.note.picture_path[0]]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            [cell.imageView2 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, self.note.picture_path[1]]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            cell.summaryLabel.text = self.note.content;
            cell.dateLabel.text = [self formatFromTS:self.note.last_update_date];
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", @(self.note.star_num)];
            cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(self.note.comment_num)];
            if (self.note.is_star) {
                cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
            }else {
                cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
            }
            [cell.summaryLabel setHeight:self.note.content_height + 10];
            return cell;
        }
    } else {
        FUCKNoteModel *data = self.list[indexPath.row - 1];
        GODUserModel *user = data.user;
        FUCKCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
        if (!cell) {
            cell = [[FUCKCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
        }
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, user.avater]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        cell.nameLabel.text = user.user_name;
        cell.summaryLabel.text = data.content;
        [cell.summaryLabel setHeight:data.content_height + 10];
        [cell.dateLabel setY:CGRectGetMaxY(cell.summaryLabel.frame)];
        cell.dateLabel.text = [self formatFromTS:data.create_date];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        if (!self.flag) {
            return ((SCREENWIDTH - 80)/2) + 80 + self.note.content_height + 10 + 8;
        }
        return 80 + self.note.content_height + 10 + 8;
    }
    else {
        FUCKNoteModel *data = self.list[indexPath.row - 1];
        return 70 + data.content_height + 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)formatFromTS:(NSInteger)ts {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *str = [NSString stringWithFormat:@"%@",
                     [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]]];
    return str;
}


@end
