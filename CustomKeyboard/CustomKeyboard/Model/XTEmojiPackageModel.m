//
//  XTEmojiPackageModel.m
//  CustomKeyboard
//
//  Created by Tong on 2017/7/5.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "XTEmojiPackageModel.h"

#import "NSBundle+XTEmojiRecources.h"

@implementation XTEmojiPackageModel


/**
 初始化模型
 
 @param dictionary 传入的字典数据
 @return XTEmojiPackageModel
 */
- (instancetype)initModelWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {

        [self setValuesForKeysWithDictionary:dictionary];
        
        _emojiDataList = [NSMutableArray array];
        
        /** 判断是否存在表情目录，存在则加载表情 */
        if (_sectionDirectory != nil) {
            
            NSString *fileName = [NSString stringWithFormat:@"%@/info.plist", _sectionDirectory];
            NSString *path = [[NSBundle XTEmojiRecourcesBundle] pathForResource:fileName ofType:nil];
            NSArray *array = [NSArray arrayWithContentsOfFile:path];
            
            for (NSDictionary *dict in array) {
                XTEmojiInfoModel *infoModel = [[XTEmojiInfoModel alloc] initModelWithDictionary:dict];
                infoModel.emojiDirectory = _sectionDirectory;
                [_emojiDataList addObject:infoModel];
            }
        }
    }
    
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
        value = [format stringFromNumber:value];
    }
    
    if (value == nil) {
        return;
    }
    
    [super setValue:value forKey:key];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{}


@end
