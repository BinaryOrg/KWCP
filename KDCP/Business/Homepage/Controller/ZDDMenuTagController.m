//
//  ZDDMenuTagController.m
//  KDCP
//
//  Created by Maker on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDMenuTagController.h"

#import "ZDDTagListController.h"


#import <TTGTextTagCollectionView.h>
#import "ZDDMennuCategoryView.h"

#import "ZDDTagListModel.h"
#import "UIColor+CustomColors.h"

#define leftViewWidth 100

@interface ZDDMenuTagController ()<ZDDMennuCategoryViewDelegate, TTGTextTagCollectionViewDelegate>

@property (nonatomic, strong) TTGTextTagCollectionView *rightView;
@property (nonatomic, strong) ZDDMennuCategoryView *leftView;
@property (nonatomic, strong) NSArray <ZDDMenuModel *>*categoryArr;
@property (nonatomic, strong) NSArray <ZDDTagListModel *>*tagArr;

@end

@implementation ZDDMenuTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChileView];
    [self loadData];

}

- (void)addChileView {
    self.title = @"分类";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.leftView];
    [self.view addSubview:self.rightView];
    
}

- (void)loadData {
    
    NSMutableArray <ZDDMenuModel *>*tempCategoryArr = [NSMutableArray array];
    NSArray <ZDDTagListModel *>*tagModelArr = [NSArray yy_modelArrayWithClass:ZDDTagListModel.class json:[self readLocalTagWith]];
    [tagModelArr enumerateObjectsUsingBlock:^(ZDDTagListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZDDMenuModel *model = [ZDDMenuModel new];
        model.title = obj.category;
        [tempCategoryArr addObject:model];
    }];
    
    self.tagArr = tagModelArr;
    self.categoryArr = tempCategoryArr.copy;
    [self reloadLeftViewWithArray:self.categoryArr];
    
}


- (void)reloadLeftViewWithArray:(NSArray <ZDDMenuModel *>*)dataArr {
    self.leftView.dataArr = dataArr;
}

- (void)reloadRightViewWithArray:(NSArray <NSString *>*)dataArr {
    [self.rightView removeAllTags];
    [self.rightView addTags:dataArr];
}


#pragma mark - 点击左边分类
- (void)clickCategory:(NSString *)category indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.tagArr.count) {
        ZDDTagListModel *model = self.tagArr[indexPath.row];
        [self reloadRightViewWithArray:model.tag];
    }
}
#pragma mark - 点击右边标签
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected tagConfig:(TTGTextTagConfig *)config {
    if (tagText.length) {
        ZDDTagListController *vc = [ZDDTagListController new];
        vc.tag = tagText;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (NSArray *)readLocalTagWith {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"caipuTagList" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (ZDDMennuCategoryView *)leftView {
    if (!_leftView) {
        _leftView = [[ZDDMennuCategoryView alloc] initWithFrame:CGRectMake(0, 0, leftViewWidth, self.view.height - NavBarHeight)];
        _leftView.delegate = self;
    }
    return _leftView;
}

- (TTGTextTagCollectionView *)rightView {
    if (!_rightView) {
        _rightView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(leftViewWidth + 20, 20, SCREENWIDTH - leftViewWidth - 20 - 10, self.view.height - NavBarHeight - 20)];
        _rightView.delegate = self;
        
        
        TTGTextTagConfig *config = _rightView.defaultConfig;
        config.textColor = [UIColor colorWithRed:51 green:51 blue:51];//color(53, 64, 72, 1);
        config.selectedTextColor = [UIColor blackColor];
        config.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245];
        config.selectedBackgroundColor = [UIColor colorWithRed:245 green:245 blue:245];
        config.extraSpace = CGSizeMake(30, 15);
        config.shadowColor = [UIColor clearColor];
//        config.borderColor = color(137, 137, 137, 0.3);
//        config.borderWidth = 0.5;
//        _rightView.defaultConfig = config;
    }
    return _rightView;
}

@end
