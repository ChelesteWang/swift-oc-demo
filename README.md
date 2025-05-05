# Swift 与 Objective-C 混编 iOS Demo (CocoaPods 模块化)

本项目旨在演示如何使用 CocoaPods 将 Swift 和 Objective-C 代码模块化，并在同一个 iOS 应用中使用它们。

## 项目结构

- **swift-oc-demo/**: 项目主目录
  - `Podfile`: 定义项目依赖，包括本地的 ObjCLib 和 SwiftLib。
  - `ObjCLib.podspec`: ObjCLib Pod 的规范文件。
  - `SwiftLib.podspec`: SwiftLib Pod 的规范文件。
  - `ObjCLib/`: 包含 Objective-C 模块的源代码。
    - `Classes/`: Objective-C 类 (.h, .m)。
  - `SwiftLib/`: 包含 Swift 模块的源代码。
    - `Classes/`: Swift 类和 SwiftUI 视图 (.swift)。
  - `swift-oc-demo/`: 主应用程序 Target。
    - `ContentView.swift`: 使用 SwiftUI 构建的主要视图，将调用两个 Pod 中的代码。
    - `swift_oc_demoApp.swift`: App 入口。
    - `swift-oc-demo-Bridging-Header.h`: (可选) 如果主应用 Target 仍需直接访问 ObjCLib 中的 Objective-C 代码，则需要此文件。
  - `swift-oc-demo.xcworkspace`: Xcode 工作区文件 (使用 CocoaPods 后应打开此文件)。

## 配置步骤

1.  **创建 Podspec 文件**: 为 Objective-C 和 Swift 代码分别创建 `ObjCLib.podspec` 和 `SwiftLib.podspec` 文件。
    - 在 `ObjCLib.podspec` 中，使用 `s.source_files = 'ObjCLib/Classes/**/*.{h,m}'` 指定源文件。
    - 在 `SwiftLib.podspec` 中，使用 `s.source_files = 'SwiftLib/Classes/**/*.swift'` 指定源文件，并添加对 ObjCLib 的依赖 `s.dependency 'ObjCLib', '~> 0.1.0'`。
2.  **创建 Podfile**: 在项目根目录创建 `Podfile`。
3.  **添加本地 Pod 依赖**: 在 `Podfile` 中，为你的主应用 Target 添加对本地 Pod 的引用：
    ```ruby
    platform :ios, '15.0'

    target 'swift-oc-demo' do
      use_frameworks! # Swift Pods 通常需要这个

      # 本地 Pods
      pod 'ObjCLib', :path => './'
      pod 'SwiftLib', :path => './'

      # ... 其他依赖 ...
    end
    ```
4.  **安装 Pods**: 在终端中，导航到项目根目录并运行 `pod install`。
5.  **打开 Workspace**: 关闭任何打开的 `.xcodeproj` 文件，然后打开新生成的 `.xcworkspace` 文件。

## 使用方法

### Pod 间调用

- **SwiftLib 调用 ObjCLib**: 
  - 由于 `SwiftLib.podspec` 中已声明 `s.dependency 'ObjCLib'`, SwiftLib 中的 Swift 代码可以直接 `import ObjCLib` 并使用其中公开的 Objective-C 类。
  - Objective-C 类需要有正确的头文件暴露 (`public_header_files` in podspec or implicitly via `source_files`)。
  ```swift
  // In SwiftLib/Classes/SomeSwiftFile.swift
  import ObjCLib

  func useObjCStuff() {
      let objCInstance = MyObjectiveCClass() // Assuming MyObjectiveCClass is in ObjCLib
      let message = objCInstance.getMessage()
      print("Message from ObjCLib: \(message)")
  }
  ```

- **ObjCLib 调用 SwiftLib**: 
  - 这通常不推荐（避免循环依赖），但如果需要，ObjCLib 需要在其 `.podspec` 中添加对 SwiftLib 的依赖。
  - 在 Objective-C 文件中，需要导入 Swift 模块的头文件: `#import <SwiftLib/SwiftLib-Swift.h>` (模块名通常是 Pod 名称)。
  - Swift 类和方法需要标记为 `@objc` 或 `@objcMembers`。
  ```objectivec
  // In ObjCLib/Classes/SomeObjCFile.m (if ObjCLib depends on SwiftLib)
  #import <SwiftLib/SwiftLib-Swift.h> 

  // ...
  MySwiftClass *swiftInstance = [[MySwiftClass alloc] init];
  NSString *greeting = [swiftInstance greetWithName:@"Objective-C from ObjCLib"];
  NSLog(@"%@", greeting);
  ```

