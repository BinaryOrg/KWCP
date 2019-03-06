//
//  ZDDMenuDetailHeaderView.h
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDDMenuDetailTopCellNode : ASCellNode

@property (nonatomic, weak) id <ZDDMenuDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
