import SwiftUI

struct ContentView: View {
    // 实例 Objective-C 类
    let objCInstance = MyObjectiveCClass()
    // 状态变量，用于存储从 Objective-C 返回的消息
    @State private var messageFromObjC: String = "Loading..."
    // 状态变量，用于存储复杂交互的回调结果
    @State private var resultFromObjCCallback: String = "Waiting for complex action..."
    // 状态变量，用于控制 Objective-C UIView 的文本
    @State private var textForObjCView: String = "Initial Text for ObjC View"
    // 状态变量，用于控制是否显示 Objective-C ViewController
    @State private var showingObjCViewController = false

    var body: some View {
        VStack(spacing: 20) {
            Text("SwiftUI View")
                .font(.largeTitle)

            // --- 基础 Swift 调用 Objective-C --- //
            Text("Basic Swift -> ObjC Call")
                .font(.headline)
            Text(messageFromObjC)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            // --- 复杂交互：Swift -> ObjC -> Swift -> Callback -> Swift --- //
            ComplexComponentView()

            // --- Swift 调用 Objective-C UIView --- //
            Text("Swift using ObjC UIView")
                .font(.headline)
            MyObjCUIViewRepresentable(text: $textForObjCView)
                .frame(height: 50)
                .border(Color.blue)
            Button("Update ObjC View Text") {
                self.textForObjCView = "Updated from SwiftUI: \(Int.random(in: 1...100))"
            }
            
            Divider()
            
            // --- Swift 呈现 Objective-C ViewController (内嵌 Swift UIView) --- //
            Text("Swift presenting ObjC VC")
                .font(.headline)
            Button("Show Objective-C VC") {
                self.showingObjCViewController = true
            }

        }
        .padding()
        .onAppear {
            // 视图出现时，调用 Objective-C 方法获取消息
            self.messageFromObjC = objCInstance.getMessage() ?? "Failed to get message"
        }
        // 使用 .sheet 来呈现 Objective-C ViewController
        .sheet(isPresented: $showingObjCViewController) {
            MyObjCViewControllerRepresentable()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