### 主应用调用 Pods

- **主应用 (Swift) 调用 ObjCLib**: 
  - 在 Swift 文件中 `import ObjCLib`。
  - 直接使用 ObjCLib 中公开的 Objective-C 类。
  ```swift
  // In swift-oc-demo/ContentView.swift
  import ObjCLib
  import SwiftLib

  struct ContentView: View {
      let objCInstance = MyObjectiveCClass()
      let swiftInstance = MySwiftClass() // Assuming MySwiftClass is in SwiftLib

      var body: some View {
          VStack {
              Text(objCInstance.getMessage())
              Text(swiftInstance.getSwiftMessage())
              // ... use other components from pods ...
          }
      }
  }
  ```
- **主应用 (Swift) 调用 SwiftLib**: 
  - 在 Swift 文件中 `import SwiftLib`。
  - 直接使用 SwiftLib 中的 Swift 类和结构体。

- **主应用 (Objective-C) 调用 Pods**: 
  - 如果主应用中有 Objective-C 代码需要调用 Pods：
    - 调用 ObjCLib: `#import <ObjCLib/ObjCLib.h>` 或 `#import <ObjCLib/SpecificHeader.h>`。
    - 调用 SwiftLib: `#import <SwiftLib/SwiftLib-Swift.h>` (需要 Swift 类/方法标记 `@objc`)。

### 示例：SwiftUI 使用 Pod 中的组件

假设 `ObjCLib` 包含 `MyObjCViewController` 和 `MyObjCUIView`，而 `SwiftLib` 包含 `MySwiftUIView` 和相应的 `Representable` 封装器。

1.  **在 ObjCLib 中创建 UI 组件**: 
    - `MyObjCViewController.h/.m`
    - `MyObjCUIView.h/.m`
2.  **在 SwiftLib 中创建 Swift UI 和封装器**: 
    - `MySwiftUIView.swift` (可能需要 `@objcMembers` 如果被 ObjC 代码使用)。
    - `MyObjCViewControllerRepresentable.swift`: 使用 `import ObjCLib` 来访问 `MyObjCViewController`。
      ```swift
      // In SwiftLib/Classes/MyObjCViewControllerRepresentable.swift
      import SwiftUI
      import ObjCLib // Import the ObjC pod

      struct MyObjCViewControllerRepresentable: UIViewControllerRepresentable {
          func makeUIViewController(context: Context) -> MyObjCViewController {
              return MyObjCViewController()
          }
          func updateUIViewController(_ uiViewController: MyObjCViewController, context: Context) {}
      }
      ```
    - `MyObjCUIViewRepresentable.swift`: 使用 `import ObjCLib` 来访问 `MyObjCUIView`。
      ```swift
      // In SwiftLib/Classes/MyObjCUIViewRepresentable.swift
      import SwiftUI
      import ObjCLib // Import the ObjC pod

      struct MyObjCUIViewRepresentable: UIViewRepresentable {
          @Binding var text: String

          func makeUIView(context: Context) -> MyObjCUIView {
              return MyObjCUIView()
          }

          func updateUIView(_ uiView: MyObjCUIView, context: Context) {
              uiView.updateLabelText(text) // Assuming updateLabelText exists
          }
      }
      ```
3.  **在主应用 ContentView 中使用**: 
    - `import SwiftLib` (它会传递 ObjCLib 的依赖)。
    - 直接使用 SwiftLib 中定义的 `Representable`。
    ```swift
    // In swift-oc-demo/ContentView.swift
    import SwiftUI
    import SwiftLib // Import the Swift pod

    struct ContentView: View {
        @State private var showingObjCViewController = false
        @State private var textForObjCView: String = "Initial Text"

        var body: some View {
            VStack {
                Button("Show Objective-C VC from Pod") {
                    self.showingObjCViewController = true
                }
                .sheet(isPresented: $showingObjCViewController) {
                    MyObjCViewControllerRepresentable() // From SwiftLib
                }

                MyObjCUIViewRepresentable(text: $textForObjCView) // From SwiftLib
                    .frame(height: 50)
                
                Button("Update ObjC View Text in Pod") {
                    self.textForObjCView = "Updated from SwiftUI"
                }
            }
        }
    }
    ```

### 复杂交互示例 (跨 Pod)

假设 `ComplexComponentView` 在主应用中，`MyObjectiveCClass` 在 `ObjCLib` 中，`MySwiftClass` 在 `SwiftLib` 中。

