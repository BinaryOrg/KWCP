//
//  ZDDmenuCollectView.m
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDmenuCollectView.h"

@interface ZDDmenuCollectView ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIImageView *imgView;

@end


@implementation ZDDmenuCollectView

- (void)layoutSubviews {
    [self addSubview:self.imgView];
    [self addSubview:self.titleLb];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.imgView.mas_bottom).mas_equalTo(10);
    }];
}


- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.image = [UIImage imageNamed:@"noCollect"];
    }
    return _imgView;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:15];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.text = @"收藏";
    }
    return _titleLb;
}


@end
