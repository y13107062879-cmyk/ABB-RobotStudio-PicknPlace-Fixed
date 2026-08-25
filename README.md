# ABB RobotStudio Pick and Place Fixed

这是一个基于 ABB RobotStudio 的 Pick and Place 仿真学习项目，主要用于学习工业机器人搬运、RAPID 程序、工具坐标 TCP、I/O 信号以及 GitHub 版本管理。

本仓库是在原始 ABB RobotStudio PicknPlace 示例基础上整理和修复的学习版本。当前版本已经修复了 RAPID 程序中 `Gripper` 工具数据缺失导致程序无法检查、无法启动仿真的问题。

## 项目内容

| 文件或文件夹 | 说明 |
| --- | --- |
| `PicknPlace.rspag` | RobotStudio 工作站文件，打开后可以看到机器人、工件、夹具和搬运场景 |
| `Module1.mod` | RAPID 主程序文件，包含机器人运动轨迹和夹取/放置逻辑 |
| `Gripper TCP.txt` | 夹具 TCP 工具数据参考 |
| `Current TCP Location.txt` | 当前 TCP 位置信息参考 |
| `ABB RobotStudio Manuals/` | ABB RobotStudio 和 RAPID 相关说明文档 |

## 使用环境

- Windows
- ABB RobotStudio 6.08
- ABB IRB 1200 5kg 0.9m 虚拟机器人
- Git / GitHub

## 如何打开项目

1. 打开 ABB RobotStudio。
2. 选择 `文件` -> `打开`。
3. 打开本仓库中的文件：

   ```text
   PicknPlace.rspag
   ```

4. 等待 RobotStudio 加载工作站和虚拟控制器。
5. 在 RAPID 页面中检查 `T_ROB1` 任务下的 `Module1` 程序。
6. 如果程序没有错误，可以将程序指针设置到 `main`。
7. 点击仿真播放按钮，观察机器人执行 Pick and Place 动作。

## 本次修复内容

原始项目在 RobotStudio 中检查程序时出现类似错误：

```text
引用错误(128)：引用了未知完整数据 Gripper
RAPID 程序中存在错误
```

原因是 RAPID 程序中使用了 `Gripper` 作为工具数据，但是程序里没有完整定义这个工具。

本版本进行了以下修改：

- 在 `Module1.mod` 中添加了 `Gripper` 工具数据定义。
- 将运动指令统一使用 `Gripper\WObj:=wobj0`。
- 增加了 `DoAttach` 和 `DoDetach` 程序，用于控制夹取和释放信号。
- 重新保存并更新了 `PicknPlace.rspag` 工作站文件。

核心修复代码示例：

```rapid
PERS tooldata Gripper:=[TRUE,[[0,0,114.2],[1,0,0,0]],[0.215,[8.7,12.3,49.2],[1,0,0,0],0.00021,0.00024,0.00009]];
```

## RAPID 主流程说明

程序入口是：

```rapid
PROC main()
```

主要流程如下：

1. 机器人从休眠位置移动到工作位置。
2. 移动到初始工件位置。
3. 使用夹具信号执行夹取。
4. 按照 3 x 3 的位置循环搬运工件。
5. 将工件放置到目标板位置。
6. 程序结束后机器人回到休眠位置。

## 如果物体没有被夹起来

如果机器人运动正常，但工件没有跟着夹具移动，通常不是 RAPID 运动指令的问题，而是 RobotStudio 里的仿真逻辑还需要检查：

- `Attach` 和 `Detach` 数字输出信号是否存在。
- Smart Component 是否正确连接到了 `Attach` / `Detach` 信号。
- 工件是否被设置为可以被夹具吸附或连接。
- 夹具 TCP 位置是否对准工件。
- Event Manager 中是否配置了夹取和释放动作。

也就是说，RAPID 程序负责让机器人移动和发出信号；真正让物体“粘到夹具上”的效果，需要 RobotStudio 的 Smart Component 或事件逻辑配合。

## GitHub 使用步骤

以后如果继续修改这个项目，可以按照下面流程上传到 GitHub：

```bash
git status
git add .
git commit -m "说明这次修改了什么"
git push
```

如果要从 GitHub 下载最新内容到电脑：

```bash
git pull
```

## 学习建议

刚开始学习 RobotStudio 和 GitHub，不建议一上来追求看懂所有代码。更好的路线是：

1. 先成功打开项目并让机器人动起来。
2. 修改一个小参数，例如速度 `v500`、高度偏移 `SafetyZ_Offset`。
3. 观察仿真轨迹变化。
4. 再修改一小段 RAPID 程序。
5. 每完成一个小修改，就用 Git 提交一次。

这样可以慢慢建立对机器人程序、仿真环境和 GitHub 版本管理的理解。

## 说明

本项目主要用于学习 ABB RobotStudio 仿真和 RAPID 编程，不建议直接用于真实工业机器人。真实机器人运行前必须经过安全检查、示教验证、碰撞检查和现场工程师确认。
