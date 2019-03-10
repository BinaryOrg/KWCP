//
//  FUCKNoteModel.h
//  KDCP
//
//  Created by ZDD on 2019/3/10.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUCKNoteModel : NSObject
/*
 "note_id": "note-510ab090-40c9-11e9-b876-2135cfa355b9",
 "content": "22222222222222",
 "picture_path": [
 "note/note-510ab090-40c9-11e9-b876-2135cfa355b9/upload_1ac3ac3b108605fe8316cd2feea3ef64.jpg"
 ],
 "create_date": 1551956900,
 "star_num": 0,
 "comment_num": 0,
 "is_star": false,
 "user": {
 "mobile_number": "18345157194",
 "user_name": "Cary",
 "user_id": "user-7a256a20-40c8-11e9-b876-2135cfa355b9",
 "gender": "m",
 "avater": "user/user-7a256a20-40c8-11e9-b876-2135cfa355b9/upload_b362efd884a097d21b012615764a4d9d.jpg",
 "create_date": 1551956539,
 "last_login_date": 1551956544
 }
 */
@property (nonatomic, strong) NSArray<NSString *> *picture_path;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger last_update_date;
@property (nonatomic, assign) NSInteger star_num;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, assign) BOOL is_star;
@property (nonatomic, strong) NSString *note_id;
@property (nonatomic, assign) NSInteger content_height;

@property (nonatomic, strong) GODUserModel *user;
@end

NS_ASSUME_NONNULL_END
