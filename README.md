# Swift 与 Objective-C 混编 iOS Demo

本项目旨在演示如何在同一个 iOS 项目中混合使用 Swift 和 Objective-C 代码。

## 项目结构

- **swift-oc-demo/**: 项目主目录
  - `ContentView.swift`: 使用 SwiftUI 构建的主要视图，将调用 Objective-C 代码。
  - `MyObjectiveCClass.h`: Objective-C 类的头文件。
  - `MyObjectiveCClass.m`: Objective-C 类的实现文件。
  - `swift-oc-demo-Bridging-Header.h`: 桥接头文件，用于向 Swift 暴露 Objective-C 代码。
  - `swift_oc_demoApp.swift`: App 入口。
- **swift-oc-demo.xcodeproj**: Xcode 项目文件。

## 配置步骤

1.  **创建 Objective-C 文件**: 在项目中添加 `MyObjectiveCClass.h` 和 `MyObjectiveCClass.m`。
2.  **创建桥接头文件**: 当你首次向项目中添加 Objective-C 文件（或 Swift 文件到纯 OC 项目）时，Xcode 通常会提示你是否创建桥接头文件。如果未提示，可以手动创建一个名为 `<ProjectName>-Bridging-Header.h` 的头文件（在本例中是 `swift-oc-demo-Bridging-Header.h`）。
3.  **配置构建设置**: 
    - 打开 Xcode 项目设置。
    - 选择你的 Target。
    - 进入 "Build Settings"。
    - 搜索 "Objective-C Bridging Header"。
    - 将其值设置为桥接头文件的路径，相对于项目根目录（例如 `swift-oc-demo/swift-oc-demo-Bridging-Header.h`）。
4.  **导入 Objective-C 头文件**: 在桥接头文件 (`swift-oc-demo-Bridging-Header.h`) 中，导入你需要暴露给 Swift 的 Objective-C 头文件：
    ```objectivec
    #import "MyObjectiveCClass.h"
    ```

## 使用方法

- **在 Swift 中调用 Objective-C**: 
  - 确保桥接头文件已正确配置并导入了必要的 `.h` 文件。
  - 你可以直接在 Swift 代码中使用 Objective-C 类，就像它们是 Swift 类一样。
  ```swift
  let objCInstance = MyObjectiveCClass()
  let message = objCInstance.getMessage()
  print(message)
  ```

- **在 Objective-C 中调用 Swift**:
  - 确保你的 Swift 类继承自 `NSObject` 并且需要暴露给 Objective-C 的成员（类、方法、属性）标记了 `@objc` 或整个类标记了 `@objcMembers`。
  - 在需要调用 Swift 代码的 Objective-C 文件 (`.m`) 中，导入 Xcode 自动生成的头文件： `#import "<ProjectName>-Swift.h"` (在本例中是 `#import "swift_oc_demo-Swift.h"`)。
  - 你现在可以像使用普通 Objective-C 类一样实例化和调用 Swift 类。
  ```objectivec
  #import "swift_oc_demo-Swift.h" // 导入 Swift 桥接头文件

  // ... 在某个方法中 ...
  MySwiftClass *swiftInstance = [[MySwiftClass alloc] init];
  NSString *swiftMessage = [swiftInstance getSwiftMessage];
  NSLog(@"%@", swiftMessage);
  NSString *greeting = [swiftInstance greetWithName:@"Objective-C"];
  NSLog(@"%@", greeting);
  ```

## 示例代码

请查看 `ContentView.swift`、`MyObjectiveCClass` 和 `MySwiftClass.swift` 文件中的示例代码，了解双向调用的具体实现。