//
//  UITextView+XTEmoji.m
//  CustomKeyboard
//
//  Created by Tong on 2018/4/27.
//  Copyright © 2018年 Feng. All rights reserved.
//

#import "UITextView+XTEmoji.h"

#import "XTEmojiInfoModel.h"
#import "XTEmojiAttachment.h"
#import "UIImage+XTEmojiImage.h"

#import <objc/runtime.h>

static char kTextViewFinalStringKey;

@implementation UITextView (XTEmoji)

/**
 插入表情
 */
- (void)insertEmojiWithModel:(XTEmojiInfoModel *)emojiModel
{
    // 新建可变字符串
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
    
    // 添加之前的
    [mutableAttributedString appendAttributedString:self.attributedText];
    
    // 新建附件
    XTEmojiAttachment *attachment = [[XTEmojiAttachment alloc] init];
    
    // 新建图片
    UIImage *image = [UIImage getEmojiImageWithPath:emojiModel.emojiPath];
    
    // 设置附件
    attachment.image = image;
    
    // 记录模型
    attachment.emojiModel = emojiModel;
    
    // 设置大小
    attachment.bounds = CGRectMake(0, 0, self.font.lineHeight, self.font.lineHeight);
    
    // 新建附件对应的样式字符串
    NSAttributedString *attributedString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 插入表情附件
    [mutableAttributedString replaceCharactersInRange:self.selectedRange withAttributedString:attributedString];
    
    // 设置字体
    [mutableAttributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, mutableAttributedString.length)];
    
    // 设置光标的位置
    NSRange range = self.selectedRange;
    NSUInteger location = range.location + 1;
    NSUInteger length = 0;
    
    // 赋值
    self.attributedText = mutableAttributedString;
    
    self.selectedRange = NSMakeRange(location, length);
}

/**
 把表情属性字符串转成普通字符串
 
 @return 普通字符串
 */
- (NSString *)changeEmojiAttributedStringToNormalString
{
    
    NSAttributedString *attributeString = self.attributedText;
    
    __block NSUInteger index = 1;
    
    // 枚举出所有的附件字符串
    __block NSUInteger base = 0;
    
    NSMutableAttributedString *resutlAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:attributeString];
    
    [attributeString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        /**
         这里的转换规则根据自己的业务需求做转换
         */
        if (value && [value isKindOfClass:[XTEmojiAttachment class]]) {
            
            XTEmojiAttachment *tempAttachment = (XTEmojiAttachment *)value;
            
            if ([tempAttachment.emojiModel.emojiDirectory isEqualToString:@"lionface"]) {
                
                NSString *p = [NSString stringWithFormat:@"{:109_%@:}",tempAttachment.emojiModel.emojiName];
                
                [resutlAttributeString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:p];
                
                base += p.length - 1;
                
            } else if ([tempAttachment.emojiModel.emojiDirectory isEqualToString:@"yctface"]) {
                
                NSString *name = [tempAttachment.emojiModel.emojiName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
                
                NSString *p = [NSString stringWithFormat:@"[%@]",name];
                
                [resutlAttributeString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:p];
                base += p.length - 1;
            }
            
            index++;
        }
    }];
    
    NSLog(@"\n\n%@\n\n",resutlAttributeString.string);
    
    self.finalText = resutlAttributeString.string;
    
    return self.finalText;
}

- (NSString *)finalText
{
    return objc_getAssociatedObject(self, &kTextViewFinalStringKey);
}

- (void)setFinalText:(NSString *)finalText
{
    objc_setAssociatedObject(self, &kTextViewFinalStringKey, finalText, OBJC_ASSOCIATION_COPY);
}

@end








