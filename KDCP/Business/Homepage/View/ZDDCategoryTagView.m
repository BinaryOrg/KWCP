//
//  ZDDCategoryTagView.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDCategoryTagView.h"

#define SelectdeTitleColor GODColor(53, 64, 72)
#define SelectdeTitleFont [UIFont systemFontOfSize:14]
#define UnselectdeColor GODColor(146, 146, 146)
#define UnselectdeFont [UIFont systemFontOfSize:14]
#define  centerSpacing  44.0f
#define  leftSpacing  20

@interface ZDDCategoryTagView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *buttons;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIView *scrollLine;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *buttonWiths;

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
    
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, 50);
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:self.titles.count];
    CGFloat contentW = leftSpacing;
    for (int i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:title forState:UIControlStateNormal];
        if (i == self.selectedTag) {
            [btn setTitleColor:GODColor(53, 64,72) forState:UIControlStateNormal];
        }else {
            [btn setTitleColor:GODColor(146, 146, 146) forState:UIControlStateNormal];
        }
        [self.scrollView addSubview:btn];
        CGFloat w = [btn sizeThatFits:CGSizeMake(MAXFLOAT, 20)].width;
        [self.buttonWiths addObject:@(w)];
        
        btn.frame = CGRectMake(contentW, 0, w, 50);
        
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [tempArr addObject:btn];
        
        contentW = contentW + centerSpacing + w;
    }
    self.buttons = [tempArr copy];
    self.scrollView.contentSize = CGSizeMake(contentW , 50);
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [UIColor colorWithRed:137 green:137 blue:137 alpha:1];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
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
@end
