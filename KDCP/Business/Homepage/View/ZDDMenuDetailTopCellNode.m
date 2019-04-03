//
//  ZDDMenuDetailHeaderView.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuDetailTopCellNode.h"
#import <SJVideoPlayer/SJVideoPlayer.h>

@interface ZDDMenuDetailTopCellNode ()

@property (nonatomic, strong) ASNetworkImageNode *topImageNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *describNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;
@property (nonatomic, strong) ABCFuckModel *fuckModel;

@end

@implementation ZDDMenuDetailTopCellNode


- (instancetype)initWithModel:(ABCFuckModel *)model {
    if (self = [super init]) {
        self.nodeModel = model;
        self.fuckModel = model;
        [self addTopImageNode];
        [self addTitleNode];
        [self addDescribNode];
        [self addLineNode];
//        self.topImageNode.defaultImage = [UIImage imageNamed:@"freshFood"];
        self.topImageNode.URL = [NSURL URLWithString:model.cover_picture];
        self.titleNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:model.recipe_name attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Medium" size:24]).lh_color([UIColor blackColor]);
        }];
        self.describNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:model.desc attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:16]).lh_color(color(137, 137, 137, 1));

        }];
//
       
        
    }
    return self;
}

- (void)clickImageNode {
    if ([self.delegate respondsToSelector:@selector(menuCellNode:didClickImageNode:clickIndex:)]) {
        [self.delegate menuCellNode:self didClickImageNode:@[self.topImageNode] clickIndex:0];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *imgAndTitleSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:20 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[self.topImageNode, self.titleNode]];
    
    ASStackLayoutSpec *subTitleSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:20 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[imgAndTitleSpec, self.describNode]];

    
    ASStackLayoutSpec *titleAndDescSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:25 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[subTitleSpec, self.lineNode]];
    
    return titleAndDescSpec;
    
}

- (void)addTopImageNode {
    self.topImageNode = [[ASNetworkImageNode alloc] init];
    self.topImageNode.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageNode.style.preferredSize = CGSizeMake(SCREENWIDTH, 300);
    [self.topImageNode addTarget:self action:@selector(clickImageNode) forControlEvents:ASControlNodeEventTouchUpInside];
    [self addSubnode:self.topImageNode];
}

- (void)addTitleNode {
    self.titleNode = [ASTextNode new];
    self.titleNode.textContainerInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self addSubnode:self.titleNode];
}

- (void)addDescribNode {
    self.describNode = [ASTextNode new];
    self.describNode.textContainerInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self addSubnode:self.describNode];
}

- (void)addLineNode {
    self.lineNode = [ASDisplayNode new];
    self.lineNode.backgroundColor = GODColor(238, 238, 238);
    [self.lineNode setLayerBacked:YES];
    [self addSubnode:self.lineNode];
}

- (void)dealloc {
    self.delegate = nil;
}

@end
