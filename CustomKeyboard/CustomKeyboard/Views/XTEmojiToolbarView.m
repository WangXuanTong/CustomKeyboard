//
//  XTEmojiToolbarView.m
//  CustomKeyboard
//
//  Created by Tong on 2017/7/4.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "XTEmojiToolbarView.h"

#import "XTEmojiManager.h"

#import "UIImage+XTEmojiImage.h"

static const NSInteger kXTEmojiToolbarTagBaseValue = 1000;

@interface XTEmojiToolbarView ()

@property (nonatomic, strong) UIToolbar *toolBar;       // 底部按钮

@property (nonatomic, strong) UIButton *sendButton;     // 发送按钮

@property (nonatomic, weak) UIButton *selectedButton;   // 选中按钮

@end

@implementation XTEmojiToolbarView

#pragma mark - --------------------------- Init And Dealloc ---------------------------

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectedSectionIndex = 1;

        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self toolBar];
    
    [self setToolbarInfoWithArray:[XTEmojiManager sharedManager].emojiPackages];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.toolBar.frame = self.bounds;
    self.sendButton.frame = CGRectMake(CGRectGetWidth(self.toolBar.bounds) - 75, 5, 60, 30);
}

#pragma mark - --------------------------- Event Response ---------------------------

/**
 点击 toolBar
 */
- (void)clickToolBarButton:(UIButton *)button
{
    if (button == self.selectedButton) {
        return;
    }
    
    if (self.emojiToolbarViewDelegate && [self.emojiToolbarViewDelegate respondsToSelector:@selector(emojiToolbarViewDidSelectAtSectionIndex:)]) {

        [self resetSelectedButtonAndState:button];
        [self.emojiToolbarViewDelegate emojiToolbarViewDidSelectAtSectionIndex:button.tag - kXTEmojiToolbarTagBaseValue];
    }
}


#pragma mark - --------------------------- Public Events ---------------------------

/**
 设置 toolBar 数据
 */
- (void)setToolbarInfoWithArray:(NSArray <XTEmojiPackageModel *>*)dataArray
{
    if (!dataArray || dataArray.count == 0) {
        return;
    }
    
    NSMutableArray *items = [NSMutableArray array];
    NSInteger i = 0;
    for (XTEmojiPackageModel *model in dataArray) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, self.bounds.size.height);
        [button setImage:[UIImage getToolBarImageWithName:[NSString stringWithFormat:@"face_%@",model.sectionImageName]] forState:UIControlStateNormal];
        [button setImage:[UIImage getToolBarImageWithName:[NSString stringWithFormat:@"face_%@_s",model.sectionImageName]] forState:UIControlStateSelected];
        button.tag = i + kXTEmojiToolbarTagBaseValue;
        [button addTarget:self action:@selector(clickToolBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        [items addObject:item];
        
        if (i == self.selectedSectionIndex) {
            button.selected = YES;
            self.selectedButton = button;
        }
        
        i++;
    }
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:spaceItem];
    
    self.toolBar.items = items;
}


/**
 点击发送按钮
 */
- (void)buttonAction
{
    if (self.emojiToolbarViewDelegate && [self.emojiToolbarViewDelegate respondsToSelector:@selector(emojiToolbarViewDidClickSendButton)]) {
        [self.emojiToolbarViewDelegate emojiToolbarViewDidClickSendButton];
    }
}

#pragma mark - --------------------------- Private Events ---------------------------

/**
 重置选中按钮和其状态

 @param button 选中按钮
 */
- (void)resetSelectedButtonAndState:(UIButton *)button
{
    button.selected = !button.selected;
    self.selectedButton.selected = !self.selectedButton.selected;
    self.selectedButton = button;
}


#pragma mark - --------------------------- Setter and Getter ---------------------------

/**
 设置选中的分组下标
 */
- (void)setSelectedSectionIndex:(NSInteger)selectedSectionIndex
{
    _selectedSectionIndex = selectedSectionIndex;
    
    UIButton *selectedButton = [self viewWithTag:(selectedSectionIndex + kXTEmojiToolbarTagBaseValue)];
    
    [self resetSelectedButtonAndState:selectedButton];
}


/**
 设置是否显示发送按钮
 */
- (void)setNeedShowSendButton:(BOOL)needShowSendButton
{
    _needShowSendButton = needShowSendButton;
    
    self.sendButton.hidden = !needShowSendButton;
}


/**
 底部按钮
 */
- (UIToolbar *)toolBar
{
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc] initWithFrame:self.bounds];
        _toolBar.translucent = YES;
        _toolBar.backgroundColor = [UIColor whiteColor];
        [_toolBar setBackgroundImage:[[UIImage alloc]init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [self addSubview:_toolBar];
    }
    return _toolBar;
}


/**
 发送按钮
 */
- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(CGRectGetWidth(self.toolBar.bounds) - 75, 5, 60, 30);
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sendButton.layer.cornerRadius = 3.0;
        _sendButton.layer.masksToBounds = YES;
        _sendButton.showsTouchWhenHighlighted = YES;
        [_sendButton setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[UIColor colorWithRed:30 / 255.0 green:138 / 255.0  blue:200 / 255.0  alpha:1.0]];
        [_sendButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.toolBar addSubview:_sendButton];
    }
    return _sendButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
