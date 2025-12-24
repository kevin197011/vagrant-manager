# 发布指南

## 快速开始

### 自动发布 ARM64 DMG

1. **创建并推送版本 tag：**
   ```bash
   git tag v2.7.2
   git push origin v2.7.2
   ```

2. **GitHub Actions 会自动：**
   - 检测到 tag 推送
   - 在 macOS 14 runner 上构建 ARM64 版本
   - 创建 DMG 安装包
   - 发布到 GitHub Releases

3. **查看构建进度：**
   - 访问 GitHub 仓库的 **Actions** 标签页
   - 查看最新的 workflow 运行状态

### 手动触发构建

1. 进入 GitHub 仓库 → **Actions** 标签页
2. 选择 **Build and Release ARM64 DMG** workflow
3. 点击 **Run workflow**
4. 输入版本号（例如：`v2.7.2`）
5. 点击 **Run workflow**

## Workflow 说明

### `build-and-release.yml` - ARM64 专用

**用途：** 快速构建和发布 ARM64 版本的 DMG

**特点：**
- 专门针对 Apple Silicon Mac
- 构建速度快
- 适合大多数用户（Apple Silicon 是主流）

**触发：**
- 推送 `v*` tag
- 手动触发

### `build-universal-dmg.yml` - 通用构建

**用途：** 构建多种架构的 DMG

**支持的架构：**
- `universal` - 同时支持 ARM64 和 x86_64（推荐）
- `arm64` - 仅 Apple Silicon
- `x86_64` - 仅 Intel Mac

**触发：**
- 推送 `v*` tag（默认构建 universal）
- 手动触发（可选择架构）

## 版本号规范

建议使用语义化版本号：
- `v2.7.2` - 补丁版本
- `v2.8.0` - 次要版本
- `v3.0.0` - 主要版本

## 发布检查清单

在创建 tag 之前，确保：

- [ ] 代码已提交并推送到主分支
- [ ] 版本号已更新（在 Xcode 项目中）
- [ ] CHANGELOG 已更新（如果有）
- [ ] 所有测试通过
- [ ] README 中的版本信息已更新

## 发布后验证

1. **检查 Release：**
   - 访问 GitHub Releases 页面
   - 确认 DMG 文件已上传
   - 检查 Release 说明是否正确

2. **下载测试：**
   - 下载 DMG 文件
   - 在目标 Mac 上安装测试
   - 验证应用功能正常

3. **更新文档：**
   - 更新项目 README（如果需要）
   - 更新官方网站（如果有）

## 故障排除

### Workflow 失败

**常见问题：**

1. **CocoaPods 安装失败**
   - 检查 `Podfile` 语法
   - 确保网络连接正常
   - 查看详细错误日志

2. **Xcode 构建失败**
   - 检查 Xcode 项目配置
   - 确保所有依赖正确
   - 查看构建日志中的具体错误

3. **DMG 创建失败**
   - 检查 `dmg/appdmg.json` 配置
   - 确保资源文件存在
   - 验证 .app 文件已正确生成

4. **Release 创建失败**
   - 检查 GitHub token 权限
   - 确保 tag 格式正确
   - 检查 Release 是否已存在

### 获取帮助

- 查看 workflow 日志：GitHub Actions → 选择失败的运行 → 查看日志
- 检查配置文件：`.github/workflows/` 目录
- 参考文档：`.github/workflows/README.md`

## 高级用法

### 同时发布多个架构

如果需要同时发布 ARM64 和 Universal 版本：

1. 先推送 tag 触发 ARM64 构建
2. 等待 ARM64 构建完成
3. 手动触发 Universal 构建（使用相同的 tag）

### 预发布版本

创建预发布版本（beta/alpha）：

```bash
git tag v2.8.0-beta.1
git push origin v2.8.0-beta.1
```

然后在 GitHub Releases 中手动将 Release 标记为 "Pre-release"。

### 代码签名（未来）

如果需要代码签名，需要：

1. 在 GitHub Secrets 中添加证书
2. 更新 workflow 文件
3. 参考 `.github/workflows/README.md` 中的代码签名部分

## 相关文件

- `.github/workflows/build-and-release.yml` - ARM64 构建 workflow
- `.github/workflows/build-universal-dmg.yml` - 通用构建 workflow
- `.github/workflows/README.md` - Workflow 详细文档
- `dmg/appdmg.json` - DMG 配置文件

