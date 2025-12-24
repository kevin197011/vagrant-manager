# Vagrant Manager 项目概览

## 项目简介

**Vagrant Manager for OS X** 是一个 macOS 状态栏菜单应用程序，用于从统一位置管理所有 Vagrant 虚拟机。该项目由 Lanayo Technology 开发，采用 MIT 许可证。

- **项目类型**: macOS 原生应用程序 (Objective-C)
- **最低系统要求**: OS X 10.8 Mountain Lion 或更高版本
- **开发工具**: Xcode, CocoaPods
- **许可证**: MIT License

## 核心功能

### 1. 虚拟机管理
- 自动检测 Vagrant 实例（通过 NFS 扫描、全局状态扫描、服务提供商检测）
- 支持书签功能，手动添加和管理 Vagrant 实例
- 显示虚拟机状态（运行中、已停止、已暂停等）
- 支持多虚拟机实例管理

### 2. Vagrant 操作
- **启动/停止**: `vagrant up`, `vagrant halt`
- **暂停/恢复**: `vagrant suspend`, `vagrant resume`
- **重启**: `vagrant reload`
- **配置**: `vagrant provision`
- **销毁**: `vagrant destroy`
- **SSH 连接**: `vagrant ssh`
- **RDP 连接**: `vagrant rdp`

### 3. 自定义命令
- 支持自定义命令管理
- 可在主机或虚拟机内执行
- 支持在终端中运行或后台执行

### 4. 服务提供商支持
- **VirtualBox**: 默认支持
- **Parallels**: 支持 Parallels Desktop
- **自定义提供商**: 支持添加自定义提供商
- 自动检测提供商类型

### 5. 用户界面
- 状态栏菜单应用（LSUIElement）
- 支持多种图标主题（clean, flat）
- 显示运行中的虚拟机数量
- 任务输出窗口
- 偏好设置窗口
- 书签管理窗口

### 6. 其他特性
- 自动更新（使用 Sparkle 框架）
- 检查 Vagrant 版本更新
- 退出时自动停止所有虚拟机（可选）
- 启动时自动启动书签的虚拟机（可选）
- 定时刷新虚拟机状态
- 系统唤醒后自动刷新
- 通知中心集成

## 项目架构

### 核心类结构

```
AppDelegate (应用程序主控制器)
├── VagrantManager (单例，管理所有 Vagrant 实例)
│   ├── VagrantInstance (Vagrant 实例，包含多个机器)
│   │   └── VagrantMachine (单个虚拟机)
│   ├── VirtualMachineServiceProvider (服务提供商接口)
│   │   ├── VirtualBoxServiceProvider
│   │   └── ParallelsServiceProvider
│   └── VagrantInstanceCache (实例缓存)
├── NativeMenu (状态栏菜单)
├── BookmarkManager (书签管理)
├── CustomCommandManager (自定义命令管理)
├── CustomProviderManager (自定义提供商管理)
└── 各种窗口控制器
    ├── PreferencesWindow
    ├── AboutWindow
    ├── ManageBookmarksWindow
    ├── ManageCustomCommandsWindow
    ├── ManageCustomProvidersWindow
    └── TaskOutputWindow
```

### 主要组件

#### 1. **AppDelegate** (`AppDelegate.h/m`)
- 应用程序生命周期管理
- 协调各个组件
- 处理 Vagrant 命令执行
- 管理窗口和通知
- 处理应用更新

#### 2. **VagrantManager** (`VagrantManager.h/m`)
- 单例模式管理所有 Vagrant 实例
- 实例发现和刷新
- 服务提供商注册和管理
- 实例状态同步

#### 3. **VagrantInstance** (`VagrantInstance.h/m`)
- 表示一个 Vagrant 项目目录
- 包含多个 VagrantMachine
- 查询机器状态
- 管理 Vagrantfile

#### 4. **VagrantMachine** (`VagrantMachine.h/m`)
- 表示单个虚拟机
- 状态管理（Unknown, NotCreated, PowerOff, Saved, Running, Restoring）
- 状态字符串转换

#### 5. **NativeMenu** (`NativeMenu.h/m`)
- 构建和管理状态栏菜单
- 菜单项点击处理
- 菜单刷新

#### 6. **扫描器组件**
- **NFSScanner**: 扫描 NFS 导出以发现 Vagrant 实例
- **VagrantGlobalStatusScanner**: 解析 `vagrant global-status` 输出
- **VirtualBoxServiceProvider**: 通过 VBoxManage 发现实例
- **ParallelsServiceProvider**: 通过 prlctl 发现实例

#### 7. **管理器组件**
- **BookmarkManager**: 管理用户书签（持久化存储）
- **CustomCommandManager**: 管理自定义命令
- **CustomProviderManager**: 管理自定义提供商

## 技术栈

### 开发框架
- **Cocoa/AppKit**: macOS 原生 UI 框架
- **Foundation**: 基础框架
- **Sparkle**: 自动更新框架（通过 CocoaPods）

### 依赖管理
- **CocoaPods**: 依赖管理工具
- 主要依赖: `Sparkle` (自动更新)

### 构建系统
- **Xcode Project**: 使用 Xcode 项目文件
- **CocoaPods Workspace**: 使用 `.xcworkspace` 进行构建

## 文件结构

