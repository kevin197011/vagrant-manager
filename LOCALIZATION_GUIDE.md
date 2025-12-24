# 本地化功能实现指南

## 已实现的功能

### 1. 语言管理器 (LanguageManager)
- `LanguageManager.h` / `LanguageManager.m` - 语言管理单例类
- 支持动态切换语言
- 自动检测系统语言
- 保存用户语言偏好

### 2. 偏好设置窗口更新
- 在 `PreferencesWindow` 中添加了语言选择器
- 用户可以在偏好设置中选择语言
- 切换语言后提示用户重启应用

### 3. 本地化文件
- `zh-Hans.lproj/InfoPlist.strings` - 中文本地化信息
- `zh-Hans.lproj/Localizable.strings` - 中文本地化字符串

## 需要在 Xcode 中完成的步骤

### 1. 添加新文件到项目

1. 打开 Xcode 项目
2. 在项目导航器中，右键点击 "Vagrant Manager" 文件夹
3. 选择 "Add Files to 'Vagrant Manager'..."
4. 添加以下文件：
   - `LanguageManager.h`
   - `LanguageManager.m`
   - `zh-Hans.lproj/` 文件夹（包含其中的所有文件）

### 2. 在 PreferencesWindow.xib 中添加语言选择器

1. 打开 `PreferencesWindow.xib`
2. 在 Interface Builder 中：
   - 添加一个 `NSPopUpButton` 控件
   - 设置 Outlet 连接到 `languagePopUpButton`
   - 设置 Action 连接到 `languagePopUpButtonClicked:`
   - 添加标签 "Language" 或 "语言"

### 3. 配置本地化支持

1. 在 Xcode 项目设置中：
   - 选择项目 Target
   - 进入 "Info" 标签
   - 在 "Localizations" 部分，确保包含：
     - English (en)
     - Chinese (Simplified) (zh-Hans)

2. 确保 `Localizable.strings` 文件被正确本地化：
   - 选择 `zh-Hans.lproj/Localizable.strings`
   - 在 File Inspector 中，确保 "Localize..." 选项已启用

## 使用方法

### 在代码中使用本地化字符串

```objc
#import "LanguageManager.h"

// 获取本地化字符串
NSString *localized = [[LanguageManager sharedManager] localizedString:@"Preferences..."];

// 或者使用 NSLocalizedString（会自动使用 LanguageManager）
NSString *text = NSLocalizedString(@"Preferences...", nil);
```

### 切换语言

```objc
// 切换到中文
[[LanguageManager sharedManager] setLanguage:@"zh-Hans"];

// 切换到英文
[[LanguageManager sharedManager] setLanguage:@"en"];
```

## 添加更多本地化字符串

在 `zh-Hans.lproj/Localizable.strings` 中添加新的键值对：

```
"Key" = "中文翻译";
```

然后在代码中使用：

```objc
NSString *text = [[LanguageManager sharedManager] localizedString:@"Key"];
```

## 注意事项

1. **重启应用**：语言切换后需要重启应用才能完全生效
2. **菜单重建**：语言更改时会自动重建菜单
3. **系统语言检测**：首次启动时会自动检测系统语言

## 扩展支持

要添加更多语言：

1. 创建新的 `.lproj` 文件夹（如 `zh-Hant.lproj` 用于繁体中文）
2. 在其中创建 `Localizable.strings` 文件
3. 在 `LanguageManager.m` 的 `getAvailableLanguages` 方法中添加新语言
4. 在 Xcode 项目设置中添加新的本地化

## 相关文件

- `LanguageManager.h` / `LanguageManager.m` - 语言管理器
- `PreferencesWindow.h` / `PreferencesWindow.m` - 偏好设置窗口
- `AppDelegate.m` - 应用委托（初始化语言管理器）
- `zh-Hans.lproj/` - 中文本地化文件

