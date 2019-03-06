//
//  ZDDMenuDetailController.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDMenuDetailController.h"

#import "ZDDMenuDetailTopCellNode.h"
#import "ZDDMenuStepsCellNode.h"
#import "ZDDMenuFoodsListCellNode.h"
#import "ZDDMenuOpenCommentCellNode.h"

#import "UINavigationController+FDFullscreenPopGesture.h"


@interface ZDDMenuDetailController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;

@end

@implementation ZDDMenuDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.tableNode.view];
    [self.tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
    }];
}


- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {

    return 4;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode *() {
        if (indexPath.row == 0) {
            ZDDMenuDetailTopCellNode *node = [[ZDDMenuDetailTopCellNode alloc] init];
            return node;
        }
        else if (indexPath.row == 1) {
            ZDDMenuFoodsListCellNode *node = [[ZDDMenuFoodsListCellNode alloc] init];
            return node;
        }
        else if (indexPath.row == 2) {
            ZDDMenuStepsCellNode *node = [[ZDDMenuStepsCellNode alloc] init];
            return node;
        }
        else {
            ZDDMenuOpenCommentCellNode *node = [[ZDDMenuOpenCommentCellNode alloc] init];
            return node;
        }
        
    };
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
