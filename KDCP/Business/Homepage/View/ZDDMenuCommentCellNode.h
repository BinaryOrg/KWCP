//
//  ZDDMenuCommentCellNode.h
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "FUCKNoteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZDDMenuCommentCellNode : ASCellNode
//@property (nonatomic, strong) FUCKNoteModel *comment;
- (instancetype)initWithComment:(FUCKNoteModel *)comment;
@end

NS_ASSUME_NONNULL_END