1.  **主应用 (Swift) 调用 ObjCLib (带回调)**:
    - `ComplexComponentView.swift` (主应用) `import ObjCLib`。
    - 调用 `MyObjectiveCClass` 的 `performComplexActionWithCallback:` 方法，传递回调闭包。
    ```swift
    // In swift-oc-demo/ComplexComponentView.swift
    import ObjCLib
    // ...
    let objCInstance = MyObjectiveCClass() // From ObjCLib
    // ...
    objCInstance.performComplexAction { result in
        // ... update UI ...
    }
    ```

2.  **ObjCLib 调用 SwiftLib**: 
    - `MyObjectiveCClass.m` (ObjCLib) 需要 `#import <SwiftLib/SwiftLib-Swift.h>` (假设 ObjCLib 依赖 SwiftLib，或者反过来，SwiftLib 依赖 ObjCLib 且 MySwiftClass 在 ObjCLib 中，这取决于你的设计)。
    - 实例化 `MySwiftClass` (来自 SwiftLib) 并调用其方法。
    ```objectivec
    // In ObjCLib/Classes/MyObjectiveCClass.m
    #import <SwiftLib/SwiftLib-Swift.h> // Assuming ObjCLib depends on SwiftLib
    // ...
    - (void)performComplexActionWithCallback:(void (^)(NSString * _Nullable))callback {
        MySwiftClass *swiftInstance = [[MySwiftClass alloc] init]; // From SwiftLib
        NSString *resultFromSwift = [swiftInstance processDataAndReturnString:@"Data from ObjCLib"];
        // ... (async work) ...
        NSString *finalResult = [NSString stringWithFormat:@"ObjC processed: %@", resultFromSwift];
        if (callback) {
            callback(finalResult);
        }
    }
    ```

3.  **回调执行**: Objective-C 代码执行从主应用传入的 Swift 闭包。

这个流程展示了通过 Pods 进行模块化后，如何在不同模块和主应用之间进行交互和回调。

### Swift 使用 Objective-C UIView (`UIViewRepresentable`)

我们还演示了如何将一个用 Objective-C 编写的自定义 `UIView` 子类 (`MyObjCUIView`) 集成到 SwiftUI 视图层次结构中。

1.  **创建 Objective-C UIView**: 
    - 创建 `MyObjCUIView.h` 和 `MyObjCUIView.m`。
    - 这个简单的 UIView 包含一个 UILabel，并提供一个方法 `updateLabelText:` 来更新标签文本。

2.  **更新桥接头文件**:
    - 在 `swift-oc-demo-Bridging-Header.h` 中导入 `#import "MyObjCUIView.h"`，使其对 Swift 可见。

3.  **创建 Swift UIViewRepresentable**: 
    - 创建 `MyObjCUIViewRepresentable.swift`。
    - 这个结构体遵循 `UIViewRepresentable` 协议。
    - `makeUIView(context:)` 方法负责创建 `MyObjCUIView` 实例。
    - `updateUIView(_:context:)` 方法负责在 SwiftUI 状态变化时更新 `MyObjCUIView`。我们使用 `@Binding var text: String` 将 SwiftUI 的状态传递给 Objective-C 视图。
    ```swift
    // 在 MyObjCUIViewRepresentable.swift 中
    struct MyObjCUIViewRepresentable: UIViewRepresentable {
        @Binding var text: String

        func makeUIView(context: Context) -> MyObjCUIView {
            return MyObjCUIView()
        }

        func updateUIView(_ uiView: MyObjCUIView, context: Context) {
            uiView.updateLabelText(text)
        }
    }
    ```

4.  **在 SwiftUI 中使用**: 
    - 在 `ContentView.swift` 中，像使用普通 SwiftUI 视图一样使用 `MyObjCUIViewRepresentable`。
    - 通过 `@State` 变量和 `@Binding` 将 SwiftUI 的数据绑定到 Objective-C 视图。
    ```swift
    // 在 ContentView.swift 中
    @State private var textForObjCView: String = "Initial Text"

    // ... 在 body 中 ...
    MyObjCUIViewRepresentable(text: $textForObjCView)
        .frame(height: 50)
    Button("Update ObjC View Text") {
        self.textForObjCView = "Updated from SwiftUI"
    }
    ```

这个示例展示了如何利用 `UIViewRepresentable` 将 UIKit 组件（无论是系统提供的还是自定义的 Objective-C 组件）无缝集成到现代 SwiftUI 应用中。

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

请查看主应用 (`swift-oc-demo/`) 以及 `ObjCLib/Classes/` 和 `SwiftLib/Classes/` 目录中的示例代码，了解模块化后的具体实现。