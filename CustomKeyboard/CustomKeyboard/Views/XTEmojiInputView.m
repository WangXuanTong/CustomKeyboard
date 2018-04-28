//
//  XTEmojiInputView.m
//  CustomKeyboard
//
//  Created by Tong on 2017/7/4.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "XTEmojiInputView.h"

#import "XTEmojiToolbarView.h"

#import "XTEmojiCollectionViewCell.h"

#import "XTEmojiManager.h"

static NSString *const XTEmojiCollectionViewCellIdentifier = @"XTEmojiCollectionViewCellIdentifier";

@interface XTEmojiInputView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XTEmojiToolbarViewDelegate, XTEmojiCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *emojiCollectionView;    // emoji 表情

@property (nonatomic, strong) XTEmojiToolbarView *toolbarView;          // 底部工具栏

@property (nonatomic, strong) UIPageControl *pageControl;               // 分页控件

@property (nonatomic, assign) CGSize itemSize;

@end

@implementation XTEmojiInputView

#pragma mark - --------------------------- Init And Dealloc ---------------------------

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self emojiCollectionView];
    [self toolbarView];
    [self pageControl];

    [self updatePageControlWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    
    [self.emojiCollectionView reloadData];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.itemSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 40);
    
    self.emojiCollectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 40);
    self.toolbarView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 40, CGRectGetWidth(self.bounds), 40);
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 55, CGRectGetWidth(self.bounds), 15);
    
    [self.emojiCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:self.toolbarView.selectedSectionIndex] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];

}

#pragma mark - --------------------------- Event Response ---------------------------


#pragma mark - --------------------------- Delegate Response ---------------------------

#pragma mark - UICollectionViewDelegateFlowLayout

/**
 设置每个cell大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemSize;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

/**
 表情包的分组数量
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [XTEmojiManager sharedManager].emojiPackages.count;
}


/**
 每组表情包的数量
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[XTEmojiManager sharedManager] numberOfPagesInSection:section];
}


/**
 对应的表情
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XTEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XTEmojiCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.emojiPackage = [[XTEmojiManager sharedManager] emojiInfoAtIndexPath:indexPath];
    cell.emojiCellDelegate = self;
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint center = scrollView.center;
    center.x += scrollView.contentOffset.x;

    NSArray *indexPaths = [self.emojiCollectionView indexPathsForVisibleItems];

    NSIndexPath *targetPath = nil;
    for (NSIndexPath *indexPath in indexPaths) {
        UICollectionViewCell *cell = [self.emojiCollectionView cellForItemAtIndexPath:indexPath];
        if (CGRectContainsPoint(cell.frame, center)) {
            targetPath = indexPath;
            break;
        }
    }
    
    if (targetPath != nil) {
        
        [self updatePageControlWithIndexPath:targetPath];
        
        if (self.toolbarView.selectedSectionIndex != targetPath.section) {
            self.toolbarView.selectedSectionIndex = targetPath.section;
        }
    }
}


#pragma mark - XTEmojiToolbarViewDelegate - 点击表情工具栏

- (void)emojiToolbarViewDidSelectAtSectionIndex:(NSInteger)sectionIndex
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
    
    [self.emojiCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [self updatePageControlWithIndexPath:indexPath];
    
    self.toolbarView.selectedSectionIndex = sectionIndex;
}

- (void)emojiToolbarViewDidClickSendButton
{
    if (self.emojiToolBarSendBlock) {
        self.emojiToolBarSendBlock();
    }
}

#pragma mark - XTEmojiCollectionViewCellDelegate - 点击表情

- (void)emojiCollectionViewCellDidClickEmoji:(XTEmojiInfoModel *)emojiInfo isDeleteEmoji:(BOOL)isDeleteEmoji
{
    if (self.emojiInputResultBlock) {
        self.emojiInputResultBlock(emojiInfo, isDeleteEmoji);
    }
    
    if (emojiInfo != nil) {
        
        [[XTEmojiManager sharedManager] addRecentUseEmoji:emojiInfo];
        [self.emojiCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    }
}

#pragma mark - --------------------------- Private Events ---------------------------

/**
 更新分页控制器
 */
- (void)updatePageControlWithIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.numberOfPages = [[XTEmojiManager sharedManager] numberOfPagesInSection:indexPath.section];
    self.pageControl.currentPage = indexPath.item;
}


#pragma mark - --------------------------- Setter and Getter --------------------------- 

- (UICollectionView *)emojiCollectionView
{
    if (!_emojiCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _emojiCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 40) collectionViewLayout:flowLayout];
        _emojiCollectionView.delegate = self;
        _emojiCollectionView.dataSource = self;
        _emojiCollectionView.alwaysBounceHorizontal = YES;
        _emojiCollectionView.showsHorizontalScrollIndicator = NO;
        _emojiCollectionView.backgroundColor = [UIColor clearColor];
        _emojiCollectionView.pagingEnabled = YES;
        _emojiCollectionView.bounces = NO;
        
        [self addSubview:_emojiCollectionView];
        
        [_emojiCollectionView registerClass:[XTEmojiCollectionViewCell class] forCellWithReuseIdentifier:XTEmojiCollectionViewCellIdentifier];
    }
    return _emojiCollectionView;
}


/**
 底部工具栏
 */
- (XTEmojiToolbarView *)toolbarView
{
    if (!_toolbarView) {
        _toolbarView = [[XTEmojiToolbarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 40, CGRectGetWidth(self.bounds), 40)];
        _toolbarView.emojiToolbarViewDelegate = self;
        [self addSubview:_toolbarView];
    }
    return _toolbarView;
}


/**
 分页工具
 */
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 55, CGRectGetWidth(self.bounds), 15)];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
       
        [self addSubview:_pageControl];
    }
    return _pageControl;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
