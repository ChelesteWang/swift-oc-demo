//
//  MySwiftClass.swift
//  swift-oc-demo
//
//  Created by Trae AI on 2025/5/6.
//

import Foundation

// 1. 继承 NSObject 并使用 @objcMembers 或 @objc 来暴露给 Objective-C
@objcMembers // 或者在需要暴露的成员前加 @objc
class MySwiftClass: NSObject {

    // 2. 定义一个可以被 Objective-C 调用的方法
    func getSwiftMessage() -> String {
        return "Hello from Swift!"
    }
    
    // 3. 定义一个带参数的方法
    func greet(name: String) -> String {
        return "Hello, \(name) from Swift!"
    }
    
    // 4. 新增一个方法，供 Objective-C 调用
    func processDataAndReturnString(_ data: String) -> String {
        print("Swift: processDataAndReturnString called with data: \(data)")
        // 对来自 Objective-C 的数据进行一些处理
        let processedString = "Swift processed: [\(data)]"
        return processedString
    }
}