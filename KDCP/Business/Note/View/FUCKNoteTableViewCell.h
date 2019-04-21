//
//  FUCKNoteTableViewCell.h
//  KDCP
//
//  Created by ZDD on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUCKNoteTableViewCell : UITableViewCell
@property (nonatomic ,strong) UILabel *dateLabel;
@property (nonatomic ,strong) UILabel *summaryLabel;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *dotButton;

@end

NS_ASSUME_NONNULL_END
