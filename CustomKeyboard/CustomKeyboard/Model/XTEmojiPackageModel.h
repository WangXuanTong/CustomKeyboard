//
//  XTEmojiPackageModel.h
//  CustomKeyboard
//
//  Created by Tong on 2017/7/5.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XTEmojiInfoModel.h"

@interface XTEmojiPackageModel : NSObject

/** 表情包分组名称 */
@property (nonatomic, copy) NSString *sectionName;

/** 表情包图片名称 */
@property (nonatomic, copy) NSString *sectionImageName;

/** 表情包所在目录 */
@property (nonatomic, copy) NSString *sectionDirectory;

/** 表情包中表情 */
@property (nonatomic, strong) NSMutableArray <XTEmojiInfoModel *>*emojiDataList;


/**
 初始化模型

 @param dictionary 传入的字典数据
 @return XTEmojiPackageModel
 */
- (instancetype)initModelWithDictionary:(NSDictionary *)dictionary;

@end
