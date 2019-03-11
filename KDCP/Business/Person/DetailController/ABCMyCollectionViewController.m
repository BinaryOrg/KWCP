//
//  ABCMyCollectionViewController.m
//  KDCP
//
//  Created by 张冬冬 on 2019/3/11.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ABCMyCollectionViewController.h"
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

#import "ABCFuckModel.h"

#import "ABCFuckCollectionTableViewCell.h"
#import "ZDDMenuDetailController.h"

@interface ABCMyCollectionViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ABCFuckModel *> *list;
@end

@implementation ABCMyCollectionViewController

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
        for (NSUInteger i = 1; i <= 24; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"QI-%@", @(i)]];
            [idleImages addObject:image];
        }
        
        [gifHeader setImages:idleImages forState:MJRefreshStateIdle];
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 4; i <= 24; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"QI-%@", @(i)]];
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
    self.navigationItem.title = @"我的菜谱";
    
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
    
    NSString *url = @"http://120.78.124.36:10005/Recipe/ListCollectRecipeByUserId";
    
    [MFNETWROK post:url
             params:@{
                      @"userId": [GODUserTool shared].user.user_id ? [GODUserTool shared].user.user_id : @"",
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                NSLog(@"%@", result);
                if ([result[@"resultCode"] isEqualToString:@"0"]) {
                    if (self.list.count) {
                        [self.list removeAllObjects];
                    }
                    for (NSDictionary *dic in result[@"data"]) {
                        ABCFuckModel *fuck = [ABCFuckModel yy_modelWithJSON:dic];
                        [self.list addObject:fuck];
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
    ABCFuckModel *fuck = self.list[indexPath.row];
    ABCFuckCollectionTableViewCell *cell = [[ABCFuckCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fuck_recipe"];
   
    [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:fuck.cover_picture] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
    cell.summaryLabel.text = fuck.desc;
    cell.dateLabel.text = fuck.tag;
    cell.collectCountLabel.text = [NSString stringWithFormat:@"%@", @(fuck.collection_num)];
    cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(fuck.comment_num)];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((SCREENWIDTH - 80)/2) + 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZDDMenuDetailController *detail = [[ZDDMenuDetailController alloc] init];
//    detail.note = self.list[indexPath.row];
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak __typeof(self)weakSelf = self;
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf removeAtIndexPath:indexPath];
    }];
    delete.backgroundColor = [UIColor zdd_redColor];
    return @[delete];
}


- (void)removeAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *recipe_id = self.list[indexPath.row].recipe_id;
//    [SVProgressHUD show];
    [MFNETWROK post:@"http://120.78.124.36:10005/Collection/AddOrCancel"
             params:@{
                      @"targetId": recipe_id,
                      @"userId": [GODUserTool shared].user.user_id ? [GODUserTool shared].user.user_id : @"",
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
//                if ([result[@"code"] integerValue] == 200) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self sendRequest];
//                    });
//                }else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [SVProgressHUD showErrorWithStatus:@"取消失败"];
//                    });
//                }
            }
            failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SVProgressHUD showErrorWithStatus:@"取消失败"];
//                });
            }];
    [self.list removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

@end
