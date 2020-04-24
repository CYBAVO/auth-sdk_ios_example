//
//  UIImageView.swift
//  CYBAVOAuthDemo
//
//  Created by evahsu on 2020/1/8.
//  Copyright © 2020 Cybavo. All rights reserved.
//

import UIKit
extension UIImageView {
    func load(urlStr: String, defaultImageName: String, tintColor: UIColor? = nil) {
        guard let url = URL(string: urlStr) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }else{
                    print("no")
                    guard let color = tintColor, let view = self else{
                        self?.image = UIImage(named: defaultImageName)
                        return
                    }
                    UIUtil.setTintImage(named: defaultImageName, imageView: view, tintColor: color)
                }
            }
        }
    }
}
