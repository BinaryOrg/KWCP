//
//  ZDDPersonHeadTableViewCell.h
//  KDCP
//
//  Created by ZDD on 2019/3/9.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDDPersonHeadTableViewCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *avatarImageView;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *joinLabel;
@property (nonatomic ,strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *loginButton;

//unuse
@property (nonatomic, strong) UIButton *loginButton1;
@property (nonatomic, strong) UIButton *loginButton2;
@property (nonatomic, strong) UIButton *loginButton3;
@property (nonatomic, strong) UIButton *loginButton4;
@property (nonatomic ,strong) UILabel *nameLabel1;
@property (nonatomic ,strong) UILabel *nameLabel2;
@property (nonatomic ,strong) UILabel *nameLabel3;
@property (nonatomic ,strong) UILabel *nameLabel4;
@end

NS_ASSUME_NONNULL_END
