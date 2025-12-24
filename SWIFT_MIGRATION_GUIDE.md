# Swift 迁移指南

## 📊 项目现状分析

### 当前状态
- **语言**: Objective-C
- **文件数量**: 约 35 对 .h/.m 文件（70 个文件）
- **框架**: Cocoa/AppKit (macOS)
- **依赖管理**: CocoaPods (Sparkle)
- **最低系统版本**: macOS 11.0+

### 代码规模估算
- 核心类: ~35 个
- 平均每个类: 100-300 行代码
- 总代码量: 约 5,000-10,000 行

## ✅ 迁移可行性

### 技术可行性：**完全可行**

1. **Swift 与 Objective-C 互操作**
   - ✅ Swift 可以直接调用 Objective-C 代码
   - ✅ Objective-C 可以调用 Swift 代码（通过桥接头文件）
   - ✅ 支持混合项目，可以逐步迁移

2. **框架支持**
   - ✅ AppKit 完全支持 Swift
   - ✅ CocoaPods 支持 Swift 项目
   - ✅ Sparkle 框架支持 Swift

3. **Xcode 支持**
   - ✅ Xcode 原生支持混合项目
   - ✅ 自动生成桥接头文件
   - ✅ 无缝编译和调试

## 🎯 迁移策略

### 方案一：渐进式迁移（推荐）⭐

**优点**：
- 风险低，可以逐步验证
- 不影响现有功能
- 可以边迁移边测试
- 团队可以逐步学习 Swift

**步骤**：

#### 阶段 1：准备工作（1-2 天）
1. 在 Xcode 中启用 Swift 支持
2. 创建桥接头文件（Bridging Header）
3. 配置 Swift 编译设置
4. 添加 Swift 文件到项目

#### 阶段 2：迁移工具类（1 周）
优先迁移简单的工具类，建立信心：
- `LanguageManager` ✅ (已部分完成)
- `Util`
- `Environment`
- `VersionComparison`
- `PasswordHelper`

#### 阶段 3：迁移数据模型（1 周）
- `Bookmark`
- `CustomCommand`
- `CustomProvider`
- `VagrantInstance`
- `VagrantMachine`

#### 阶段 4：迁移业务逻辑（1-2 周）
- `VagrantManager`
- `BookmarkManager`
- `CustomCommandManager`
- `VagrantGlobalStatusScanner`

#### 阶段 5：迁移 UI 层（1-2 周）
- `AppDelegate`
- `NativeMenu`
- `NativeMenuItem`
- `PreferencesWindow`
- 其他 Window Controllers

#### 阶段 6：清理和优化（1 周）
- 移除所有 Objective-C 文件
- 优化 Swift 代码
- 更新文档

### 方案二：完全重写（不推荐）

**缺点**：
- 工作量大（2-3 个月）
- 风险高
- 需要完全停止新功能开发
- 测试工作量大

## 📝 迁移示例

### 示例 1：LanguageManager (Objective-C → Swift)

**Objective-C 版本**：
```objective-c
@interface LanguageManager : NSObject
+ (LanguageManager*)sharedManager;
- (NSString*)localizedString:(NSString*)key;
@end
```

**Swift 版本**：
```swift
class LanguageManager {
    static let shared = LanguageManager()
    
    private var languageBundle: Bundle?
    
    private init() {
        loadLanguageBundle()
    }
    
    func localizedString(_ key: String) -> String {
        if let bundle = languageBundle {
            return bundle.localizedString(forKey: key, value: key, table: nil)
        }
        return NSLocalizedString(key, comment: "")
    }
    
    private func loadLanguageBundle() {
        let languageCode = getCurrentLanguage()
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            languageBundle = bundle
        } else {
            languageBundle = Bundle.main
        }
    }
    
    func getCurrentLanguage() -> String {
        if let savedLanguage = UserDefaults.standard.string(forKey: "appLanguage"),
           !savedLanguage.isEmpty {
            return savedLanguage
        }
        
        if let systemLanguage = Locale.preferredLanguages.first,
           systemLanguage.hasPrefix("zh") {
            return "zh-Hans"
        }
        
        return "en"
    }
}

// 全局函数替代宏
func VMLocalizedString(_ key: String) -> String {
    return LanguageManager.shared.localizedString(key)
}
```

### 示例 2：单例模式迁移

**Objective-C**：
```objective-c
+ (VagrantManager*)sharedManager {
    static VagrantManager *manager;
    @synchronized(self) {
        if(manager == nil) {
            manager = [[VagrantManager alloc] init];
        }
    }
    return manager;
}
```

**Swift**：
```swift
class VagrantManager {
    static let shared = VagrantManager()
    
    private init() {
        // 初始化代码
    }
}
```

## 🔧 迁移步骤详解

### 步骤 1：启用 Swift 支持

1. 在 Xcode 中打开项目
2. 选择 Target → Build Settings
3. 搜索 "Swift Language Version"，设置为 Swift 5.x
4. 添加 Swift 文件到项目（Xcode 会自动创建桥接头文件）

