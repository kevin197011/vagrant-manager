//
//  AboutWindowController.m
//  Vagrant Manager
//
//  Copyright (c) 2014 Lanayo. All rights reserved.
//

#import "AboutWindow.h"
#import "Environment.h"
#import "LanguageManager.h"

@interface AboutWindow ()

@end

@implementation AboutWindow

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    
    // Listen for language changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:@"vagrant-manager.language-changed" object:nil];

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self updateContent];
}

- (void)updateContent {
    // Update window title
    self.window.title = VMLocalizedString(@"About Vagrant Manager");
    
    BOOL isDarkMode = [[[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"] isEqualToString:@"Dark"];
    
    NSString *styles = @"";
    
    if (isDarkMode) {
        styles = @"<style>body { color:#fff; } a { color: #66f; }</style>";
    }

    NSString *str = [NSString stringWithFormat:@"%@<div style=\"text-align:center;font-family:Arial;font-size:13px\">Copyright &copy;2025 kk<br><br>Vagrant Manager {VERSION}<br><br>%@<br><a href=\"{URL}\">{URL}</a><br><br>%@<br><a href=\"{GITHUB_URL}\">{GITHUB_URL}</a></div>", styles, VMLocalizedString(@"For more information visit:"), VMLocalizedString(@"or check us out on GitHub:")];
    str = [str stringByReplacingOccurrencesOfString:@"{VERSION}" withString:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]];
    str = [str stringByReplacingOccurrencesOfString:@"{URL}" withString:[[Environment sharedInstance] aboutURL]];
    str = [str stringByReplacingOccurrencesOfString:@"{GITHUB_URL}" withString:[[Environment sharedInstance] githubURL]];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    
    self.webView.policyDelegate = self;
    [self.webView setDrawsBackground:NO];
    [self.webView.mainFrame loadHTMLString:str baseURL:nil];
}

- (void)languageChanged:(NSNotification*)notification {
    // Update content when language changes
    if([self.window isVisible]) {
        [self updateContent];
    }
}

- (void)webView:(WebView*)webView decidePolicyForNavigationAction:(NSDictionary*)actionInformation request:(NSURLRequest*)request frame:(WebFrame*)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
    NSString *host = [[request URL] host];
    if(host) {
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    } else {
        [listener use];
    }
}

- (void)use {
}

- (void)download {
}

- (void)ignore {
}

@end
