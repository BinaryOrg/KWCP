//
//  ZDDmenuCollectView.m
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDmenuCollectView.h"
#import "UIColor+ZDDColor.h"

@interface ZDDmenuCollectView ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIImageView *imgView;

@end


@implementation ZDDmenuCollectView

- (void)layoutSubviews {
//    [self addSubview:self.imgView];
    [self addSubview:self.titleLb];
    [self addSubview:self.imgButton];
    
    [self.imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.imgButton.mas_bottom).mas_equalTo(10);
    }];
}

- (void)setIsCollected:(BOOL)isCollected {
    _isCollected = isCollected;
    self.imgButton.selected = isCollected;
    if (isCollected) {
//        self.imgView.image = [UIImage imageNamed:@"collect"];
        self.titleLb.text = @"已收藏";
    }else {
//        self.imgView.image = [UIImage imageNamed:@"disCollect"];
        
        self.titleLb.text = @"收藏";
    }
}


- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}

- (TTAnimationButton *)imgButton {
    if (!_imgButton) {
        _imgButton = [TTAnimationButton buttonWithType:UIButtonTypeCustom];
        [_imgButton setImage:[UIImage imageNamed:@"ic_messages_like_selected_20x20_"] forState:UIControlStateNormal];
        _imgButton.imageSelectedColor = [UIColor zdd_redColor];
//        _imgButton.enableCustomImageSize = YES;
        _imgButton.explosionRate = 100;
    }
    return _imgButton;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:15];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = color(137, 137, 137, 1);
    }
    return _titleLb;
}


@end
