//
//  ABCFuckCollectionTableViewCell.h
//  KDCP
//
//  Created by 张冬冬 on 2019/3/11.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCFuckCollectionTableViewCell : UITableViewCell
@property (nonatomic ,strong) UILabel *dateLabel;
@property (nonatomic ,strong) UILabel *summaryLabel;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UIImageView *collectImageView;
@property (nonatomic, strong) UILabel *collectCountLabel;
@property (nonatomic, strong) UIButton *collectButton;

@end

NS_ASSUME_NONNULL_END
