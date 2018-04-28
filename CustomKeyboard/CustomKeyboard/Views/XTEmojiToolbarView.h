//
//  XTEmojiToolbarView.h
//  CustomKeyboard
//
//  Created by Tong on 2017/7/4.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XTEmojiToolbarViewDelegate;

@interface XTEmojiToolbarView : UIView

@property (nonatomic, weak) id <XTEmojiToolbarViewDelegate>emojiToolbarViewDelegate;

/** 选中的分组下标（默认为0 */
@property (nonatomic, assign) NSInteger selectedSectionIndex;

/** 显示发送按钮（默认不显示） */
@property (nonatomic, assign) BOOL needShowSendButton;

@end

@protocol XTEmojiToolbarViewDelegate <NSObject>


/**
 表情工具栏选中下标

 @param sectionIndex 选中的分组
 */
- (void)emojiToolbarViewDidSelectAtSectionIndex:(NSInteger)sectionIndex;


/**
 点击发送按钮
 */
- (void)emojiToolbarViewDidClickSendButton;

@end
