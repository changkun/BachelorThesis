# 客户端说明

中文 | [English](./README.md)

此文件夹包含三个演示程序，一共演示了[论文](../paper/main-cn.pdf)中提及的五个演示效果。

其中：

1. [0-demo-crown-circle](./0-demo-crown-circle)
    - 本例是一个实验性的演示程序，不建议运行本例，本例的产生只用于测试通信性能，但是提供了对五根手指的捏合、握拳等全部手势的更新。
2. [1-Demo-Tap](./1-Demo-Tap)
    - 本例是对轻点和 ForceTouch 手势的实际演示，当手执行轻点手势时，手表界面上的按钮会被点击，计数器会加一；当执行 ForceTouch 操作时，计数器会提示 Force! 操作。
3. [5-Demo-Game](./5-Demo-Game)
    - 本例实现了一个 Apple Watch 上的对战游戏，是本项目的一个小应用。玩家可以通过旋转数码表冠或执行双指滑动手势(备择操作)来控制击球板。

**注意**：

运行程序时，需检查 `Networking.swift` 文件中服务端 URL 地址是否正确。
