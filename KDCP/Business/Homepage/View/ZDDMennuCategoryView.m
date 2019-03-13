//
//  ZDDMennuCategoryView.m
//  KDCP
//
//  Created by Maker on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDMennuCategoryView.h"
#import "FUCKCategoryTableViewCell.h"
@interface ZDDMennuCategoryView ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZDDMennuCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setDataArr:(NSArray<ZDDMenuModel *> *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
    if (dataArr.count) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        if ([self.delegate respondsToSelector:@selector(clickCategory:indexPath:)]) {
            ZDDMenuModel *model = self.dataArr[0];
            [self.delegate clickCategory:model.title indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }
    
}

#pragma mark - 追问/回答的数据源+代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUCKCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[FUCKCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ZDDMenuModel *model = self.dataArr[indexPath.row];
    cell.nameLabel.text = model.title;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(clickCategory:indexPath:)]) {
        ZDDMenuModel *model = self.dataArr[indexPath.row];
        [self.delegate clickCategory:model.title indexPath:indexPath];
    }
    
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator  = NO;
        _tableView.showsVerticalScrollIndicator  = NO;
    }
    return _tableView;
}

-(void)dealloc {
    self.delegate = nil;
}

@end
