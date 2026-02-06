# Windows Mobile Hotspot Manager

一个用于快速开启 Windows 移动热点的 PowerShell 脚本，支持交互式选择网络连接进行共享。

## ✨ 功能特点

- 🔍 **自动扫描** - 自动检测所有可用的网络连接
- 📡 **状态显示** - 显示每个连接的状态（已连接/本地访问/受限）
- 🎯 **交互选择** - 通过序号选择要共享的网络
- ⚡ **一键启动** - 快速开启移动热点
- 🔒 **网络过滤** - 自动过滤未连接的网络

## 📋 系统要求

- Windows 10 / Windows 11
- PowerShell 5.1 或更高版本
- 管理员权限
- 支持移动热点功能的 WiFi 适配器

## 🚀 使用方法

### 方法一：直接运行（推荐）

```powershell
# 以管理员身份运行 PowerShell，然后执行：
.\AP.ps1
```

### 方法二：使用 sudo（如果已安装）

```powershell
sudo powershell .\AP.ps1
```

### 运行效果

```
========== 可用的网络连接 ==========
  [1] 宽带连接 [已连接]
  [2] MyWiFi [已连接]
======================================

请输入序号选择要共享的网络连接 (1-2): 1

正在启动热点，共享网络: 宽带连接...
热点启动成功！
```

## ⚙️ 热点配置

热点的 SSID（名称）和密码使用 Windows 系统设置中的配置。

修改热点设置：
1. 打开 **设置** → **网络和 Internet** → **移动热点**
2. 点击 **编辑** 修改网络名称和密码

## 🛠️ 技术实现

本脚本使用 Windows Runtime (WinRT) API：

- `Windows.Networking.Connectivity.NetworkInformation` - 获取网络连接配置
- `Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager` - 管理移动热点

## 📁 文件说明

| 文件 | 说明 |
|------|------|
| `AP.ps1` | 主脚本，交互式选择网络并开启热点 |

## ❓ 常见问题

### Q: 热点启动失败
**A:** 可能的原因：
- WiFi 适配器不支持热点功能
- 另一个程序正在使用 WiFi 适配器
- 需要先在系统设置中启用一次移动热点

### Q: 需要管理员权限
**A:** 开启移动热点需要管理员权限，请以管理员身份运行 PowerShell。

## 📄 License

MIT License

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！
