Looking for the Windows version? Check out [Vagrant Manager for Windows](https://github.com/lanayotech/vagrant-manager-windows)

# Vagrant Manager for macOS

Vagrant Manager is a macOS status bar menu app that lets you manage all of your vagrant machines from one central location.
More information is available at http://vagrantmanager.com/

![demo.gif](http://vagrantmanager.com/demo.gif)

## Downloads
Download Vagrant Manager from the [GitHub Releases Page](https://github.com/kevin197011/vagrant-manager/releases)

## Installation Notes
* Vagrant Manager can automatically detect most machines, undetected machines will require manual configuration via bookmarks.
* Make sure that you have VirtualBox and Vagrant installed, and the `VBoxManage` and `vagrant` commands are in your path so that Vagrant Manager can execute them. If you use Parallels, ensure the `prlctl` command is also in your path.
* Currently, vagrant machines must already be initialized in order for Vagrant Manager to detect them. Make sure you have run vagrant init on any machine you want to appear in Vagrant Manager. Once Vagrant Manager has detected a machine, you can bookmark it so that it will not disappear when you destroy the machine. You can also manually add a bookmark and specify the path to your Vagrantfile.
* Vagrant Manager requires macOS 11.0 (Big Sur) or higher

## System Requirements
* macOS 11.0 (Big Sur) or later
* Apple Silicon (M1/M2/M3/M4/M5) or Intel Mac
* Vagrant installed and in PATH
* VirtualBox or Parallels installed (if using those providers)

## Apple Silicon Support
Vagrant Manager now supports Apple Silicon (ARM64) Macs! The latest releases include native ARM64 builds for optimal performance on M1/M2/M3/M4/M5 Macs.

**Note:** If macOS shows "Vagrant Manager is damaged" error after downloading:
* Right-click the app and select "Open" (don't double-click)
* Or run: `xattr -cr /Applications/Vagrant\ Manager.app` in Terminal
* Then try opening again

## Building DMG
* Use [appdmg](https://github.com/LinusU/node-appdmg) to build the distribution DMG.
* Put the `Vagrant Manager.app` file in the `dmg` foler
* Run `appdmg dmg/appdmg.json <outputfile>`

## Building DMG
* Use [appdmg](https://github.com/LinusU/node-appdmg) to build the distribution DMG.
* Put the `Vagrant Manager.app` file in the `dmg` folder
* Run `appdmg dmg/appdmg.json <outputfile>`

Or use the automated GitHub Actions workflow:
* Push a tag (e.g., `v2.8.0`) to automatically build and release DMG packages
* See `.github/workflows/README.md` for more details

## Contributing to Vagrant Manager

We love code contributions! If you would like to contribute, here are some notes and guidelines:

* All development happens on the **main** branch
* If you are going to be submitting a pull request, please branch from **main**, and submit your pull request back to the **main** branch
* [Helpful article about forking](https://help.github.com/articles/fork-a-repo)
* [Helpful article about pull requests](https://help.github.com/articles/using-pull-requests)
