# Server

English | [中文](./README-cn.md)

Before you running this server, you need the following configuration:

## Install dependencies

Run the following command in bash:

```bash
npm install
```

## Configuration

For configuration, you mainly config the Leap Motion environment.

First of all, please plug in the LeapMotion hardware, test it by Leap Visualizer to make sure it is correct for connection. Then you need set Leap WebSocket environment, for Mac OS X:

##### 1. Shutdown LeapMotion daemon:

```bash
sudo launchctl unload /Library/LaunchDaemons/com.leapmotion.leapd.plist
```

##### 2. Into the following directory:

```bash
$HOME/Library/Application\ Support/Leap\ Motion
```
Find `config.json` then add the following fields in `"configuration"`:

```json
"websockets_allow_remote": true
```

Finally we get:

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

##### 3. Save and restart LeapMotion service:

```bash
sudo launchctl load /Library/LaunchDaemons/com.leapmotion.leapd.plist
```

## Run

run:

```bash
./run.sh
```
