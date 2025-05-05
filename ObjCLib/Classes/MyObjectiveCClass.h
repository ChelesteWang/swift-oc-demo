//
//  MyObjectiveCClass.h
//  swift-oc-demo
//
//  Created by Trae AI on 2025/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyObjectiveCClass : NSObject

- (NSString *)getMessage;

// 新增一个方法，接受一个 Swift 闭包作为回调
- (void)performComplexActionWithCallback:(void (^)(NSString *resultFromSwift))callback;

@end

NS_ASSUME_NONNULL_END