```
vagrant-manager/
├── Vagrant Manager/          # 主应用代码
│   ├── AppDelegate.h/m       # 应用程序委托
│   ├── VagrantManager.h/m     # Vagrant 管理器
│   ├── VagrantInstance.h/m   # Vagrant 实例
│   ├── VagrantMachine.h/m    # Vagrant 虚拟机
│   ├── NativeMenu.h/m        # 状态栏菜单
│   ├── BookmarkManager.h/m   # 书签管理
│   ├── CustomCommandManager.h/m  # 自定义命令管理
│   ├── CustomProviderManager.h/m  # 自定义提供商管理
│   ├── 各种窗口控制器
│   ├── 服务提供商实现
│   ├── 扫描器组件
│   └── 资源文件（图片、XIB 等）
├── dmg/                      # DMG 构建配置
│   ├── appdmg.json
│   └── 图标和背景图片
├── Podfile                   # CocoaPods 配置
├── Podfile.lock              # 依赖锁定文件
├── README.md                 # 项目说明
├── LICENSE.md                # MIT 许可证
└── Vagrant Manager.xcodeproj/ # Xcode 项目文件
```

## 数据流

### 实例发现流程
1. **启动时**: AppDelegate 初始化 VagrantManager
2. **刷新触发**: 用户操作、定时器、系统唤醒等
3. **多源扫描**:
   - 从书签加载实例
   - NFS 扫描
   - Vagrant 全局状态扫描
   - 服务提供商扫描（如果启用）
4. **实例查询**: 并行查询每个实例的机器状态
5. **状态更新**: 通过委托通知 UI 更新
6. **菜单重建**: NativeMenu 根据新状态重建菜单

### 命令执行流程
1. **用户点击菜单项**: NativeMenu 调用 AppDelegate
2. **构建命令**: 根据操作类型构建 Vagrant 命令
3. **创建任务**: 使用 NSTask 执行命令
4. **显示输出**: TaskOutputWindow 显示执行结果
5. **完成通知**: 任务完成后发送通知
6. **自动刷新**: 触发实例状态刷新

## 配置和偏好设置

### 用户偏好设置（NSUserDefaults）
- `haltOnExit`: 退出时停止所有虚拟机
- `refreshEvery`: 启用定时刷新
- `refreshEveryInterval`: 刷新间隔（秒）
- `statusBarIconTheme`: 状态栏图标主题（clean/flat）
- `showRunningVmCount`: 显示运行中的虚拟机数量
- `usePathAsInstanceDisplayName`: 使用路径作为显示名称
- `includeMachineNamesInMenu`: 在菜单中包含机器名称
- `showTaskNotification`: 显示任务通知
- `hideTaskWindows`: 隐藏任务窗口
- `terminalPreference`: 终端偏好（Terminal/iTerm/Hyper）
- `terminalEditorPreference`: 终端编辑器偏好
- `useProviderMachineDetection`: 使用提供商机器检测
- `dontShowUpdateNotification`: 不显示更新通知

## 通知系统

项目使用 NSNotificationCenter 进行组件间通信：

- `vagrant-manager.task-completed`: 任务完成
- `vagrant-manager.theme-changed`: 主题更改
- `vagrant-manager.refreshing-started/ended`: 刷新开始/结束
- `vagrant-manager.instance-added/removed/updated`: 实例变化
- `vagrant-manager.bookmarks-updated`: 书签更新
- `vagrant-manager.update-available`: 更新可用
- `vagrant-manager.started-shutdown`: 开始关闭

## 构建和分发

### 构建 DMG
1. 将编译好的 `Vagrant Manager.app` 放入 `dmg/` 目录
2. 使用 `appdmg` 工具构建：
   ```bash
   appdmg dmg/appdmg.json <outputfile>
   ```

### 发布流程
- 开发分支: `develop`
- 发布分支: `master` (仅包含标记的发布版本)
- 自动更新: 通过 Sparkle 框架，从 `https://api.lanayo.com/appcast/vagrant_manager.xml` 获取更新

## 开发注意事项

### 代码规范
- 使用 Objective-C 编写
- 遵循 Cocoa 命名约定
- 使用委托模式进行组件通信
- 使用单例模式管理共享资源

### 线程安全
- 使用 `@synchronized` 保护共享数据
- 使用 GCD (Grand Central Dispatch) 进行并发操作
- UI 更新必须在主线程

### 内存管理
- 使用 ARC (Automatic Reference Counting)
- 注意循环引用（使用 `weak` 引用打破循环）

## 已知限制

1. Vagrant 机器必须先初始化才能被检测到
2. 需要 Vagrant 和 VirtualBox/Parallels 命令在 PATH 中
3. 某些未检测到的机器需要手动配置书签
4. 首次刷新时才会启动标记为"启动时启动"的书签

## 扩展点

### 添加新的服务提供商
1. 实现 `VirtualMachineServiceProvider` 协议
2. 在 `AppDelegate` 中注册提供商
3. 实现 `getVagrantInstancePaths` 方法返回实例路径

### 添加新的 Vagrant 操作
1. 在 `AppDelegate` 中添加操作方法
2. 在 `NativeMenu` 中添加菜单项
3. 实现命令构建和执行逻辑

## 相关资源

- 官方网站: http://vagrantmanager.com/
- GitHub: https://github.com/lanayotech/vagrant-manager
- Windows 版本: https://github.com/lanayotech/vagrant-manager-windows

