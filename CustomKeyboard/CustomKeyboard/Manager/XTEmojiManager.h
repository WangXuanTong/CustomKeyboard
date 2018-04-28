//
//  XTEmojiManager.h
//  CustomKeyboard
//
//  Created by Tong on 2017/7/4.
//  Copyright © 2017年 Feng. All rights reserved.
//


/**
 表情管理
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "XTEmojiPackageModel.h"
#import "XTEmojiInfoModel.h"

extern NSInteger const kOnePageEmojiCount;  // 每页的表情数量

@interface XTEmojiManager : NSObject

+ (XTEmojiManager *)sharedManager;

/** 表情包数组 */
@property (nonatomic, strong) NSMutableArray <XTEmojiPackageModel *> *emojiPackages;

/** 用户标识符，用于区分最近使用表情 */
@property (nonatomic, copy) NSString *userIdentifier;


/**
 获取当前 section中表情的页数数量

 @param section 表情分组的小标
 @return 页数
 */
- (NSInteger)numberOfPagesInSection:(NSInteger)section;


/**
 获取对应 IndexPath 下的表情数组

 @param indexPath 当前的下标
 @return 表情信息数组
 */
- (NSArray *)emojiInfoAtIndexPath:(NSIndexPath *)indexPath;


/**
 添加表情到最近使用列表
 
 @param emojiInfo 最近使用表情
 */
- (void)addRecentUseEmoji:(XTEmojiInfoModel *)emojiInfo;


@end
