寻找 Windows 版本？请查看 [Vagrant Manager for Windows](https://github.com/lanayotech/vagrant-manager-windows)

# Vagrant Manager for macOS

Vagrant Manager 是一个 macOS 状态栏菜单应用程序，可让您从一个中心位置管理所有 Vagrant 虚拟机。
更多信息请访问 http://vagrantmanager.com/

![demo.gif](http://vagrantmanager.com/demo.gif)

## 下载
从 [GitHub Releases 页面](https://github.com/kevin197011/vagrant-manager/releases) 下载 Vagrant Manager

## 安装说明
* Vagrant Manager 可以自动检测大多数虚拟机，未检测到的虚拟机需要通过书签进行手动配置。
* 请确保您已安装 VirtualBox 和 Vagrant，并且 `VBoxManage` 和 `vagrant` 命令在您的 PATH 中，以便 Vagrant Manager 可以执行它们。如果您使用 Parallels，请确保 `prlctl` 命令也在您的 PATH 中。
* 目前，vagrant 虚拟机必须已经初始化才能被 Vagrant Manager 检测到。请确保您已在任何想要出现在 Vagrant Manager 中的虚拟机上运行了 vagrant init。一旦 Vagrant Manager 检测到虚拟机，您可以将其添加为书签，这样在销毁虚拟机后它也不会消失。您也可以手动添加书签并指定 Vagrantfile 的路径。
* Vagrant Manager 需要 macOS 11.0 (Big Sur) 或更高版本

## 系统要求
* macOS 11.0 (Big Sur) 或更高版本
* Apple Silicon (M1/M2/M3/M4/M5) 或 Intel Mac
* Vagrant 已安装并在 PATH 中
* VirtualBox 或 Parallels 已安装（如果使用这些提供商）

## Apple Silicon 支持
Vagrant Manager 现在支持 Apple Silicon (ARM64) Mac！最新版本包含针对 M1/M2/M3/M4/M5 Mac 的原生 ARM64 构建，以获得最佳性能。

**注意：** 如果 macOS 在下载后显示 "Vagrant Manager 已损坏" 错误：
* 右键点击应用程序并选择"打开"（不要双击）
* 或在终端中运行：`xattr -cr /Applications/Vagrant\ Manager.app`
* 然后再次尝试打开

## 构建 DMG
* 使用 [appdmg](https://github.com/LinusU/node-appdmg) 构建分发 DMG。
* 将 `Vagrant Manager.app` 文件放入 `dmg` 文件夹
* 运行 `appdmg dmg/appdmg.json <outputfile>`

或使用自动化的 GitHub Actions workflow：
* 推送一个 tag（例如 `v2.8.0`）以自动构建和发布 DMG 包
* 查看 `.github/workflows/README.md` 了解更多详情

## 语言支持
Vagrant Manager 支持多语言：
* 英语 (English)
* 简体中文 (Simplified Chinese)

您可以在偏好设置中切换语言。首次启动时会自动检测系统语言。

## 贡献代码

我们欢迎代码贡献！如果您想贡献代码，以下是一些说明和指南：

* 所有开发都在 **main** 分支上进行
* 如果您要提交 pull request，请从 **main** 分支创建分支，并将您的 pull request 提交回 **main** 分支
* [关于 fork 的有用文章](https://help.github.com/articles/fork-a-repo)
* [关于 pull requests 的有用文章](https://help.github.com/articles/using-pull-requests)
