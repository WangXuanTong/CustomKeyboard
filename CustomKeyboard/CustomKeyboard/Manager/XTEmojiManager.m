//
//  XTEmojiManager.m
//  CustomKeyboard
//
//  Created by Tong on 2017/7/4.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "XTEmojiManager.h"

#import "NSBundle+XTEmojiRecources.h"

NSInteger const kOnePageEmojiCount = 20;

NSString *const kXTDefaultUserIdentifier = @"DefaultUser";  // 默认用户标识符

@interface XTEmojiManager ()

@property (nonatomic, strong) NSMutableArray *recentlyEmojiList;    // 最近使用的表情

@property (nonatomic, copy) NSString *recentlyEmojiListCachePath;   // 最近使用表情保存路径

@end

@implementation XTEmojiManager

#pragma mark - Init And Dealloc

+ (XTEmojiManager *)sharedManager
{
    static XTEmojiManager *emojiManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojiManager = [[XTEmojiManager alloc] init];
    });
    
    return emojiManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self beginToLoadEmojiPackages];
    }
    return self;
}


#pragma mark - Event Response



#pragma mark - NSNotification Response



#pragma mark - Public Events


/**
 获取当前 section中表情的页数数量
 
 @param section 表情分组的小标
 @return 页数
 */
- (NSInteger)numberOfPagesInSection:(NSInteger)section
{
    if (section >= self.emojiPackages.count) {
        return 1;
    }
    XTEmojiPackageModel *packageModel = [self.emojiPackages objectAtIndex:section];
    if (!packageModel || packageModel.emojiDataList.count == 0) {
        return 1;
    }
    NSInteger number = (NSInteger)((packageModel.emojiDataList.count - 1) / kOnePageEmojiCount + 1);\
    return number;
}


/**
 获取对应 IndexPath 下的表情数组
 
 @param indexPath 当前的下标
 @return 表情信息数组
 */
- (NSArray *)emojiInfoAtIndexPath:(NSIndexPath *)indexPath
{
    XTEmojiPackageModel *packageModel = [self.emojiPackages objectAtIndex:indexPath.section];

    NSInteger location = indexPath.item * kOnePageEmojiCount;
    NSInteger length = kOnePageEmojiCount;
    // 判断是否越界
    if ((location + length) > packageModel.emojiDataList.count) {
        length = packageModel.emojiDataList.count - location;
    }
    
    NSRange range = NSMakeRange(location, length);
    
    return [packageModel.emojiDataList subarrayWithRange:range];
}

#pragma mark - Private Events

/**
 开始加载表情包
 */
- (void)beginToLoadEmojiPackages
{
    NSString *emojiPackagesPath = [[NSBundle XTEmojiRecourcesBundle] pathForResource:@"emojiPackages" ofType:@"plist"];
    
    NSArray *packages = [NSArray arrayWithContentsOfFile:emojiPackagesPath];
    
    for (NSDictionary *dict in packages) {
        
        XTEmojiPackageModel *packageModel = [[XTEmojiPackageModel alloc] initModelWithDictionary:dict];
        [self.emojiPackages addObject:packageModel];
    }
    
    [self beginToLoadRecentlyEmojiList];
}


/**
 开始加载本地数据
 */
- (void)beginToLoadRecentlyEmojiList
{
    NSData *data = [NSData dataWithContentsOfFile:self.recentlyEmojiListCachePath];
   
    if (data == nil) {
        return;
    }
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    NSMutableArray *recentArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        
        XTEmojiInfoModel *infoModel = [[XTEmojiInfoModel alloc] initModelWithDictionary:dict];
        [recentArray addObject:infoModel];
    }
    
    if (recentArray.count > 0) {
        [self.recentlyEmojiList addObjectsFromArray:recentArray];
    }
    [self updataRecentlyEmojiPackage];
}


/**
 添加表情到最近使用列表

 @param emojiInfo 最近使用表情
 */
- (void)addRecentUseEmoji:(XTEmojiInfoModel *)emojiInfo
{
    if ([self.recentlyEmojiList containsObject:emojiInfo]) {
        [self.recentlyEmojiList removeObject:emojiInfo];
    }
    
    [self.recentlyEmojiList insertObject:emojiInfo atIndex:0];
    
    /** 更新最近表情包 */
    [self updataRecentlyEmojiPackage];
    
    /** 保存最近表情包数据 */
    [self saveRecentlyEmojiListToLocal];
}


/**
 更新最近表情包
 */
- (void)updataRecentlyEmojiPackage
{
    NSInteger length = self.recentlyEmojiList.count < kOnePageEmojiCount ? self.recentlyEmojiList.count : kOnePageEmojiCount;
    self.emojiPackages[0].emojiDataList = [[self.recentlyEmojiList subarrayWithRange:NSMakeRange(0, length)] mutableCopy];
}

/**
 保存最近表情包数据
 */
- (void)saveRecentlyEmojiListToLocal
{
    NSMutableArray *jsonArray = [NSMutableArray array];
    
    for (XTEmojiInfoModel *infoModel in self.recentlyEmojiList) {
        [jsonArray addObject:infoModel.dictionary];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:nil];
    [data writeToFile:self.recentlyEmojiListCachePath atomically:YES];
}


#pragma mark - Setter and Getter

- (NSMutableArray<XTEmojiPackageModel *> *)emojiPackages
{
    if (!_emojiPackages) {
        _emojiPackages = [NSMutableArray array];
    }
    return _emojiPackages;
}

- (NSMutableArray *)recentlyEmojiList
{
    if (!_recentlyEmojiList) {
        _recentlyEmojiList = [NSMutableArray array];
    }
    return _recentlyEmojiList;
}

- (NSString *)recentlyEmojiListCachePath
{
    if (!_recentlyEmojiListCachePath) {
        
        NSString *directory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        
        directory = [directory stringByAppendingPathComponent:@"RecentlyEmojiList"];
        
        _recentlyEmojiListCachePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.recentlyEmojiList.json",self.userIdentifier]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:_recentlyEmojiListCachePath]) {
            
            if (![fileManager fileExistsAtPath:directory]) {

                if ([fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil]) {
                    
                    [fileManager createFileAtPath:_recentlyEmojiListCachePath contents:nil attributes:nil];
                }
            }
        }
    }
    return _recentlyEmojiListCachePath;
}

- (NSString *)userIdentifier
{
    if (!_userIdentifier) {
        _userIdentifier = kXTDefaultUserIdentifier;
    }
    return _userIdentifier;
}

@end
