//
//  ZDDMenuOpenCommentCellNode.m
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 KWCP. All rights reserved.
//

#import "ZDDMenuOpenCommentCellNode.h"

@interface ZDDMenuOpenCommentCellNode ()

/** <#class#> */
@property (nonatomic, strong) ASTextNode *titleNode;

@end


@implementation ZDDMenuOpenCommentCellNode

- (instancetype)initWithCount:(NSInteger)count {
    
    if (self = [super init]) {
        self.titleNode = [ASTextNode new];
        self.titleNode.borderWidth = 0.5f;
        self.titleNode.textContainerInset = UIEdgeInsetsMake(20, 0, 20, 0);
        self.titleNode.borderColor = color(137, 137, 137, 0.5).CGColor;
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentCenter;
        self.titleNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:[NSString stringWithFormat:@"查看评论 (%ld)", count] attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont systemFontOfSize:18]).lh_color(GODColor(137, 137, 137)).lh_paraStyle(paraStyle);
        }];
        [self addSubnode:self.titleNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 20, 10, 40) child:self.titleNode];
}

@end
