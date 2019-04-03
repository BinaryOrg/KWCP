//
//  ZDDMenuStepsCellNode.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuStepsCellNode.h"
#import "ABCFuckDetail2.h"

@interface ZDDMenuStepsCellNode ()

@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;
@property (nonatomic, strong) ASInsetLayoutSpec *listSpec;
@property (nonatomic, strong) NSArray <ASNetworkImageNode *>*imageNodes;
@property (nonatomic, strong) ABCFuckModel *model;

@end


@implementation ZDDMenuStepsCellNode

- (instancetype)initWithModel:(ABCFuckModel *)model {
    if (self = [super init]) {
        self.model = model;
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

    for (NSInteger i = 0; i < self.model.cooking_step.count; i ++) {
        ABCFuckDetail2 *stepMode = self.model.cooking_step[i];
        ASTextNode *stepNode = [ASTextNode new];
        stepNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:[NSString stringWithFormat:@"步骤 %ld", i + 1] attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Medium" size:18]).lh_color([UIColor blackColor]);
        }];
        
        stepNode.style.minWidth = ASDimensionMake(ScreenWidth - 100);
        
        ASNetworkImageNode *imgNode = nil;
        if (stepMode.url.length) {
            imgNode = [[ASNetworkImageNode alloc] init];
            imgNode.contentMode = UIViewContentModeScaleAspectFill;
            imgNode.style.preferredSize = CGSizeMake(SCREENWIDTH, 250);
            imgNode.cornerRadius = 6;
            imgNode.URL = [NSURL URLWithString:stepMode.url];
            [imgNode addTarget:self action:@selector(clickImageNode:) forControlEvents:ASControlNodeEventTouchUpInside];
            [tempImageArr addObject:imgNode];
            [self addSubnode:imgNode];
        }
        
        ASTextNode *detailLb = [ASTextNode new];
        detailLb.attributedText = [NSMutableAttributedString lh_makeAttributedString:stepMode.word attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:16]).lh_color(color(100, 100, 100, 1));
            
        }];
        
        ASStackLayoutSpec *topSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
        if (stepMode.url.length) {
            topSpec.spacing = 25;
            topSpec.children = @[stepNode, imgNode];
        }else {
            topSpec.children = @[stepNode];
        }
        
        ASStackLayoutSpec *allSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:20 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[topSpec, detailLb]];

        [tempArr addObject:allSpec];
        
        [self addSubnode:stepNode];
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
