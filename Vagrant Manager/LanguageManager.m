//
//  LanguageManager.m
//  Vagrant Manager
//
//  Copyright (c) 2024. All rights reserved.
//

#import "LanguageManager.h"

@implementation LanguageManager {
    NSBundle *_languageBundle;
}

+ (LanguageManager*)sharedManager {
    static LanguageManager *manager;
    @synchronized(self) {
        if(manager == nil) {
            manager = [[LanguageManager alloc] init];
        }
    }
    return manager;
}

- (id)init {
    self = [super init];
    if(self) {
        [self loadLanguageBundle];
    }
    return self;
}

- (void)loadLanguageBundle {
    NSString *languageCode = [self getCurrentLanguage];
    NSString *path = [[NSBundle mainBundle] pathForResource:languageCode ofType:@"lproj"];
    if(path) {
        _languageBundle = [NSBundle bundleWithPath:path];
    } else {
        _languageBundle = [NSBundle mainBundle];
    }
}

- (NSArray*)getAvailableLanguages {
    return @[
        @{@"code": @"en", @"name": @"English"},
        @{@"code": @"zh-Hans", @"name": @"简体中文"}
    ];
}

- (NSString*)getCurrentLanguage {
    NSString *savedLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"appLanguage"];
    if(savedLanguage && [savedLanguage length] > 0) {
        return savedLanguage;
    }
    
    // 如果没有保存的语言，使用系统语言
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    if(preferredLanguages && [preferredLanguages count] > 0) {
        NSString *systemLanguage = [preferredLanguages objectAtIndex:0];
        if([systemLanguage hasPrefix:@"zh"]) {
            return @"zh-Hans";
        }
    }
    
    return @"en";
}

- (void)setLanguage:(NSString*)languageCode {
    [[NSUserDefaults standardUserDefaults] setObject:languageCode forKey:@"appLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadLanguageBundle];
    
    // 发送通知，通知其他组件语言已更改
    [[NSNotificationCenter defaultCenter] postNotificationName:@"vagrant-manager.language-changed" object:nil];
}

- (NSString*)localizedString:(NSString*)key {
    if(_languageBundle) {
        NSString *localized = [_languageBundle localizedStringForKey:key value:key table:nil];
        return localized;
    }
    return NSLocalizedString(key, nil);
}

@end

