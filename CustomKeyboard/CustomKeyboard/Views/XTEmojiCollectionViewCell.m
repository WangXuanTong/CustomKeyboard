//
//  XTEmojiCollectionViewCell.m
//  CustomKeyboard
//
//  Created by Tong on 2017/7/4.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "XTEmojiCollectionViewCell.h"

#import "XTEmojiManager.h"

#import "UIImage+XTEmojiImage.h"

#import "XTEmojiButton.h"

static const NSInteger emojiBaseTag = 2000; // Emoji 按钮Tag

static const NSInteger rowCount     = 3;    // 显示几行

static const NSInteger columnCount  = 7;    // 显示几列

static const NSInteger leftMargin   = 5;    // 左边距

static const NSInteger bottomMargin = 15;   // 下边距

@implementation XTEmojiCollectionViewCell

#pragma mark - --------------------------- Init And Dealloc ---------------------------

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        
        self.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:232 / 255.0 blue:232 / 255.0 alpha:1.0];
    }
    return self;
}

- (void)createUI
{
    
    CGFloat width   = ceil((self.bounds.size.width - leftMargin * 2) / columnCount);
    CGFloat height  = ceil((self.bounds.size.height - bottomMargin) / rowCount);
    
    for (NSInteger i = 0; i < kOnePageEmojiCount + 1 ; i++) {
        
        NSInteger row    = i / columnCount;
        NSInteger column = i % columnCount;
        
        CGRect rect = CGRectMake(leftMargin + column * width, row * height, width, height);
        
        XTEmojiButton *button = [[XTEmojiButton alloc] initEmojiButtonWithFrame:rect andTag:i+emojiBaseTag];
        [button addTarget:self action:@selector(emojiButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        if (i == kOnePageEmojiCount) {
            button.isDeleteButton = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateEmojiButtonFrame];
}

#pragma mark - --------------------------- Event Response ---------------------------

/**
 点击 Emoji 表情
 */
- (void)emojiButtonDidClick:(XTEmojiButton *)button
{
    if (self.emojiCellDelegate && [self.emojiCellDelegate respondsToSelector:@selector(emojiCollectionViewCellDidClickEmoji:isDeleteEmoji:)]) {
        
        NSInteger index = button.tag - emojiBaseTag;
        
        if (index >= self.emojiPackage.count) {
            
            if (button.isDeleteButton) {
                [self.emojiCellDelegate emojiCollectionViewCellDidClickEmoji:nil isDeleteEmoji:YES];
            }
            return;
        }
        XTEmojiInfoModel *infoModel = [self.emojiPackage objectAtIndex:index];
        [self.emojiCellDelegate emojiCollectionViewCellDidClickEmoji:infoModel isDeleteEmoji:NO];
    }
}

#pragma mark - --------------------------- Private Methods ---------------------------

/**
 更新表情按钮 Frame
 */
- (void)updateEmojiButtonFrame
{
    CGFloat width   = ceil((CGRectGetWidth(self.bounds) - leftMargin * 2) / columnCount);
    CGFloat height  = ceil((CGRectGetHeight(self.bounds) - bottomMargin) / rowCount);
    
    NSInteger i = 0;
    for (UIView *subView in self.contentView.subviews) {
        
        if ([subView isKindOfClass:[XTEmojiButton class]]) {
            
            NSInteger row    = i / columnCount;
            NSInteger column = i % columnCount;
            
            CGRect rect = CGRectMake(leftMargin + column * width, row * height, width, height);
            
            subView.frame = rect;
            
            i++;
        }
    }
}

#pragma mark - --------------------------- Setter and Getter---------------------------

- (void)setEmojiPackage:(NSArray<XTEmojiInfoModel *> *)emojiPackage
{
    _emojiPackage = emojiPackage;
    
    for (UIView *subView in self.contentView.subviews) {
        subView.hidden = YES;
    }

    self.contentView.subviews.lastObject.hidden = _emojiPackage.count > 0 ? NO : YES;
    
    NSInteger index = 0;
    for (XTEmojiInfoModel *infoModel in emojiPackage) {
        
        XTEmojiButton *button = [self.contentView viewWithTag:index + emojiBaseTag];
        button.emojiInfo = infoModel;
        
        index ++;
    }
}



@end
