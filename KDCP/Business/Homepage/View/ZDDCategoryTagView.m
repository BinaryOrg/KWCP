//
//  ZDDCategoryTagView.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDCategoryTagView.h"

#define SelectdeTitleColor GODColor(53, 64, 72)
#define SelectdeTitleFont [UIFont fontWithName:@"PingFangSC-Medium" size:15]
#define UnselectdeColor GODColor(137, 137, 137)
#define UnselectdeFont [UIFont fontWithName:@"PingFangSC-Medium" size:14]
#define  centerSpacing  44.0f
#define  leftSpacing  20

@interface ZDDCategoryTagView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *buttons;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIView *scrollLine;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *toplineView;

@property (nonatomic, strong) NSMutableArray *buttonWiths;

@property (nonatomic, strong) UIImageView *imgView;

@end


@implementation ZDDCategoryTagView

- (instancetype)initWithTitles:(NSArray *)titles {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _titles = titles;
        _selectedTag = 0;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
//    [self addSubview:self.imgView];
//    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, 55 + StatusBarHeight);

    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:self.titles.count];
    CGFloat contentW = leftSpacing;
    for (int i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [btn setTitle:title forState:UIControlStateNormal];
        if (i == self.selectedTag) {
            [btn setTitleColor:GODColor(53, 64,72) forState:UIControlStateNormal];
        }else {
            [btn setTitleColor:GODColor(146, 146, 146) forState:UIControlStateNormal];
        }
        [self.scrollView addSubview:btn];
        CGFloat w = [btn sizeThatFits:CGSizeMake(MAXFLOAT, 20)].width;
        [self.buttonWiths addObject:@(w)];
        
        btn.frame = CGRectMake(contentW, 6 + StatusBarHeight, w, 50);
        
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [tempArr addObject:btn];
        
        contentW = contentW + centerSpacing + w;
    }
    self.buttons = [tempArr copy];
    self.scrollView.contentSize = CGSizeMake(contentW , 50);
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = color(137, 137, 137, 0.5);
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    self.toplineView = [UIView new];
    self.toplineView.backgroundColor = color(137, 137, 137, 0.5);
    [self addSubview:self.toplineView];
    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)clickBtn:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(clickButtonAtIndex:)]) {
        [self.delegate clickButtonAtIndex:btn.tag];
    }
    self.selectedTag = btn.tag;
}


- (void)setSelectedTag:(NSInteger)selectedTag {
    
    UIButton *aButton = self.buttons[selectedTag];
    UIButton *bButton = self.buttons[self.selectedTag];
    [bButton setTitleColor:UnselectdeColor forState:(UIControlStateNormal)];
    [bButton.titleLabel setFont:UnselectdeFont];
    [aButton setTitleColor:SelectdeTitleColor forState:(UIControlStateNormal)];
    [aButton.titleLabel setFont:SelectdeTitleFont];
    
    _selectedTag = selectedTag;
    
    __block CGFloat Offset = CGRectGetMaxX(aButton.frame);
    
    CGFloat centerX = Offset - [self.buttonWiths[selectedTag] floatValue]/2.0;
    if (centerX >= 0.5*ScreenWidth && (self.scrollView.contentSize.width - centerX >= 0.5*ScreenWidth)) {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.contentOffset = CGPointMake(centerX - 0.5*ScreenWidth, 0);
        }];
    }
    else  if (centerX >= 0.5*ScreenWidth && (self.scrollView.contentSize.width - centerX < 0.5*ScreenWidth) && self.scrollView.contentSize.width > ScreenWidth){
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width - ScreenWidth, 0);
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
}
-(void)dealloc {
    self.delegate = nil;
}


-(NSMutableArray *)buttonWiths {
    if (!_buttonWiths) {
        _buttonWiths = [NSMutableArray array];
    }
    return _buttonWiths;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.image = [UIImage imageNamed:@"navBgv"];
    }
    return _imgView;
}

@end
