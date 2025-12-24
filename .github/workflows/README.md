# GitHub Actions Workflows

本项目包含一个 GitHub Actions workflow 用于自动构建和发布 DMG 包。

## Workflow

### `build-universal-dmg.yml` - DMG 构建和发布

支持构建多种架构的 DMG 包：
- **ARM64**（默认）- Apple Silicon Mac
- **Universal** - 同时支持 ARM64 和 x86_64
- **x86_64** - Intel Mac

**触发方式：**
- 推送以 `v` 开头的 tag（默认构建 ARM64）
- 手动触发（可选择构建类型）

## 使用方法

### 自动发布（推荐）

1. **创建并推送 tag：**
   ```bash
   git tag v2.7.2
   git push origin v2.7.2
   ```

2. **Workflow 会自动：**
   - 检测到 tag 推送
   - 默认构建 ARM64 版本
   - 创建 DMG 包
   - 发布到 GitHub Releases

### 手动触发

1. 进入 GitHub 仓库的 **Actions** 标签页
2. 选择 **Build and Release DMG** workflow
3. 点击 **Run workflow**
4. 输入版本号（例如：`v2.7.2`）
5. 选择构建类型（arm64/universal/x86_64，默认 arm64）
6. 点击 **Run workflow**

## 构建产物

构建完成后，会在 GitHub Releases 中创建：
- **Release 标题**：`Release v2.7.2 (arm64)` 或 `Release v2.7.2 (universal)` 等
- **DMG 文件**：根据构建类型命名，例如：
  - `Vagrant Manager-2.7.2-arm64.dmg`（ARM64）
  - `Vagrant Manager-2.7.2-universal.dmg`（Universal）
  - `Vagrant Manager-2.7.2-x86_64.dmg`（Intel）

## 系统要求

构建环境：
- macOS 14 (Sonoma)
- Xcode（通过 GitHub Actions 自动安装）
- Node.js 20（用于 appdmg）
- CocoaPods（自动安装）

## 注意事项

1. **代码签名**：当前 workflow 使用 `CODE_SIGNING_REQUIRED=NO`，如果需要代码签名，需要：
   - 配置代码签名证书
   - 更新 workflow 中的签名设置

2. **发布权限**：确保 GitHub token 有创建 Release 的权限（默认的 `GITHUB_TOKEN` 通常已足够）

3. **DMG 配置**：DMG 的布局和样式在 `dmg/appdmg.json` 中配置

4. **版本号格式**：建议使用语义化版本号，例如 `v2.7.2`、`v2.8.0` 等

## 故障排除

### 构建失败

1. **检查日志**：在 GitHub Actions 中查看详细的构建日志
2. **验证依赖**：确保 `Podfile` 和 `Podfile.lock` 正确
3. **检查 Xcode 版本**：确保使用的 macOS runner 版本支持所需的 Xcode 版本

### DMG 创建失败

1. **检查 appdmg 配置**：验证 `dmg/appdmg.json` 格式正确
2. **检查资源文件**：确保 `dmg/` 目录中的图片文件存在
3. **验证 .app 文件**：确保 Xcode 构建成功生成了 .app 文件

### 发布失败

1. **检查权限**：确保 GitHub token 有创建 Release 的权限
2. **检查 tag**：确保 tag 格式正确（以 `v` 开头）
3. **检查 Release 是否存在**：如果 Release 已存在，workflow 会失败

## 自定义配置

### 修改构建架构

编辑 workflow 文件中的 `-arch` 参数：
```yaml
-arch arm64          # 仅 ARM64
-arch x86_64         # 仅 Intel
-arch arm64 -arch x86_64  # Universal
```

### 修改 macOS 版本

修改 `runs-on` 字段：
```yaml
runs-on: macos-14    # macOS 14 (Sonoma)
runs-on: macos-13    # macOS 13 (Ventura)
runs-on: macos-12    # macOS 12 (Monterey)
```

### 添加代码签名

如果需要代码签名，需要：
1. 在 GitHub Secrets 中添加证书和密钥
2. 更新 workflow 中的签名步骤

示例：
```yaml
- name: Import Certificate
  uses: apple-actions/import-codesign-certs@v1
  with:
    p12-file-base64: ${{ secrets.CERTIFICATES_P12 }}
    p12-password: ${{ secrets.CERTIFICATES_PASSWORD }}

# 然后在 xcodebuild 命令中移除 CODE_SIGNING_REQUIRED=NO
```

## 相关文件

- `dmg/appdmg.json` - DMG 配置文件
- `Podfile` - CocoaPods 依赖配置
- `.github/workflows/` - Workflow 文件目录

