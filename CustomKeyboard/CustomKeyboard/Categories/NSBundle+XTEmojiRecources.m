//
//  NSBundle+XTEmojiRecources.m
//  CustomKeyboard
//
//  Created by Tong on 2017/7/5.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "NSBundle+XTEmojiRecources.h"

@implementation NSBundle (XTEmojiRecources)

+ (instancetype)XTEmojiRecourcesBundle
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"XTEmojiResources" ofType:@"bundle"];

    return [NSBundle bundleWithPath:bundlePath];
}

@end
