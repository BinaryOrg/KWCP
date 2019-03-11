//
//  ZDDHomePageController.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDHomePageController.h"
#import "ZDDCategoryTagView.h"
#import "ZDDMenuListController.h"

#import "UINavigationController+FDFullscreenPopGesture.h"




@interface ZDDHomePageController ()<ZDDCategoryTagViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) ZDDCategoryTagView *changeTypeView;
@property (nonatomic, strong) NSArray *dataArrray;

@property (nonatomic, strong) NSArray <ZDDMenuListController *>*controllerArray;
@property (nonatomic, strong) UIPageViewController *pageController;


@property (nonatomic, strong)  UIButton *reloadBtn;

@end

@implementation ZDDHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setReloadBtn];
    [self loadData];
}

- (void)setReloadBtn {
    
    self.title = @"菜谱大全";
    self.fd_prefersNavigationBarHidden = YES;

    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:reloadBtn];
    [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [reloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reloadBtn addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
    reloadBtn.layer.cornerRadius = 5;
    reloadBtn.layer.masksToBounds = YES;
    reloadBtn.layer.borderColor = [UIColor grayColor].CGColor;
    reloadBtn.layer.borderWidth = 0.5;
    self.reloadBtn = reloadBtn;
    
}

- (void)loadData {
    
   
}
- (void)setupUI {
    
    
    [self.view addSubview:self.changeTypeView];
    [self.changeTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(55 + StatusBarHeight);
    }];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.changeTypeView.mas_bottom);
        make.bottom.mas_equalTo(-SafeTabBarHeight);
    }];
    
    [self.pageController setViewControllers:@[self.controllerArray.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}



#pragma mark - UIPageViewControllerDataSource / UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSInteger index = [self.controllerArray indexOfObject:pageViewController.viewControllers.firstObject];
    [self.changeTypeView setSelectedTag:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.controllerArray indexOfObject:viewController];
    if (index < self.controllerArray.count-1 && self.controllerArray.count) {
        return [self.controllerArray objectAtIndex:index+1];
    }
    return nil;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    NSInteger index = [self.controllerArray indexOfObject:viewController];
    if (index>0 && self.controllerArray.count) {
        return [self.controllerArray objectAtIndex:index-1];
    }
    return nil;
}

- (void)clickButtonAtIndex:(NSInteger)index {
    NSInteger currentIndex = [self.controllerArray indexOfObject:self.pageController.viewControllers.firstObject];
    [self.pageController setViewControllers:@[[self.controllerArray objectAtIndex:index]] direction:index>currentIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}



//- (ZDDCategoryTagView *)changeTypeView {
//    if (!_changeTypeView) {
//        _changeTypeView = [[ZDDCategoryTagView alloc] initWithTitles:self.titleArray];
//        _changeTypeView.delegate = self;
//    }
//    return _changeTypeView;
//}



- (UIPageViewController *)pageController {
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.delegate = self;
        _pageController.dataSource = self;
    }
    return _pageController;
}

- (NSArray<ZDDMenuListController *> *)controllerArray {
    if (!_controllerArray) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:self.dataArrray.count];
        for (NSInteger i = 0; i < self.dataArrray.count; i ++) {
            ZDDMenuModel *model = self.dataArrray[i];
            ZDDMenuListController *vc = [[ZDDMenuListController alloc] init];
            vc.title = model.title;
            [tempArr addObject:vc];
        }
        _controllerArray = tempArr.copy;
    }
    return _controllerArray;
}

@end
