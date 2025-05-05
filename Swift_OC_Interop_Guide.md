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

### 在 Swift 中使用 Objective-C 代码

完成上述配置后，你就可以在任何 Swift 文件中直接使用桥接头文件中导入的 Objective-C 类了，就像它们是原生的 Swift 类一样。

```swift
// ContentView.swift (或其他 Swift 文件)
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("SwiftUI View")
            Button("Call Objective-C") {
                let objCInstance = MyObjectiveCClass() // 直接实例化
                let message = objCInstance.getMessage() // 直接调用方法
                print(message) // 输出: Hello from Objective-C!
            }
        }
    }
}
```

## 2. Objective-C 调用 Swift

虽然不如 Swift 调用 OC 常见，但在维护旧有 OC 代码库并引入新的 Swift 功能时，这很有用。

### 配置步骤

1.  **确保 Swift 类/方法对 Objective-C 可见**:
    - Swift 类需要继承自 `NSObject` 或其他 Objective-C 类。
    - 需要暴露给 Objective-C 的 Swift 类、属性、方法等，必须使用 `@objc` 关键字进行标记。
    - 如果整个类都需要暴露，可以在类定义前加上 `@objcMembers`。
    - Swift 的结构体 (Struct) 和枚举 (Enum) 如果没有 `@objc` 标记，通常不能直接在 Objective-C 中使用（除非是 Int 类型的原始值枚举）。

    ```swift
    // MySwiftClass.swift
    import Foundation

    @objcMembers // 让整个类及其成员对 OC 可见
    class MySwiftClass: NSObject {
        var swiftProperty: String = "Initial Swift Property"

        @objc func doSomethingFromSwift() {
            print("Swift method called from Objective-C")
        }

        @objc func process(message: String) -> String {
            return "Processed in Swift: \(message)"
        }
        
        // 如果不使用 @objcMembers, 需要单独标记
        // @objc var anotherProperty: Int = 10
        // @objc func anotherSwiftMethod() {}
    }
    ```

2.  **导入自动生成的 Swift 头文件**: 
    - Xcode 会为你的项目自动生成一个特殊的头文件，名为 `<ProjectName>-Swift.h` (例如 `YourProjectName-Swift.h`)。这个文件包含了所有标记为 `@objc` 或继承自 `NSObject` 的 Swift 声明的 Objective-C 版本。
    - 在需要调用 Swift 代码的 Objective-C 实现文件 (`.m`) 中，导入这个自动生成的头文件。
    ```objectivec
    // SomeObjectiveCFile.m
    #import "SomeObjectiveCFile.h"
    #import "YourProjectName-Swift.h" // 导入自动生成的 Swift 头文件

    @implementation SomeObjectiveCFile

    - (void)callSwiftCode {
        MySwiftClass *swiftInstance = [[MySwiftClass alloc] init]; // 像普通 OC 类一样创建实例
        
        NSLog(@"Accessing Swift property: %@", swiftInstance.swiftProperty);
        swiftInstance.swiftProperty = @"Modified by Objective-C"; // 修改属性
        NSLog(@"Modified Swift property: %@", swiftInstance.swiftProperty);
        
        [swiftInstance doSomethingFromSwift]; // 调用 Swift 方法
        
        NSString *result = [swiftInstance processWithMessage:@"Data from OC"]; // 调用带参数和返回值的方法
        NSLog(@"Result from Swift: %@", result);
    }

    @end
    ```

### 注意事项

- **命名冲突**: 确保 Swift 和 Objective-C 之间没有命名冲突。
- **Swift 特性**: 很多 Swift 特有的特性（如泛型、结构体、元组、可选类型的高级用法等）不能直接桥接到 Objective-C。你需要提供 Objective-C 兼容的接口。
- **构建顺序**: Xcode 会先编译 Swift 代码，生成 `-Swift.h` 文件，然后编译 Objective-C 代码。

## 总结

通过桥接头文件 (`<ProjectName>-Bridging-Header.h`) 和自动生成的 Swift 头文件 (`<ProjectName>-Swift.h`)，以及 `@objc` 关键字，可以在 Swift 和 Objective-C 之间实现无缝的双向调用，充分利用两种语言的优势。