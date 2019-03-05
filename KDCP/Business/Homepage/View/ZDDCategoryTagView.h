//
//  ZDDCategoryTagView.h
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZDDCategoryTagViewDelegate <NSObject>

- (void)clickButtonAtIndex:(NSInteger)index;

@end
@interface ZDDCategoryTagView : UIView
@property (nonatomic, weak) id <ZDDCategoryTagViewDelegate> delegate;
- (instancetype)initWithTitles:(NSArray *)titles;
@property (nonatomic, assign) NSInteger selectedTag;



@end

