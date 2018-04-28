//
//  XTEmojiButton.h
//  CustomKeyboard
//
//  Created by Tong on 2017/7/6.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTEmojiInfoModel.h"

@interface XTEmojiButton : UIButton

/** 表情信息 */
@property (nonatomic, strong) XTEmojiInfoModel *emojiInfo;

/** 是否删除按钮 */
@property (nonatomic, assign) BOOL isDeleteButton;


/**
 初始化 Emoji 表情按钮

 @param frame Frame
 @param tag Tag
 @return XTEmojiButton
 */
- (instancetype)initEmojiButtonWithFrame:(CGRect)frame andTag:(NSInteger)tag;

@end
