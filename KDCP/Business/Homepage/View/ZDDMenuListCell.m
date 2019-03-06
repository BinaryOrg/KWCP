//
//  ZDDMenuListCell.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDMenuListCell.h"


@interface ZDDMenuListCell ()

@property (nonatomic, strong) UIImageView *backgroundIV;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *subTitleLb;


@end



@implementation ZDDMenuListCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addSubview:self.backgroundIV];
    [self.backgroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.backgroundIV addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.backgroundIV addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.backgroundIV addSubview:self.subTitleLb];
    [self.subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-10);
    }];
    
    [self.backgroundIV addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(self.subTitleLb.mas_top).mas_equalTo(-8);
        make.right.mas_equalTo(-10);
    }];
    
    
    self.backgroundIV.yy_imageURL = [NSURL URLWithString:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=208717556,829408777&fm=26&gp=0.jpg"];
    self.titleLb.text = @"臭豆腐";
    self.subTitleLb.text = @"正宗长沙臭豆腐，一口下去，满嘴清香，绕唇三日，消而不绝，口齿留香";
}



- (UIImageView *)backgroundIV {
    if (!_backgroundIV) {
        _backgroundIV = [[UIImageView alloc] init];
        _backgroundIV.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundIV.layer.masksToBounds = YES;
        _backgroundIV.layer.cornerRadius = 6;
        _backgroundIV.image = [UIImage imageNamed:@"aa"];
    }
    return _backgroundIV;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.textColor = [UIColor whiteColor];
    }
    return _titleLb;
}

- (UILabel *)subTitleLb {
    if (!_subTitleLb) {
        _subTitleLb = [[UILabel alloc] init];
        _subTitleLb.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        _subTitleLb.textAlignment = NSTextAlignmentLeft;
        _subTitleLb.textColor = [UIColor whiteColor];
    }
    return _subTitleLb;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = color(0, 0, 0, 0.15);
    }
    return _coverView;
}

@end
