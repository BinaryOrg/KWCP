//
//  GODFuckDetailViewController.h
//  KDCP
//
//  Created by ZDD on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUCKNoteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GODFuckDetailViewController : UIViewController

@property (nonatomic, strong) FUCKNoteModel *note;
@property (nonatomic, assign) NSInteger flag;
@end

NS_ASSUME_NONNULL_END
