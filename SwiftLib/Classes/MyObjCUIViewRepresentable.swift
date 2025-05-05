na//
//  MyObjCUIViewRepresentable.swift
//  swift-oc-demo
//
//  Created by Trae AI on 2024/07/26.
//

import SwiftUI
import UIKit

struct MyObjCUIViewRepresentable: UIViewRepresentable {
    // 可以添加 @Binding 属性来从 SwiftUI 向 UIKit 传递数据
    @Binding var text: String

    // 创建底层的 UIView
    func makeUIView(context: Context) -> MyObjCUIView {
        let uiView = MyObjCUIView()
        // 可以在这里进行初始配置
        return uiView
    }

    // 当 SwiftUI 视图的状态改变时，更新底层的 UIView
    func updateUIView(_ uiView: MyObjCUIView, context: Context) {
        // 将 SwiftUI 中的 text 状态更新到 Objective-C UIView 的 label 上
        uiView.updateLabelText(text)
    }

    // 如果需要协调 UIKit 视图的委托（delegate），可以在这里创建 Coordinator
    // func makeCoordinator() -> Coordinator {
    //     Coordinator(self)
    // }
    //
    // class Coordinator: NSObject {
    //     var parent: MyObjCUIViewRepresentable
    //
    //     init(_ parent: MyObjCUIViewRepresentable) {
    //         self.parent = parent
    //     }
    //     // 在这里实现委托方法
    // }
}

struct MyObjCUIViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        // 提供一个预览用的状态变量
        @State var previewText = "Preview Text"
        MyObjCUIViewRepresentable(text: $previewText)
            .frame(width: 200, height: 100)
    }
}