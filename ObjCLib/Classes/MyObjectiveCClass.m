//
//  MyObjectiveCClass.m
//  swift-oc-demo
//
//  Created by Trae AI on 2025/5/5.
//

#import "MyObjectiveCClass.h"
#import "swift_oc_demo-Swift.h" // 1. 导入 Xcode 自动生成的 Swift 头文件

@implementation MyObjectiveCClass

- (NSString *)getMessage {
    // 2. 实例化 Swift 类
    MySwiftClass *swiftInstance = [[MySwiftClass alloc] init];
    
    // 3. 调用 Swift 类的方法
    NSString *swiftMessage = [swiftInstance getSwiftMessage];
    NSString *greeting = [swiftInstance greetWithName:@"Objective-C"];
    
    // 4. 组合消息返回
    return [NSString stringWithFormat:@"Hello from Objective-C!\n -> Also, %@\n -> And: %@", swiftMessage, greeting];
}


// 实现新增的方法
- (void)performComplexActionWithCallback:(void (^)(NSString * _Nonnull))callback {
    NSLog(@"Objective-C: performComplexActionWithCallback called.");
    
    // 实例化 Swift 类
    MySwiftClass *swiftInstance = [[MySwiftClass alloc] init];
    
    // 调用 Swift 类的一个新方法（假设它叫 processDataAndReturnString）
    // 这个方法我们稍后会在 MySwiftClass.swift 中添加
    NSString *resultFromSwift = [swiftInstance processDataAndReturnString:@"Data from Objective-C"];
    
    NSLog(@"Objective-C: Received result from Swift: %@", resultFromSwift);
    
    // 模拟一些耗时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 准备回调给 Swift 的结果
        NSString *finalResult = [NSString stringWithFormat:@"Objective-C processed: %@", resultFromSwift];
        NSLog(@"Objective-C: Executing callback with result: %@", finalResult);
        // 执行 Swift 传入的回调
        if (callback) {
            callback(finalResult);
        }
    });
}

@end