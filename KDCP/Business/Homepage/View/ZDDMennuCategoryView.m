//
//  ZDDMennuCategoryView.m
//  KDCP
//
//  Created by Maker on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDMennuCategoryView.h"

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
}

#pragma mark - 追问/回答的数据源+代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ZDDMenuModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = color(137, 137, 137, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
        
    }
    return _tableView;
}

-(void)dealloc {
    self.delegate = nil;
}

@end
