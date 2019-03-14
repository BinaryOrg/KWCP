//
//  ZDDmenuCollectView.h
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTAnimationButton/TTAnimationButton.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZDDmenuCollectView : UIView

/** <#class#> */
@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, strong) TTAnimationButton *imgButton;
@end

NS_ASSUME_NONNULL_END
