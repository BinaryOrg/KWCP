//
//  ZDDMenuFoodsListCellNode.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuFoodsListCellNode.h"

@interface ZDDMenuFoodsListCellNode ()

@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;
@property (nonatomic, strong) ASInsetLayoutSpec *listSpec;

@end




@implementation ZDDMenuFoodsListCellNode

- (instancetype)init {
    if (self = [super init]) {
        
        [self addTitleNode];
        [self addLineNode];
        [self addFoodsList];
        
        self.titleNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"准备食材" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Medium" size:24]).lh_color([UIColor blackColor]);
        }];
        
        
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    
    ASStackLayoutSpec *titleAndDescSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:20 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[self.titleNode, self.listSpec]];
    
    ASStackLayoutSpec *lineSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:25 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[titleAndDescSpec, self.lineNode]];

    return lineSpec;
    
}

- (void)addTitleNode {
    self.titleNode = [ASTextNode new];
    self.titleNode.textContainerInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self addSubnode:self.titleNode];
}

- (void)addLineNode {
    self.lineNode = [ASDisplayNode new];
    self.lineNode.backgroundColor = GODColor(238, 238, 238);
    [self.lineNode setLayerBacked:YES];
    [self addSubnode:self.lineNode];
}

- (void)addFoodsList {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 6; i ++) {
        
        ASTextNode *nameTN = [ASTextNode new];
        nameTN.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"豆腐" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Medium" size:18]).lh_color(GODColor(38, 79, 180));
        }];
        nameTN.style.minWidth = ASDimensionMake(ScreenWidth - 150);
        ASTextNode *countTN = [ASTextNode new];
        countTN.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"100g" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:18]).lh_color(GODColor(137, 137, 137));
        }];
        ASStackLayoutSpec *subSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[nameTN, countTN]];
        [tempArr addObject:subSpec];
        
        [self addSubnode:nameTN];
        [self addSubnode:countTN];
        
    }
    
    ASStackLayoutSpec *allSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:25 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:tempArr.copy];
    
    self.listSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 20, 0, 20) child:allSpec];
    
}

@end
