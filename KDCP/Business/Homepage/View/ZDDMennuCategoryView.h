//
//  ZDDMennuCategoryView.h
//  KDCP
//
//  Created by Maker on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDDMenuModel.h"


@protocol ZDDMennuCategoryViewDelegate<NSObject>

@optional
- (void)clickCategory:(NSString *)category indexPath:(NSIndexPath *)indexPath;

@end
NS_ASSUME_NONNULL_BEGIN

@interface ZDDMennuCategoryView : UIView

@property (nonatomic, strong) NSArray <ZDDMenuModel *>*dataArr;
@property (nonatomic, weak) id<ZDDMennuCategoryViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
