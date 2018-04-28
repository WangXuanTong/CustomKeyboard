//
//  XTEmojiCollectionViewCell.h
//  CustomKeyboard
//
//  Created by Tong on 2017/7/4.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XTEmojiInfoModel.h"

@protocol XTEmojiCollectionViewCellDelegate;

@interface XTEmojiCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <XTEmojiCollectionViewCellDelegate> emojiCellDelegate;

@property (nonatomic, strong) NSArray <XTEmojiInfoModel *> *emojiPackage;

@end

@protocol XTEmojiCollectionViewCellDelegate <NSObject>

- (void)emojiCollectionViewCellDidClickEmoji:(XTEmojiInfoModel *)emojiInfo isDeleteEmoji:(BOOL)isDeleteEmoji;

@end