### 步骤 2：创建桥接头文件

如果 Xcode 没有自动创建，手动创建 `Vagrant Manager-Bridging-Header.h`：

```objective-c
//
//  Vagrant Manager-Bridging-Header.h
//  Vagrant Manager
//

#import <Cocoa/Cocoa.h>
#import <Sparkle/Sparkle.h>

// 保留需要从 Swift 访问的 Objective-C 头文件
#import "MenuDelegate.h"
#import "VirtualMachineServiceProvider.h"
```

### 步骤 3：迁移单个类

1. 创建新的 Swift 文件（如 `LanguageManager.swift`）
2. 将 Objective-C 代码转换为 Swift
3. 更新所有引用该类的代码
4. 测试功能是否正常
5. 删除旧的 .h/.m 文件

### 步骤 4：处理宏定义

Objective-C 的宏需要转换为 Swift 函数：

```swift
// Objective-C 宏
#define VMLocalizedString(key) [[LanguageManager sharedManager] localizedString:key]

// Swift 函数
func VMLocalizedString(_ key: String) -> String {
    return LanguageManager.shared.localizedString(key)
}
```

## ⚠️ 注意事项

### 1. 类型转换
- Objective-C 的 `id` → Swift 的 `Any`
- `NSString*` → `String`
- `NSArray*` → `[Type]`
- `NSDictionary*` → `[Key: Value]`

### 2. 可选值处理
- Objective-C 的 `nil` → Swift 的 `nil`（可选类型）
- 需要仔细处理可选值解包

### 3. 内存管理
- Objective-C: MRC/ARC
- Swift: ARC（自动管理，更安全）

### 4. 协议和委托
- Objective-C 协议 → Swift 协议
- 委托模式在 Swift 中更简洁

### 5. 通知中心
- 语法略有不同，但功能相同

## 📈 工作量估算

| 阶段 | 工作量 | 说明 |
|------|--------|------|
| 准备阶段 | 1-2 天 | 配置和设置 |
| 工具类迁移 | 1 周 | 5-10 个简单类 |
| 数据模型迁移 | 1 周 | 5-8 个模型类 |
| 业务逻辑迁移 | 1-2 周 | 10-15 个核心类 |
| UI 层迁移 | 1-2 周 | 10-12 个 UI 类 |
| 清理优化 | 1 周 | 测试和优化 |
| **总计** | **5-7 周** | 取决于代码复杂度 |

## 🎁 迁移后的优势

1. **代码质量**
   - 类型安全
   - 更少的运行时错误
   - 更好的代码可读性

2. **开发效率**
   - 更简洁的语法
   - 更好的 IDE 支持
   - 更快的编译速度（某些场景）

3. **维护性**
   - 更容易理解和维护
   - 更好的错误处理
   - 更现代的编程范式

4. **性能**
   - Swift 在某些场景下性能更好
   - 更好的内存管理

## 🚀 快速开始

### 最小化迁移示例

1. **创建 Swift 文件**：
   ```bash
   # 在 Xcode 中：File → New → File → Swift File
   # 命名为 LanguageManager.swift
   ```

2. **迁移 LanguageManager**（最简单的类）

3. **测试功能**

4. **删除旧的 .h/.m 文件**

5. **重复上述步骤**

## 📚 学习资源

- [Swift 官方文档](https://swift.org/documentation/)
- [Apple 的 Swift 迁移指南](https://developer.apple.com/documentation/swift/migrating-your-objective-c-code-to-swift)
- [Swift 与 Objective-C 互操作](https://developer.apple.com/documentation/swift/imported-c-and-objective-c-apis)

## ❓ 常见问题

### Q: 可以只迁移部分代码吗？
A: 可以！Swift 和 Objective-C 可以共存，可以逐步迁移。

### Q: 迁移会影响现有功能吗？
A: 如果按照渐进式迁移，每个阶段都充分测试，不会影响现有功能。

### Q: 需要重写所有代码吗？
A: 不需要。可以逐步迁移，保持功能不变。

### Q: Swift 版本选择？
A: 建议使用 Swift 5.x（稳定且与 macOS 11.0+ 兼容）。

## 🎯 建议

1. **先从小类开始**：建立信心和经验
2. **充分测试**：每个迁移的类都要测试
3. **保持功能不变**：迁移的目标是语言转换，不是重构
4. **逐步推进**：不要急于一次性迁移所有代码
5. **团队学习**：如果团队不熟悉 Swift，可以边迁移边学习

## 📝 总结

**结论**：这个项目完全可以改造成 Swift，建议采用渐进式迁移策略。

**推荐路径**：
1. 先迁移 `LanguageManager`（最简单）
2. 然后迁移工具类（`Util`, `Environment` 等）
3. 再迁移数据模型
4. 最后迁移 UI 层

**时间线**：5-7 周（取决于团队规模和代码复杂度）

**风险**：低（采用渐进式迁移）

