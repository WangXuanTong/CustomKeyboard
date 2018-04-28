//
//  XTEmojiInfoModel.h
//  CustomKeyboard
//
//  Created by Tong on 2017/7/5.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTEmojiInfoModel : NSObject

/** 表情名称 */
@property (nonatomic, copy) NSString *emojiName;

/** 表情名称 */
@property (nonatomic, copy) NSString *emojiDesc;

/** 表情目录 */
@property (nonatomic, copy) NSString *emojiDirectory;

/** 表情路径 */
@property (nonatomic, copy) NSString *emojiPath;

/** 表情编码 */
@property (nonatomic, copy) NSString *emojiCode;

/** 表情使用次数 */
@property (nonatomic, assign) NSInteger useTimes;



/**
 初始化模型
 
 @param dictionary 传入的字典数据
 @return XTEmojiInfoModel
 */
- (instancetype)initModelWithDictionary:(NSDictionary *)dictionary;


/**
 保存使用的字典
 */
- (NSDictionary *)dictionary;


@end
