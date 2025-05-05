# Swift 与 Objective-C 混编指南

本文档详细说明了如何在同一个 iOS 项目中混合使用 Swift 和 Objective-C 代码，包括双向调用的配置步骤和示例。

## 1. Swift 调用 Objective-C

这是最常见的情况，允许你在现代的 Swift 代码中利用已有的 Objective-C 类库。

### 配置步骤

1.  **创建 Objective-C 文件**: 
    - 在你的 Xcode 项目中添加 Objective-C 的 `.h` (头文件) 和 `.m` (实现文件)。例如，创建 `MyObjectiveCClass.h` 和 `MyObjectiveCClass.m`。
    ```objectivec
    // MyObjectiveCClass.h
    #import <Foundation/Foundation.h>

    @interface MyObjectiveCClass : NSObject

    - (NSString *)getMessage;

    @end

    // MyObjectiveCClass.m
    #import "MyObjectiveCClass.h"

    @implementation MyObjectiveCClass

    - (NSString *)getMessage {
        return @"Hello from Objective-C!";
    }

    @end
    ```

2.  **创建/配置桥接头文件 (Bridging Header)**:
    - 当你首次向 Swift 项目添加 Objective-C 文件时，Xcode 通常会提示你创建一个桥接头文件 (`<ProjectName>-Bridging-Header.h`)。如果选择创建，Xcode 会自动配置好构建设置。
    - 如果没有提示或你手动创建，需要进行以下配置：
        - 在 Xcode 中，选择你的 Target。
        - 进入 "Build Settings"。
        - 搜索 "Objective-C Bridging Header"。
        - 将其值设置为桥接头文件的路径，相对于项目根目录（例如 `YourProjectName/YourProjectName-Bridging-Header.h`）。

3.  **在桥接头文件中导入 Objective-C 头文件**:
    - 打开你的桥接头文件 (`<ProjectName>-Bridging-Header.h`)。
    - 在文件中导入你需要暴露给 Swift 的 Objective-C 类的头文件。
    ```objectivec
    // YourProjectName-Bridging-Header.h
    #import "MyObjectiveCClass.h"
    ```

### 使用方法

- 在你的 Swift 文件中 (`.swift`)，你可以直接实例化和使用桥接头文件中导入的 Objective-C 类。

```swift
// ContentView.swift
import SwiftUI

struct ContentView: View {
    let objCInstance = MyObjectiveCClass() // 实例化
    @State private var message: String = ""

    var body: some View {
        Text(message)
            .onAppear {
                self.message = objCInstance.getMessage() // 调用方法
            }
    }
}
```

## 2. Objective-C 调用 Swift

这允许你在现有的 Objective-C 代码中利用新的 Swift 功能或类。

### 配置步骤

1.  **创建 Swift 文件**: 
    - 在你的 Xcode 项目中添加 Swift 文件 (`.swift`)。例如，创建 `MySwiftClass.swift`。
    - 确保你的 Swift 类继承自 `NSObject`。
    - 使用 `@objc` 标记需要暴露给 Objective-C 的特定方法和属性，或者使用 `@objcMembers` 标记整个类以暴露其所有成员。

    ```swift
    // MySwiftClass.swift
    import Foundation

    @objcMembers // 或在方法/属性前加 @objc
    class MySwiftClass: NSObject {

        func getSwiftMessage() -> String {
            return "Hello from Swift!"
        }
        
        func greet(name: String) -> String {
            return "Hello, \(name) from Swift!"
        }
    }
    ```

2.  **导入自动生成的 Swift 头文件**: 
    - Xcode 会为你的项目自动生成一个特殊的头文件，名为 `<ProjectName>-Swift.h`（例如 `YourProjectName-Swift.h`）。这个文件充当了 Swift 代码到 Objective-C 的桥梁。
    - 在你需要调用 Swift 代码的 Objective-C 实现文件 (`.m`) 中，导入这个自动生成的头文件。

    ```objectivec
    // MyObjectiveCClass.m 或其他 .m 文件
    #import "YourProjectName-Swift.h" // 导入 Swift 桥接头文件
    ```
    *注意：你不需要手动创建这个文件，Xcode 会在编译时生成它。有时 Xcode 可能不会立即识别它，尝试编译一次项目可能会解决问题。*

3.  **确保 Target Membership**: 
    - 确保你的 Swift 文件 (`.swift`) 属于需要调用它的 Objective-C 代码所在的 Target。

### 使用方法

- 在导入了 `<ProjectName>-Swift.h` 的 Objective-C 文件中，你可以像使用普通的 Objective-C 类一样实例化和调用 Swift 类及其标记为 `@objc` 或包含在 `@objcMembers` 类中的方法/属性。

```objectivec
// MyObjectiveCClass.m
#import "MyObjectiveCClass.h"
#import "swift_oc_demo-Swift.h" // 导入 Swift 桥接头文件

@implementation MyObjectiveCClass

- (NSString *)getMessage {
    // 实例化 Swift 类
    MySwiftClass *swiftInstance = [[MySwiftClass alloc] init];
    
    // 调用 Swift 类的方法
    NSString *swiftMessage = [swiftInstance getSwiftMessage];
    NSString *greeting = [swiftInstance greetWithName:@"Objective-C"];
    
    // 组合消息返回
    return [NSString stringWithFormat:@"Hello from Objective-C!\n -> Also, %@\n -> And: %@", swiftMessage, greeting];
}

@end
```

## 总结

通过桥接头文件 (`<ProjectName>-Bridging-Header.h`) 和 Xcode 自动生成的 Swift 头文件 (`<ProjectName>-Swift.h`)，你可以在同一个项目中无缝地混合使用 Swift 和 Objective-C 代码，实现双向调用。