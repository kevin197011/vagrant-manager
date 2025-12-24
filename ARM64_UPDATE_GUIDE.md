# ARM64 (Apple Silicon) 支持更新指南

## 已完成的配置更新

### 1. ✅ Podfile 更新
- **平台版本**：从 `10.8` 更新到 `11.0`
- **Sparkle 版本**：从 `1.22.0` 更新到 `~> 2.0`（支持 ARM64）

### 2. ✅ Xcode 项目配置更新
- **MACOSX_DEPLOYMENT_TARGET**：所有配置从 `10.8` 更新到 `11.0`
  - Debug 配置
  - Release 配置
  - 主应用目标配置

## 下一步操作

### 1. 更新 CocoaPods 依赖

运行以下命令更新依赖：

```bash
cd /Users/kevin/projects/src/vagrant-manager
pod install
```

这将：
- 更新 Sparkle 到 2.x 版本
- 重新生成 `Pods` 目录和 `Vagrant Manager.xcworkspace`

### 2. 验证配置

在 Xcode 中打开项目：

```bash
open "Vagrant Manager.xcworkspace"
```

检查以下设置：
1. **项目设置** → **General** → **Deployment Info**
   - Minimum Deployments: macOS 11.0
2. **构建设置** → **Architectures**
   - 应该包含 `arm64` 和 `x86_64`（或使用默认的 `$(ARCHS_STANDARD)`）

### 3. 构建测试

#### 仅 ARM64 构建（Apple Silicon）
```bash
xcodebuild -workspace "Vagrant Manager.xcworkspace" \
          -scheme "Vagrant Manager" \
          -configuration Release \
          -arch arm64 \
          -sdk macosx \
          -derivedDataPath ./build
```

#### 通用二进制构建（同时支持 Intel 和 Apple Silicon）
```bash
xcodebuild -workspace "Vagrant Manager.xcworkspace" \
          -scheme "Vagrant Manager" \
          -configuration Release \
          -arch arm64 -arch x86_64 \
          -sdk macosx \
          -derivedDataPath ./build
```

#### 在 Xcode 中构建
1. 选择 **Product** → **Scheme** → **Edit Scheme**
2. 在 **Run** 和 **Archive** 的 **Build Configuration** 中选择 **Release**
3. 选择 **Product** → **Build** (⌘B)
4. 或选择 **Product** → **Archive** 创建发布版本

### 4. 验证架构

构建完成后，验证二进制文件的架构：

```bash
# 查看应用包的架构
file "build/Build/Products/Release/Vagrant Manager.app/Contents/MacOS/Vagrant Manager"

# 或使用 lipo 命令
lipo -info "build/Build/Products/Release/Vagrant Manager.app/Contents/MacOS/Vagrant Manager"
```

期望输出：
- 仅 ARM64：`arm64`
- 通用二进制：`arm64 x86_64`

### 5. 测试

在 Apple Silicon Mac 上测试：

1. **基本功能测试**
   - 启动应用
   - 检查状态栏图标显示
   - 测试菜单功能

2. **Vagrant 集成测试**
   - 检测 Vagrant 实例
   - 执行 Vagrant 命令（up, halt, suspend 等）
   - 检查虚拟机状态显示
   - 测试 SSH 连接

3. **更新功能测试**
   - 测试 Sparkle 自动更新功能
   - 验证版本检查

## 注意事项

### 系统要求
- **最低 macOS 版本**：11.0 (Big Sur) 或更高
- **Xcode 版本**：建议使用 Xcode 12.2 或更高版本（支持 Apple Silicon）

### 向后兼容性
- 更新到 macOS 11.0 后，应用将**不再支持** macOS 10.8 - 10.15
- 如果需要支持旧版本 macOS，需要维护两个版本：
  - 一个针对 macOS 10.8+（仅 Intel）
  - 一个针对 macOS 11.0+（Intel + Apple Silicon）

### Sparkle 2.x 变化
- Sparkle 2.x 有一些 API 变化，但项目使用的 API 应该保持兼容
- 如果遇到编译错误，可能需要更新 Sparkle 相关的代码

### Vagrant 在 Apple Silicon 上
- Vagrant 本身可以在 Apple Silicon 上运行
- 但某些虚拟机提供商可能需要特殊配置：
  - **VirtualBox**：在 Apple Silicon 上支持有限，可能需要使用 UTM 或其他方案
  - **Parallels**：有原生 Apple Silicon 支持
  - **VMware Fusion**：有 Apple Silicon 版本

## 故障排除

### 如果构建失败

1. **清理构建**
   ```bash
   xcodebuild clean -workspace "Vagrant Manager.xcworkspace" -scheme "Vagrant Manager"
   rm -rf build Pods Podfile.lock
   pod install
   ```

2. **检查 Sparkle 版本**
   ```bash
   pod search Sparkle
   ```
   确保使用支持 ARM64 的版本

3. **检查 Xcode 版本**
   ```bash
   xcodebuild -version
   ```
   确保使用 Xcode 12.2 或更高版本

### 如果运行时出错

1. **检查架构**
   ```bash
   arch
   ```
   在 Apple Silicon Mac 上应该显示 `arm64`

2. **检查依赖库架构**
   ```bash
   file "Vagrant Manager.app/Contents/Frameworks/Sparkle.framework/Sparkle"
   ```
   应该包含 `arm64`

## 相关资源

- [Apple Silicon 迁移指南](https://developer.apple.com/documentation/apple-silicon)
- [Sparkle 2.x 文档](https://sparkle-project.org/documentation/)
- [Vagrant 官方文档](https://www.vagrantup.com/docs)

## 更新日期

配置更新完成日期：2025年1月

