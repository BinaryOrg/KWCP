//
//  ZDDFuckPersonLogoutTableViewCell.m
//  KDCP
//
//  Created by ZDD on 2019/3/9.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDFuckPersonLogoutTableViewCell.h"
#import "UIColor+ZDDColor.h"
@implementation ZDDFuckPersonLogoutTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.funcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 46)];
        self.funcLabel.text = @"退出登录";
        self.funcLabel.textColor = [UIColor zdd_redColor];
        self.funcLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.funcLabel];
    }
    return self;
}

@end
