//
//  MyObjCViewControllerRepresentable.swift
//  swift-oc-demo
//
//  Created by Trae AI on 2024/07/26.
//

import SwiftUI
import UIKit

struct MyObjCViewControllerRepresentable: UIViewControllerRepresentable {
    
    // 可以添加 @Binding 变量来传递数据给 Objective-C ViewController (如果需要)
    // @Binding var dataToPass: String 

    func makeUIViewController(context: Context) -> UINavigationController {
        // 创建 Objective-C ViewController 实例
        let objCViewController = MyObjCViewController()
        // 如果需要传递数据，可以在这里设置
        // objCViewController.data = dataToPass
        
        // 通常嵌入到 UINavigationController 中以便有关闭按钮
        let navigationController = UINavigationController(rootViewController: objCViewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // 当 SwiftUI 状态变化时，可以在这里更新 ViewController
        // 例如，如果传递了 @Binding 数据:
        // if let objCVC = uiViewController.viewControllers.first as? MyObjCViewController {
        //     objCVC.updateData(dataToPass)
        // }
    }
    
    // 可选：添加 Coordinator 来处理委托回调等
    /*
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: MyObjCViewControllerRepresentable

        init(_ parent: MyObjCViewControllerRepresentable) {
            self.parent = parent
        }
        
        // 实现 ViewController 的代理方法等
    }
    */
}