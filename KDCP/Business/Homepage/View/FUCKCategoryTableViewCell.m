//
//  FUCKCategoryTableViewCell.m
//  KDCP
//
//  Created by 张冬冬 on 2019/3/13.
//  Copyright © 2019 binary. All rights reserved.
//

#import "FUCKCategoryTableViewCell.h"
#import "UIColor+CustomColors.h"

@interface FUCKCategoryTableViewCell ()
@property (nonatomic, strong) UIView *yellowView;
@end

@implementation FUCKCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel.textColor = [UIColor colorWithRed:51 green:51 blue:51];
        self.nameLabel.highlightedTextColor = theme.selectTabColor;
        [self.contentView addSubview:self.nameLabel];
        
        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 55)];
        
        self.yellowView.backgroundColor = theme.selectTabColor;
        [self.contentView addSubview:self.yellowView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithRed:245 green:245 blue:245];
    self.highlighted = selected;
    self.nameLabel.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
