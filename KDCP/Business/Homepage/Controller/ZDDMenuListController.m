//
//  ZDDMenuListController.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuListController.h"


#import "ZDDMenuDetailController.h"
#import "ZDDMenuTagController.h"

#import "ZDDMenuListCell.h"


#import <MJRefresh.h>

@interface ZDDMenuListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <ABCFuckModel *>*dataArr;

@end

@implementation ZDDMenuListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    
    self.title = @"推荐";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_chose"] style:UIBarButtonItemStyleDone target:self action:@selector(choseCategory)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:LoginSuccessNotification object:nil];

}

- (void)loadData {
    
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;;
    [MFNETWROK post:@"Recipe/ListRecommendRecipe" params:@{@"userId": [GODUserTool shared].user.user_id.length ? [GODUserTool shared].user.user_id : @""} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self.tableView.mj_header endRefreshing];
        if (statusCode == 200) {
            self.dataArr = [NSArray yy_modelArrayWithClass:ABCFuckModel.class json:result[@"data"]];
            [self.tableView reloadData];
        }else {
            [MFHUDManager showError:@"请求失败"];
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self.tableView.mj_header endRefreshing];
        [MFHUDManager showError:@"请求失败"];
    }];
}

- (void)choseCategory {
    
    ZDDMenuTagController *vc = [ZDDMenuTagController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZDDMenuListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZDDMenuListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZDDMenuDetailController *vc = [[ZDDMenuDetailController alloc] init];
    vc.model = self.dataArr[indexPath.row];
     [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation((90.0*M_PI/180), 0.0, 0.7, 0.4);
    rotation.m44 = 1.0/-600;
    //阴影
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    //阴影偏移
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    //透明度
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    
    //锚点
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [UIView beginAnimations:@"rotaion" context:NULL];
    
    [UIView setAnimationDuration:0.8];
    
    cell.layer.transform = CATransform3DIdentity;
    
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    
    [UIView commitAnimations];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:ZDDMenuListCell.class forCellReuseIdentifier:@"ZDDMenuListCell"];
        __weak typeof(self)weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.textColor = [UIColor grayColor];
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        _tableView.mj_header = header;
    }
    return _tableView;
}


@end
