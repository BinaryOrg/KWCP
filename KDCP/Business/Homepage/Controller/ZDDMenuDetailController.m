//
//  ZDDMenuDetailController.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuDetailController.h"

#import "ZDDMenuCommentListController.h"
#import "ZDDMenuLogInController.h"

#import "ZDDMenuDetailTopCellNode.h"
#import "ZDDMenuStepsCellNode.h"
#import "ZDDMenuFoodsListCellNode.h"
#import "ZDDMenuOpenCommentCellNode.h"
#import "ZDDmenuCollectView.h"
#import "ZDDPhotoBrowseView.h"

#import <YYAnimatedImageView.h>

#import "UINavigationController+FDFullscreenPopGesture.h"


@interface ZDDMenuDetailController () <ASTableDelegate, ASTableDataSource, ZDDMenuDelegate>

@property (nonatomic, strong) ASTableNode *tableNode;

@end

@implementation ZDDMenuDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setModel:(ABCFuckModel *)model {
    _model = model;
    [self.tableNode reloadData];
}

- (void)setupUI {
    
    self.title = @"臭豆腐";
    self.fd_prefersNavigationBarHidden = YES;
    
    [self.view addSubview:self.tableNode.view];
    [self.tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
    }];
    
    // 左边返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftBarButtonItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(10, StatusBarHeight, 44, 44);
    [self.view addSubview:backButton];
    
    ZDDmenuCollectView *collectView = [[ZDDmenuCollectView alloc] init];
    [self.view addSubview:collectView];
    [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(- ScreenHeight * 0.3);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(60);
    }];
    collectView.userInteractionEnabled = YES;
    [collectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCollect)]];
}

//点击收藏
- (void)clickCollect {
    if ([GODUserTool isLogin]) {
        
    }else {
        [self jumpToLogIn];
    }
}
//点击返回
- (void)leftBarButtonItemDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击图片
- (void)menuCellNode:(ASCellNode *)node didClickImageNode:(NSArray<ASNetworkImageNode *> *)imageNodes clickIndex:(NSInteger)index{
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:imageNodes.count];
    [imageNodes enumerateObjectsUsingBlock:^(ASNetworkImageNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LHPhotoGroupItem *item = [[LHPhotoGroupItem alloc]init];
        YYAnimatedImageView * animatedIV = [[YYAnimatedImageView alloc] init];
        animatedIV.image = obj.image;
        item.thumbView = animatedIV;
        item.largeImageURL = obj.URL;
        [tempArr addObject:item];
        //    item.largeImageSize = imageNode.image.size;
    }];
    
    UIView *fromView = [imageNodes[index] view];
    

    ZDDPhotoBrowseView *photoGroupView = [[ZDDPhotoBrowseView alloc] initWithGroupItems:tempArr.copy];
    [photoGroupView.pager removeFromSuperview];
    photoGroupView.fromItemIndex = 0;
    photoGroupView.backtrack = YES;
    [photoGroupView presentFromImageView:fromView
                             toContainer:self.navigationController.view
                                animated:YES
                              completion:nil];
    
}


- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {

    return 4;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode *() {
        if (indexPath.row == 0) {
            ZDDMenuDetailTopCellNode *node = [[ZDDMenuDetailTopCellNode alloc] initWithModel:self.model];
            node.delegate = self;
            node.selectionStyle = UITableViewCellSelectionStyleNone;
            return node;
        }
        else if (indexPath.row == 1) {
            ZDDMenuFoodsListCellNode *node = [[ZDDMenuFoodsListCellNode alloc] initWithModel:self.model];
            node.selectionStyle = UITableViewCellSelectionStyleNone;
            return node;
        }
        else if (indexPath.row == 2) {
            ZDDMenuStepsCellNode *node = [[ZDDMenuStepsCellNode alloc] initWithModel:self.model];
            node.delegate = self;
            node.selectionStyle = UITableViewCellSelectionStyleNone;
            return node;
        }
        else {
            ZDDMenuOpenCommentCellNode *node = [[ZDDMenuOpenCommentCellNode alloc] initWithCount:self.model.comment_num];
            node.selectionStyle = UITableViewCellSelectionStyleNone;
            return node;
        }
        
    };
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        if ([GODUserTool isLogin]) {
            ZDDMenuCommentListController *vc = [[ZDDMenuCommentListController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self jumpToLogIn];
        }
    }
}

- (void)jumpToLogIn {
    ZDDMenuLogInController *vc = [[ZDDMenuLogInController alloc] init];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
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
