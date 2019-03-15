//
//  ABCFuckModel.h
//  KDCP
//
//  Created by 张冬冬 on 2019/3/11.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface ABCFuckModel : NSObject
@property (nonatomic, strong) NSString *recipe_id;
@property (nonatomic, strong) NSString *recipe_name;
@property (nonatomic, strong) NSString *cover_picture;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, assign) NSInteger collection_num;
@property (nonatomic, strong) NSArray *food_list;
@property (nonatomic, strong) NSArray *cooking_step;
@property (nonatomic, assign) BOOL is_collect;

@property (nonatomic, strong) NSString *vedio;
@property (nonatomic, strong) NSString *spend_time;
@property (nonatomic, strong) NSString *difficult;
/*
 "recipe_id": "00023802-3f6c-11e9-935c-3cf862dae089",
 "recipe_name": "胖头鱼炖豆腐",
 "cover_picture": "https://cp1.douguo.com/upload/caiku/c/a/1/690x390_ca6b38e25a4e232fc806fa162878c4b1.jpeg",
 "description": "昨天买了一整条胖头鱼，昨天做了剁椒鱼头，今天剩下的鱼身就拿来炖豆腐",
 "food_list": [
 {
 "food": "胖头鱼身",
 "amount": "一个"
 },
 {
 "food": "老豆腐",
 "amount": "500g"
 },
 {
 "food": "葱",
 "amount": "半颗"
 },
 {
 "food": "姜",
 "amount": "五片"
 },
 {
 "food": "大蒜",
 "amount": "六瓣"
 },
 {
 "food": "糖",
 "amount": "适量"
 },
 {
 "food": "盐",
 "amount": "适量"
 },
 {
 "food": "料酒",
 "amount": "少许"
 },
 {
 "food": "食用油",
 "amount": "适量"
 },
 {
 "food": "胡椒粉",
 "amount": "适量"
 },
 {
 "food": "老抽",
 "amount": ""
 },
 {
 "food": "蚝油",
 "amount": ""
 },
 {
 "food": "剁椒酱",
 "amount": ""
 }
 ],
 "cooking_step": [
 {
 "url": "https://cp1.douguo.com/upload/caiku/8/2/f/200_8217a1fb8bbd9b06c8d935b54679488f.jpeg",
 "word": "胖头鱼身洗净，切块，备用"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/d/e/1/200_de1c73a8b934a6ad8ff9db307c2e1eb1.jpeg",
 "word": "葱姜蒜切好备用"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/a/a/3/200_aaf372bc681fc118427748180c453763.jpeg",
 "word": "锅中放入油烧热，放入鱼块，两面煎微黄"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/b/5/2/200_b540dcbdfa346161c36cf475b38fa342.jpeg",
 "word": "放入一勺白糖"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/d/6/b/200_d64e3544addb27c15f0d388a89402ecb.jpeg",
 "word": "放入葱姜蒜"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/9/a/7/200_9afb61495d1716f458017a6e84237057.jpeg",
 "word": "放入适量料酒，老抽，蚝油"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/3/c/5/200_3c682260a0f9729c5716d4cc1d086295.jpeg",
 "word": "倒入清水，没过鱼"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/7/a/7/200_7afc83eeb7e79e3df0ff1389ff916af7.jpeg",
 "word": "烤豆腐切块"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/f/e/8/200_fe7ad17da4ab320f84e4fefd5d627be8.jpeg",
 "word": "等沸腾后放入豆腐"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/7/7/6/200_77b74ad8716b571a51a04cc2d2666016.jpeg",
 "word": "放入一点剁椒，盖上锅盖，大火焖煮至汤汁浓稠"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/6/7/f/200_67f129d3ac50b0fc330d0b31daf6494f.jpeg",
 "word": "如图，放入葱花，鸡精"
 },
 {
 "url": "https://cp1.douguo.com/upload/caiku/6/2/e/200_621419f7196ae97c94c05a26febf1cfe.jpeg",
 "word": "盛盘，味道很赞"
 }
 ],
 "tips": "",
 "tag": "胖头鱼",
 "comment_num": 0,
 "collection_num": 1,
 "is_collect": true
 */
@end

NS_ASSUME_NONNULL_END
