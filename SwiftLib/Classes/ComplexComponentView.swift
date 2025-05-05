//
//  ComplexComponentView.swift
//  swift-oc-demo
//
//  Created by Trae AI on 2025/5/7.
//

import SwiftUI

struct ComplexComponentView: View {
    // 1. 实例化 Objective-C 类
    let objCInstance = MyObjectiveCClass()
    
    // 2. 用于存储从 Objective-C 回调接收到的结果
    @State private var resultFromObjCCallback: String = "Waiting for callback..."
    // 3. 用于存储直接从 Objective-C 获取的消息
    @State private var directMessageFromObjC: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Complex Interaction Component")
                .font(.headline)
            
            Divider()
            
            // 显示直接从 Objective-C 获取的消息
            Text("Direct Message from ObjC:")
            Text(directMessageFromObjC)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .onAppear {
                    // 视图出现时，直接调用 OC 方法获取消息
                    self.directMessageFromObjC = objCInstance.getMessage()
                }
            
            Divider()
            
            // 显示通过回调从 Objective-C 获取的结果
            Text("Result from ObjC Callback:")
            Text(resultFromObjCCallback)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(5)
            
            // 按钮触发 Objective-C 的复杂操作，并通过回调更新 Swift UI
            Button("Trigger Complex ObjC Action") {
                print("SwiftUI: Button tapped, calling performComplexActionWithCallback")
                // 调用 Objective-C 方法，并传入一个 Swift 闭包作为回调
                objCInstance.performComplexAction { result in
                    print("SwiftUI: Received callback from Objective-C with result: \(result ?? \"nil\")")
                    // 在主线程更新状态变量，从而更新 UI
                    DispatchQueue.main.async {
                        self.resultFromObjCCallback = result ?? "Callback returned nil"
                    }
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .border(Color.green, width: 1)
        .padding()
    }
}

struct ComplexComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ComplexComponentView()
    }
}