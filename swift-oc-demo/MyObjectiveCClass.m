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

@end