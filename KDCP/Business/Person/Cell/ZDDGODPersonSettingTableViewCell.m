//
//  ZDDGODPersonSettingTableViewCell.m
//  KDCP
//
//  Created by ZDD on 2019/3/9.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDGODPersonSettingTableViewCell.h"

@implementation ZDDGODPersonSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.funcLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH - 100, 46)];
        [self.contentView addSubview:self.funcLabel];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end
