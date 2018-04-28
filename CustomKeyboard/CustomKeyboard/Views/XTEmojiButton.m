//
//  XTEmojiButton.m
//  CustomKeyboard
//
//  Created by Tong on 2017/7/6.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "XTEmojiButton.h"

#import "UIImage+XTEmojiImage.h"

@implementation XTEmojiButton


/**
 初始化 Emoji 表情按钮
 
 @param frame Frame
 @param tag Tag
 @return XTEmojiButton
 */
- (instancetype)initEmojiButtonWithFrame:(CGRect)frame andTag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = tag;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return self;
}


- (void)setEmojiInfo:(XTEmojiInfoModel *)emojiInfo
{
    _emojiInfo = emojiInfo;
    
    self.hidden = emojiInfo == nil ? YES : NO;
    
    [self setImage:[UIImage getEmojiImageWithPath:emojiInfo.emojiPath] forState:UIControlStateNormal];
}


- (void)setIsDeleteButton:(BOOL)isDeleteButton
{
    _isDeleteButton = isDeleteButton;
    
    [self setImage:[UIImage getToolBarImageWithName:@"face_delete"] forState:UIControlStateNormal];
    [self setImage:[UIImage getToolBarImageWithName:@"face_delete"] forState:UIControlStateHighlighted];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
