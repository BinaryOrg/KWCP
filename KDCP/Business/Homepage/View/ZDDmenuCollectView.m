//
//  ZDDmenuCollectView.m
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 KWCP. All rights reserved.
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
        make.width.height.mas_equalTo(35);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.imgView.mas_bottom).mas_equalTo(10);
    }];
}

- (void)setIsCollected:(BOOL)isCollected {
    _isCollected = isCollected;
    if (isCollected) {
        self.imgView.image = [UIImage imageNamed:@"collect"];
        self.titleLb.text = @"已收藏";
    }else {
        self.imgView.image = [UIImage imageNamed:@"disCollect"];
        self.titleLb.text = @"收藏";
    }
}


- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.image = [UIImage imageNamed:@"collect"];
    }
    return _imgView;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:15];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = color(137, 137, 137, 1);
        _titleLb.text = @"收藏";
    }
    return _titleLb;
}


@end
