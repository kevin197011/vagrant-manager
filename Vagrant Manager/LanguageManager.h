//
//  LanguageManager.h
//  Vagrant Manager
//
//  Copyright (c) 2024. All rights reserved.
//

#import <Foundation/Foundation.h>

// Macro to use LanguageManager for localization
#define VMLocalizedString(key) [[LanguageManager sharedManager] localizedString:key]

@interface LanguageManager : NSObject

+ (LanguageManager*)sharedManager;

- (NSArray*)getAvailableLanguages;
- (NSString*)getCurrentLanguage;
- (void)setLanguage:(NSString*)languageCode;
- (NSString*)localizedString:(NSString*)key;

@end

