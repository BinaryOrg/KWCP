//
//  ZDDMenuStepsCellNode.h
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuDelegate.h"
#import "ABCFuckModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDDMenuStepsCellNode : ASCellNode

@property (nonatomic, weak) id <ZDDMenuDelegate> delegate;

- (instancetype)initWithModel:(ABCFuckModel *)model;


@end

NS_ASSUME_NONNULL_END
