//
//  ViewController.m
//  CustomKeyboard
//
//  Created by Tong on 2017/7/4.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "ViewController.h"

#import "XTEmojiInputView.h"
#import "UITextView+XTEmoji.h"
#import "XTEmojiAttachment.h"

@interface ViewController ()

@property (nonatomic, strong) XTEmojiInputView *inputView;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 表情键盘
    XTEmojiInputView *inputView = [[XTEmojiInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 258, self.view.frame.size.width, 258)];
    self.inputView = inputView;

    __weak ViewController *weakSelf = self;
    
    self.inputView.emojiInputResultBlock = ^(XTEmojiInfoModel *infoModel, BOOL isDeleteEmoji) {

        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        if (isDeleteEmoji) {
            
            // 删除表情
            if (strongSelf.textView != nil) {
                [strongSelf.textView deleteBackward];
            }
            
        } else {
            
            // 添加表情
            [strongSelf.textView insertEmojiWithModel:infoModel];
        }
    };


    self.inputView.emojiToolBarSendBlock = ^{
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.textView changeEmojiAttributedStringToNormalString];
        
        NSLog(@"\n\n 11111点击发送文本：\n%@\n\n",strongSelf.textView.finalText);
    };
    
    
    // 创建视图
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64, self.view.bounds.size.width - 20, 64)];
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 0.5;
    textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:textView];
    self.textView = textView;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 44);
    button.center = self.view.center;
    [button setTitle:@"点击切换表情键盘" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeInputView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)changeInputView:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        
        [button setTitle:@"点击切换普通键盘" forState:UIControlStateNormal];

        self.textView.inputView = self.inputView;
        [self.textView resignFirstResponder];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
        });
        
    } else {
        
        [button setTitle:@"点击切换表情键盘" forState:UIControlStateNormal];

        self.textView.inputView = nil;
        [self.textView resignFirstResponder];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
        });
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.inputView.frame = CGRectMake(0, self.view.frame.size.height - 258, self.view.frame.size.width, 258);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
