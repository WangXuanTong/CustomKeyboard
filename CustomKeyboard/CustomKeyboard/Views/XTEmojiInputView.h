//
//  XTEmojiInputView.h
//  CustomKeyboard
//
//  Created by Tong on 2017/7/4.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTEmojiInfoModel.h"

typedef void(^emojiInputResultBlock)(XTEmojiInfoModel *infoModel, BOOL isDeleteEmoji);

typedef void(^emojiToolBarSendBlock)(void);

@interface XTEmojiInputView : UIView

/** 点击表情回调 */
@property (nonatomic, copy) emojiInputResultBlock emojiInputResultBlock;

/** 点击发送按钮回调 */
@property (nonatomic, copy) emojiToolBarSendBlock emojiToolBarSendBlock;

@end
