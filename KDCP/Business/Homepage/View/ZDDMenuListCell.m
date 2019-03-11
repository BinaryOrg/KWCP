//
//  ZDDMenuListCell.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuListCell.h"


@interface ZDDMenuListCell ()

@property (nonatomic, strong) UIImageView *backgroundIV;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *subTitleLb;


@end



@implementation ZDDMenuListCell

- (void)setModel:(ABCFuckModel *)model {
    _model = model;
    [self.backgroundIV yy_setImageWithURL:[NSURL URLWithString:model.cover_picture] placeholder:[UIImage imageNamed:@"freshFood"]];
    self.titleLb.text = model.recipe_name;
    self.subTitleLb.text = model.desc;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
   
    
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.contentView addSubview:self.subTitleLb];
    [self.subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_equalTo(6);
        make.right.mas_equalTo(-20);
    }];

    
    [self.contentView addSubview:self.backgroundIV];
    [self.backgroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.subTitleLb.mas_bottom).mas_equalTo(10);
        make.bottom.mas_equalTo(-20);
    }];

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
        _titleLb.textColor = [UIColor blackColor];
    }
    return _titleLb;
}

- (UILabel *)subTitleLb {
    if (!_subTitleLb) {
        _subTitleLb = [[UILabel alloc] init];
        _subTitleLb.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        _subTitleLb.textAlignment = NSTextAlignmentLeft;
        _subTitleLb.textColor = GODColor(137, 137, 137);
    }
    return _subTitleLb;
}


@end
