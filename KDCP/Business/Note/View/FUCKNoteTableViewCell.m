//
//  FUCKNoteTableViewCell.m
//  KDCP
//
//  Created by ZDD on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import "FUCKNoteTableViewCell.h"

#import "UIColor+ZDDColor.h"
@implementation FUCKNoteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 15, 1.5, 20)];
        lineLabel.backgroundColor = [UIColor zdd_yellowColor];
        [self.contentView addSubview:lineLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(self.avatarImageView.frame) + 5, 300, 40)];
        [self.contentView addSubview:self.dateLabel];
        self.dateLabel.font = [UIFont systemFontOfSize:17];
        self.dateLabel.textColor = [UIColor zdd_grayColor];
        
        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.dateLabel.frame), SCREENWIDTH - 60, ((SCREENWIDTH - 80)/2))];
        self.imageView1.layer.cornerRadius = 7;
        self.imageView1.layer.masksToBounds = YES;
        self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView1];
        
        
        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.imageView1.frame) + 5, SCREENWIDTH - 60, 50)];
        self.summaryLabel.numberOfLines = 0;
        self.summaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self.contentView addSubview:self.summaryLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView1.userInteractionEnabled = YES;
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.summaryLabel.frame) + 5, 20, 20)];
        self.avatarImageView.layer.cornerRadius = 3;
        self.avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(self.summaryLabel.frame) + 5, 100, 20)];
        self.nameLabel.textColor = [UIColor zdd_grayColor];
//        self.nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.nameLabel];
        
        
        self.commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 135, CGRectGetMaxY(self.summaryLabel.frame) + 5, 20, 20)];
        self.commentImageView.image = [UIImage imageNamed:@"ic_messages_comment_20x20_"];
        [self.contentView addSubview:self.commentImageView];
        self.commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentImageView.frame)+5, CGRectGetMaxY(self.summaryLabel.frame) + 5, 30, 20)];
        [self.contentView addSubview:self.commentCountLabel];
        self.likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentCountLabel.frame) + 5, CGRectGetMaxY(self.summaryLabel.frame) + 5, 20, 20)];
        self.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
        [self.contentView addSubview:self.likeImageView];
        self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeImageView.frame)+5, CGRectGetMaxY(self.summaryLabel.frame) + 5, 30, 20)];
        [self.contentView addSubview:self.likeCountLabel];
        
        self.likeCountLabel.textColor = [UIColor zdd_grayColor];
        self.commentCountLabel.textColor = [UIColor zdd_grayColor];
        
        self.likeCountLabel.userInteractionEnabled = YES;
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.likeButton.frame = CGRectMake(CGRectGetMinX(self.likeImageView.frame), CGRectGetMaxY(self.summaryLabel.frame), 50, 40);
        [self.contentView addSubview:self.likeButton];
    }
    return self;
}

@end
