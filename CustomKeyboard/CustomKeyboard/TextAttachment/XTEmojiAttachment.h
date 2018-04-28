//
//  XTEmojiAttachment.h
//  CustomKeyboard
//
//  Created by Tong on 2018/4/27.
//  Copyright © 2018年 Feng. All rights reserved.
//

/**
 表情附件
 */
#import <UIKit/UIKit.h>

@class XTEmojiInfoModel;

@interface XTEmojiAttachment : NSTextAttachment

/** 表情模型 */
@property (nonatomic, strong) XTEmojiInfoModel *emojiModel;

@end
