//
//  MyObjCViewController.m
//  swift-oc-demo
//
//  Created by Trae AI on 2024/07/26.
//

#import "MyObjCViewController.h"
#import "swift_oc_demo-Swift.h" // 导入 Swift 桥接头文件

@interface MyObjCViewController ()

@end

@implementation MyObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemGray6Color];
    self.title = @"Objective-C VC";

    // 创建 Swift UIView 实例
    MySwiftUIView *swiftUIView = [[MySwiftUIView alloc] initWithFrame:CGRectZero];
    swiftUIView.translatesAutoresizingMaskIntoConstraints = NO; // 使用 Auto Layout

    // 将 Swift UIView 添加到视图层级
    [self.view addSubview:swiftUIView];

    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [swiftUIView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [swiftUIView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [swiftUIView.widthAnchor constraintEqualToConstant:250],
        [swiftUIView.heightAnchor constraintEqualToConstant:100]
    ]];
    
    // 可以调用 Swift UIView 的方法 (如果定义了 @objc 方法)
    // [swiftUIView configureWithText:@"Hello from ObjC VC"];
}

@end