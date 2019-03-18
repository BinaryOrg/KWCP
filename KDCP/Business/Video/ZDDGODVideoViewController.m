//
//  ZDDGODVideoViewController.m
//  KDCP
//
//  Created by 张冬冬 on 2019/3/15.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDGODVideoViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "TEMPMacro.h"
#import <MFNetworkManager/MFNetworkManager.h>
#import <YYWebImage/YYWebImage.h>
#import "ABCFuckModel.h"

#import "ZDDGODVideoTableViewCell.h"
#import <SJBaseVideoPlayer/UIScrollView+ListViewAutoplaySJAdd.h>
#import <SJVideoPlayer/SJVideoPlayer.h>
@interface ZDDGODVideoViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
SJPlayerAutoplayDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ABCFuckModel *> *list;
@property (nonatomic, strong) SJBaseVideoPlayer *player;
@end

@implementation ZDDGODVideoViewController

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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    self.navigationItem.title = @"视频站";
    if (!self.flag) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_comment_reply_24x24_"] style:UIBarButtonItemStylePlain target:self action:@selector(fbClick)];
    }
    [self.view addSubview:self.tableView];
    [self sendRequest];
    [self _configAutoplayForTableView];
    
}

- (void)_configAutoplayForTableView {
    // 配置列表自动播放
    SJPlayerAutoplayConfig *config = [SJPlayerAutoplayConfig configWithPlayerSuperviewTag:100 autoplayDelegate:self];
//    config.animationType = SJAutoplayPositionTop;
    [_tableView sj_enableAutoplayWithConfig:config];
    [_tableView sj_needPlayNextAsset];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self.tableView sj_needPlayNextAsset];
}

- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath {
    ZDDGODVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ( !_player || !_player.isFullScreen ) {
        [_player stopAndFadeOut]; // 让旧的播放器淡出
        _player = [SJBaseVideoPlayer player]; // 创建一个新的播放器
        [_player controlLayerNeedDisappear];
//        _player.isPlayOnScrollView
        // fade in(淡入)
        _player.view.alpha = 0.001;
        [UIView animateWithDuration:0.6 animations:^{
            self.player.view.alpha = 1;
        }];
    }
#ifdef SJMAC
    _player.disablePromptWhenNetworkStatusChanges = YES;
#endif
    [cell.bgImageView addSubview:self.player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.list[indexPath.row].vedio] playModel:[SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:cell.bgImageView.tag atIndexPath:indexPath tableView:self.tableView]];
    [_player.placeholderImageView yy_setImageWithURL:[NSURL URLWithString:self.list[indexPath.row].cover_picture] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
    _player.mute = YES;
    
    _player.playerViewWillAppearExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
        [videoPlayer play];
        videoPlayer.view.hidden = NO;
    };
    
    
    _player.playerViewWillDisappearExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
        [videoPlayer pause];
        videoPlayer.view.hidden = YES;
    };
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
        url = @"http://120.78.124.36:10005/Recipe/ListCollectRecipeByUserId";
    }
    else {
        url = @"http://120.78.124.36:10005/Recipe/ListRecommendVedioRecipe";
    }
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
                        ABCFuckModel *video = [ABCFuckModel yy_modelWithJSON:dic];
                        [self.list addObject:video];
                    }
                    
                    [self.tableView reloadData];
                }else {
                    
                }
                if ( !self.tableView.sj_currentPlayingIndexPath ) {
                    [self.tableView sj_needPlayNextAsset];
                }
                else {
                    self.tableView.sj_currentPlayingIndexPath = nil;
                    self.player = nil;
                }
                if ([self.tableView.mj_header isRefreshing]) {
                    [self.tableView sj_needPlayNextAsset];
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
    ABCFuckModel *video = self.list[indexPath.row];
    ZDDGODVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"video_cell"];
    if (!cell) {
        cell = [[ZDDGODVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"video_cell"];
    }
    
    [cell.bgImageView yy_setImageWithURL:[NSURL URLWithString:video.cover_picture] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
    cell.like.selected = video.is_collect;
    [cell.like addTarget:self action:@selector(handleLikeEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;

    return nil;
}



- (void)handleLikeEvent:(TTAnimationButton *)sender {
    sender.selected = !sender.selected;
//    if (![GODUserTool isLogin]) {
//        [self presentViewController:[ZDDMenuLogInController new] animated:YES completion:nil];
//        return;
//    }
//    FUCKNoteTableViewCell *cell = (FUCKNoteTableViewCell *)sender.superview.superview;
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    FUCKNoteModel *note = self.list[indexPath.row];
//
//    if (note.is_star) {
//        note.star_num -= 1;
//    }else {
//        note.star_num += 1;
//
//    }
//    [MFNETWROK post:@"http://120.78.124.36:10005/Star/AddOrCancel" params:@{
//                                                                            @"userId": [GODUserTool shared].user.user_id,
//                                                                            @"targetId": note.note_id,
//                                                                            } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
//                                                                                NSLog(@"%@", result);
//                                                                            } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
//                                                                                NSLog(@"%@", error.userInfo);
//                                                                            }];
//    note.is_star = !note.is_star;
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREENWIDTH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    GODFuckDetailViewController *detail = [[GODFuckDetailViewController alloc] init];
//    detail.note = self.list[indexPath.row];
//    //    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detail animated:YES];
    //    self.hidesBottomBarWhenPushed = NO;
}

- (void)fbClick {
    if ([GODUserTool isLogin]) {
        //        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:[FUCKFBNoteViewController new] animated:YES];
        //        self.hidesBottomBarWhenPushed = NO;
    }else {
//        ZDDMenuLogInController *vc = [ZDDMenuLogInController new];
//
//        [self presentViewController:vc animated:YES completion:nil];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height -= self.tabBarController.tabBar.bounds.size.height;
    
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(ZDDGODVideoTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) _self = self;
//    cell.view.clickedPlayButtonExeBlock = ^(SJPlayView * _Nonnull view) {
//        __strong typeof(_self) self = _self;
//        if ( !self ) return;
//        [self sj_playerNeedPlayNewAssetAtIndexPath:indexPath];
//    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

@end
