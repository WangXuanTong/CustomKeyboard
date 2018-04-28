//
//  XTEmojiInfoModel.m
//  CustomKeyboard
//
//  Created by Tong on 2017/7/5.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "XTEmojiInfoModel.h"

@implementation XTEmojiInfoModel


/**
 初始化模型
 
 @param dictionary 传入的字典数据
 @return XTEmojiInfoModel
 */
- (instancetype)initModelWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
        
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

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


- (NSString *)emojiPath
{
    return [NSString stringWithFormat:@"%@/%@",self.emojiDirectory, self.emojiName];
}

- (NSDictionary *)dictionary
{
    NSArray *keys = @[@"emojiName", @"emojiDesc", @"emojiDirectory", @"emojiCode", @"useTimes"];
    return [self dictionaryWithValuesForKeys:keys];
}

@end
