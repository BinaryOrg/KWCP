//
//  ZDDMenuDetailHeaderView.m
//  KDCP
//
//  Created by Maker on 2019/3/5.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDMenuDetailTopCellNode.h"

@interface ZDDMenuDetailTopCellNode ()

@property (nonatomic, strong) ASNetworkImageNode *topImageNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *describNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;


@end




@implementation ZDDMenuDetailTopCellNode

- (instancetype)init {
    if (self = [super init]) {
        
        [self addTopImageNode];
        [self addTitleNode];
        [self addDescribNode];
        [self addLineNode];
        
        self.topImageNode.URL = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1551803268793&di=69c16b9cc75051867ac62471f5747aec&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201805%2F07%2F20180507155441_LjQ8L.jpeg"];
        self.titleNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"臭豆腐" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Medium" size:24]).lh_color([UIColor blackColor]);
        }];
        self.describNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"臭豆腐，中国传统特色小吃，在各地的制作方式、食用方法均有相当大的差异，有北方和南方的不同类型，臭豆腐在南方又称臭干子。其名虽俗气、却外陋内秀、平中见奇、源远流长，是一种极具特色的中华传统小吃，古老而传统，令人欲罢不能。制作材料有大豆、豆豉、纯碱等。 在中国以及世界各地的制作方式和食用方式均存在地区上的差异，其味道也差异甚大，但具有“闻起来臭、吃起来香”的特点。南京、长沙的臭豆腐干相当闻名，台湾、浙江、上海、北京、武汉、玉林等地的臭豆腐也颇有名气。天津街头多为南京臭豆腐，为灰白豆腐块油炸成金黄色，臭味很淡。武汉街头的臭豆腐多以“长沙臭豆腐”为招牌，但制作方式并不相同，是用铁板浇油煎，中不空并且为淡黄色" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont fontWithName:@"PingFangSC-Light" size:16]).lh_color(color(137, 137, 137, 1));

        }];

        
    }
    return self;
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

@end
