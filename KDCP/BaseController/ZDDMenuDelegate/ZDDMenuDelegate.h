//
//  ZDDMenuDelegate.h
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 binary. All rights reserved.
//

#ifndef ZDDMenuDelegate_h
#define ZDDMenuDelegate_h

@protocol ZDDMenuDelegate <NSObject>

@optional

- (void)menuCellNode:(ASCellNode *)node didClickImageNode:(NSArray <ASNetworkImageNode *> *)imageNodes clickIndex:(NSInteger)index;



@end













#endif /* ZDDMenuDelegate_h */
