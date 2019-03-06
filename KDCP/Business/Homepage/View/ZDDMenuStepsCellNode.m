//
//  ZDDMenuStepsCellNode.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuStepsCellNode.h"

@interface ZDDMenuStepsCellNode ()

@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;
@property (nonatomic, strong) ASInsetLayoutSpec *listSpec;
@property (nonatomic, strong) NSArray <ASNetworkImageNode *>*imageNodes;


@end


@implementation ZDDMenuStepsCellNode

- (instancetype)init {
    if (self = [super init]) {
        
        [self addTitleNode];
        [self addLineNode];
        [self addFoodsList];
        
        self.titleNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"烹饪步骤" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Medium" size:24]).lh_color([UIColor blackColor]);
        }];
        
        
    }
    return self;
}

- (void)clickImageNode:(ASNetworkImageNode *)imageNode {
    if ([self.delegate respondsToSelector:@selector(menuCellNode:didClickImageNode:clickIndex:)]) {
        [self.delegate menuCellNode:self didClickImageNode:self.imageNodes clickIndex:[self.imageNodes indexOfObject:imageNode]];
    }
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    
    ASStackLayoutSpec *titleAndDescSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:40 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[self.titleNode, self.listSpec]];
    
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
    NSMutableArray *tempImageArr = [NSMutableArray array];

    for (NSInteger i = 0; i < 8; i ++) {
        
        ASTextNode *stepNode = [ASTextNode new];
        stepNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:[NSString stringWithFormat:@"步骤 %ld", i] attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Medium" size:18]).lh_color([UIColor blackColor]);
        }];
        
        stepNode.style.minWidth = ASDimensionMake(ScreenWidth - 100);
        
        ASNetworkImageNode *imgNode = [[ASNetworkImageNode alloc] init];
        imgNode.contentMode = UIViewContentModeScaleAspectFill;
        imgNode.style.preferredSize = CGSizeMake(SCREENWIDTH, 250);
        imgNode.cornerRadius = 6;
        imgNode.URL = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1551806874788&di=5d3ce26cd3e61eb4f964b6cbf7ab7da7&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170110%2F55ea71c59dfc4d6ba7d4060b5cc38e90_th.jpeg"];
        [imgNode addTarget:self action:@selector(clickImageNode:) forControlEvents:ASControlNodeEventTouchUpInside];
        [tempImageArr addObject:imgNode];

        
        ASTextNode *detailLb = [ASTextNode new];
        detailLb.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"制豆腐将黄豆用水泡发，泡好后用清水洗净，换入清水20~25kg，用石磨磨成稀糊，再加入与稀糊同样多的温水拌匀，装入布袋内，用力把浆汁挤出，再在豆渣内兑入沸水拌匀后再挤，如此连续豆渣不沾手。豆浆已挤完时，撇去泡沫，将浆汁入锅用大火烧开，倒入缸内，加进石膏汁，边加边用木棍搅动，约搅15~20转后，可滴上少许水，如与浆混合，表示石膏汁不够，须再加进一些石膏汁再搅。如所滴入的水没有同浆混合，嫌麻烦的话，可以到市场上直接买回来" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:16]).lh_color(color(100, 100, 100, 1));
            
        }];
        
        ASStackLayoutSpec *topSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:25 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[stepNode, imgNode]];
        ASStackLayoutSpec *allSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:20 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[topSpec, detailLb]];

        [tempArr addObject:allSpec];
        
        [self addSubnode:stepNode];
        [self addSubnode:imgNode];
        [self addSubnode:detailLb];

    }
    
    
    ASStackLayoutSpec *allSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:25 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:tempArr.copy];
    
    self.listSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 20, 0, 20) child:allSpec];
    self.imageNodes = tempImageArr.copy;
    
}

- (void)dealloc {
    self.delegate = nil;
}

@end
