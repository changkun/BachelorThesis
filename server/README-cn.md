# 服务端

中文 | [English](./README.md)

运行服务端之前需要进行一些配置，主要分为以下步骤：

## 安装依赖

首先安装服务端依赖包：

```bash
npm install
```

## 配置

这里主要是配置 LeapMotion 环境。首先将 LeapMotion 连接，在 Leap Visualizer 下确认 LeapMotion 硬件已经正确连接。在正确连接后，执行下面的配置，以 Mac 端为例：

##### 1. 关闭 LeapMotion 的守护进程：

```bash
sudo launchctl unload /Library/LaunchDaemons/com.leapmotion.leapd.plist
```

##### 2. 在下面的目录下：

```bash
$HOME/Library/Application\ Support/Leap\ Motion
```
找到 `config.json` 的修改配置，编辑 `config.json` 文件，并在 `"configuration"` 字段中的任意位置添加一条：

```json
"websockets_allow_remote": true
```

最终得到：

```json
"configuration": {
    "websockets_allow_remote": true,
    "background_app_mode": 2,
    "images_mode": 2,
    "interaction_box_auto": true,
    "power_saving_adapter": true,
    "robust_mode_enabled": false,
    "tracking_tool_enabled": true
}
```

##### 3. 保存退出，重新启动 LeapMotion 服务：

```bash
sudo launchctl load /Library/LaunchDaemons/com.leapmotion.leapd.plist
```

## 运行

执行：

```bash
./run.sh
```
