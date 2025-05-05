//
//  ContentView.swift
//  swift-oc-demo
//
//  Created by ByteDance on 2025/5/5.
//

import SwiftUI

struct ContentView: View {
    // 1. 实例化 Objective-C 类
    let objCInstance = MyObjectiveCClass()
    // 2. 调用 Objective-C 方法获取消息
    @State private var messageFromObjectiveC: String = ""

    var body: some View {
        VStack {
            Image(systemName: "swift") // Changed icon for fun
                .imageScale(.large)
                .foregroundStyle(.orange)
            Text("SwiftUI View")
                .font(.title)
            
            // 3. 显示从 Objective-C 获取的消息
            Text(messageFromObjectiveC)
                .padding()
                .onAppear {
                    // 在视图出现时获取消息
                    self.messageFromObjectiveC = objCInstance.getMessage()
                }
            
            Button("Get Message from ObjC Again") {
                // 按钮再次调用 Objective-C 方法
                self.messageFromObjectiveC = objCInstance.getMessage() + " (Updated)"
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
