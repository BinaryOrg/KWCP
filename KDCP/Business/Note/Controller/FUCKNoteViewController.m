//
//  FUCKNoteViewController.m
//  KDCP
//
//  Created by ZDD on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import "FUCKNoteViewController.h"

#import <MJRefresh/MJRefresh.h>
#import "TEMPMacro.h"
#import <MFNetworkManager/MFNetworkManager.h>
#import <YYWebImage/YYWebImage.h>
#import "FUCKNoteModel.h"
#import "FUCKNoteTableViewCell.h"
#import "FUCKNote2TableViewCell.h"
#import "ZDDMenuLogInController.h"
#import "FUCKFBNoteViewController.h"
#import "GODFuckDetailViewController.h"

@interface FUCKNoteViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation FUCKNoteViewController

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
        _tableView.estimatedSectionHeaderHeight = 0;        __weak typeof(self) weakSelf = self;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:FBSuccessNotification object:nil];
    self.navigationItem.title = @"笔记圈";
    if (!self.flag) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_comment_reply_24x24_"] style:UIBarButtonItemStylePlain target:self action:@selector(fbClick)];
    }
    [self.view addSubview:self.tableView];
    [self sendRequest];
}

- (void)refreshPage {
    [self.tableView.mj_header beginRefreshing];
    [self sendRequest];
}

- (void)loadNewData {
    //    [self.tableView.mj_header beginRefreshing];
    [self sendRequest];
}

- (void)sendRequest {
    NSString *url;
    if (self.flag) {
        url = @"http://120.78.124.36:10005/Note/ListNoteByUserId";
    }
    else {
        url = @"http://120.78.124.36:10005/Note/ListRecommendNote";
    }
    [MFNETWROK post:url
             params:@{
                      @"orderBy": @"note_create_date",
                      @"userId": [GODUserTool shared].user.user_id ? [GODUserTool shared].user.user_id : @"",
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                NSLog(@"%@", result);
                if ([result[@"resultCode"] isEqualToString:@"0"]) {
                    if (self.list.count) {
                        [self.list removeAllObjects];
                    }
                    for (NSDictionary *dic in result[@"data"]) {
                        FUCKNoteModel *note = [FUCKNoteModel yy_modelWithJSON:dic];
                        [self.list addObject:note];
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
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FUCKNoteModel *note = self.list[indexPath.row];
    GODUserModel *user = note.user;
    if (note.picture_path.count == 1) {
        FUCKNoteTableViewCell *cell = [[FUCKNoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fuck_note1"];
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, user.avater]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        cell.nameLabel.text = user.user_name;
        [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, note.picture_path[0]]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        cell.summaryLabel.text = note.content;
        cell.dateLabel.text = [self formatFromTS:note.create_date];
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", @(note.star_num)];
        cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(note.comment_num)];
        if (note.is_star) {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
        }else {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
        }
        [cell.likeButton addTarget:self action:@selector(like1:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else {
        FUCKNote2TableViewCell *cell = [[FUCKNote2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fuck_note2"];
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, user.avater]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, user.avater]] placeholder:[UIImage imageNamed:@"HAO-0"] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        cell.nameLabel.text = user.user_name;
        [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, note.picture_path[0]]]  options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        [cell.imageView2 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, note.picture_path[1]]]  options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        cell.summaryLabel.text = note.content;
        cell.dateLabel.text = [self formatFromTS:note.create_date];
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", @(note.star_num)];
        cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(note.comment_num)];
        if (note.is_star) {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
        }else {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
        }
        [cell.likeButton addTarget:self action:@selector(like2:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

- (void)like1:(UIButton *)sender {
    if (![GODUserTool isLogin]) {
        [self presentViewController:[ZDDMenuLogInController new] animated:YES completion:nil];
        return;
    }
    FUCKNoteTableViewCell *cell = (FUCKNoteTableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FUCKNoteModel *note = self.list[indexPath.row];
    
    if (note.is_star) {
        note.star_num -= 1;
    }else {
        note.star_num += 1;
        
    }
    [MFNETWROK post:@"http://120.78.124.36:10005/Star/AddOrCancel" params:@{
                                                 @"userId": [GODUserTool shared].user.user_id,
                                                 @"targetId": note.note_id,
                                                 } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                                                     NSLog(@"%@", result);
                                                 } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                                                     NSLog(@"%@", error.userInfo);
                                                 }];
    note.is_star = !note.is_star;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)like2:(UIButton *)sender {
    if (![GODUserTool isLogin]) {
        [self presentViewController:[ZDDMenuLogInController new] animated:YES completion:nil];
        return;
    }
    FUCKNote2TableViewCell *cell = (FUCKNote2TableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FUCKNoteModel *note = self.list[indexPath.row];
    
    if (note.is_star) {
        note.star_num -= 1;
    }else {
        note.star_num += 1;
        
    }
    [MFNETWROK post:@"Star/AddOrCancel" params:@{
                                                 @"userId": [GODUserTool shared].user.user_id,
                                                 @"targetId": note.note_id,
                                                 } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                                                     NSLog(@"%@", result);
                                                 } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                                                     NSLog(@"%@", error.userInfo);
                                                 }];
    note.is_star = !note.is_star;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((SCREENWIDTH - 80)/2) + 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GODFuckDetailViewController *detail = [[GODFuckDetailViewController alloc] init];
    detail.note = self.list[indexPath.row];
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}

- (void)fbClick {
    if ([GODUserTool isLogin]) {
//        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[FUCKFBNoteViewController new] animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
    }else {
        ZDDMenuLogInController *vc = [ZDDMenuLogInController new];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
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
