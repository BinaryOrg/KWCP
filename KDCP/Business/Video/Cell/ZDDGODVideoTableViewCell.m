//
//  ZDDGODVideoTableViewCell.m
//  KDCP
//
//  Created by 张冬冬 on 2019/3/15.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDGODVideoTableViewCell.h"

@implementation ZDDGODVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, SCREENWIDTH - 50, SCREENWIDTH - 50)];
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.bgImageView];
        self.bgImageView.userInteractionEnabled = YES;
        
        self.like = [TTAnimationButton buttonWithType:UIButtonTypeCustom];
        //ic_messages_like_20x20_
        self.like.frame = CGRectMake(WIDTH(self.bgImageView) - 40, HEIGHT(self.bgImageView) - 40, 25, 25);
        [self.like setImage:[UIImage imageNamed:@"ic_messages_like_20x20_"] forState:UIControlStateNormal];
        self.like.imageSelectedColor = [UIColor zdd_redColor];
        //        _imgButton.enableCustomImageSize = YES;
        self.like.explosionRate = 100;
        [self.bgImageView addSubview:self.like];
        self.bgImageView.layer.cornerRadius = 5;
        self.bgImageView.layer.masksToBounds = YES;
        self.bgImageView.tag = 100;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


@end
