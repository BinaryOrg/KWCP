//
//  ABCFuckModel.m
//  KDCP
//
//  Created by 张冬冬 on 2019/3/11.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ABCFuckModel.h"
#import "ABCFuckDetail1.h"
#import "ABCFuckDetail2.h"
@implementation ABCFuckModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"food_list" : [ABCFuckDetail1 class], @"cooking_step": [ABCFuckDetail2 class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}
@end
