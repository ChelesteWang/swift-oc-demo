//
//  MySwiftUIView.swift
//  swift-oc-demo
//
//  Created by Trae AI on 2024/07/26.
//

import UIKit

// 必须继承自 NSObject 并标记 @objcMembers 才能在 Objective-C 中使用
@objcMembers
class MySwiftUIView: UIView {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Hello from Swift UIView!"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .systemBlue
        layer.cornerRadius = 10
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10)
        ])
    }
    
    // 如果需要从 Objective-C 调用方法，需要标记 @objc
    @objc func configureWithText(_ text: String) {
        label.text = text
    }
}