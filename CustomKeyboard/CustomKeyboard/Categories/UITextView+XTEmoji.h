//
//  UITextView+XTEmoji.h
//  CustomKeyboard
//
//  Created by Tong on 2018/4/27.
//  Copyright © 2018年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTEmojiInfoModel;

@interface UITextView (XTEmoji)

/**
 装换后的最终字符串，需先调用（changeEmojiAttributedStringToNormalString）方法
 */
@property (nonatomic, copy) NSString *finalText;


/**
 插入表情
 */
- (void)insertEmojiWithModel:(XTEmojiInfoModel *)emojiModel;


/**
 把表情属性字符串转成普通字符串

 @return 普通字符串
 */
- (NSString *)changeEmojiAttributedStringToNormalString;

@end
