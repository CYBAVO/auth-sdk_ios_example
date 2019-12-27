//
//  SecurityCheckView.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/12/16.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import Foundation
import UIKit

public enum State {
    case FATAL, WARNING, PASS
}

public class SecurityCheckView: UIView{
    fileprivate var label = UILabel()
    fileprivate var indicator = UIActivityIndicatorView()
    fileprivate var icon = UIImageView()
    
    public var text: String = "Detecting Emulator"{
        didSet {
            apply()
        }
    }
    let screenRect = UIScreen.main.bounds
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func apply(){
        let width = text.count * 9
        let frm: CGRect = label.frame
        label.text = text
        label.frame = CGRect(x: 0, y: frm.origin.y, width: CGFloat(width), height: frm.size.height)
        indicator.frame = CGRect(x: 0, y: frm.origin.y, width: 20, height: 20)
//        icon.frame = CGRect(x: 0, y: frm.origin.y, width: 20, height: 20)
    }
    public func postCheck(state: State){
        switch(state){
        case .FATAL:
            UIUtil.setTintImage(named: "ic_secure_fail", imageView: icon, tintColor: UIUtil.colorReject)
            break
        case .WARNING:
            UIUtil.setTintImage(named: "ic_secure_warning", imageView: icon, tintColor: UIUtil.colorWarning)
            break
        case .PASS:
            UIUtil.setTintImage(named: "ic_secure_pass", imageView: icon, tintColor: UIColor.white)
            break
        }
        indicator.stopAnimating()
        icon.isHidden = false
        
    }
}

extension SecurityCheckView{
    
    func initialize(){
        label.textColor = UIColor.white
        addSubview(label)
        addSubview(indicator)
        addSubview(icon)
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        icon.isHidden = true
        NSLayoutConstraint.addEqualConstraintsFromSubView(label, toSuperView: self)
        NSLayoutConstraint.addEqualConstraintsFromSubViewRight(indicator, toSuperView: self)
        NSLayoutConstraint.addEqualConstraintsFromSubViewRight(icon, toSuperView: self)
    }
}

extension NSLayoutConstraint {
    class func addConstraints(fromView view: UIView, toView baseView: UIView, constraintInsets insets: UIEdgeInsets) {
        let topConstraint = baseView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top)
        let bottomConstraint = baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
        let leftConstraint = baseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -insets.left)
//        let rightConstraint = baseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leftConstraint])
    }
    
    class func addEqualConstraintsFromSubView(_ subView: UIView, toSuperView superView: UIView) {
        superView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.addConstraints(fromView: subView, toView: superView, constraintInsets: UIEdgeInsets.zero)
    }
    
    class func addEqualConstraintsFromSubViewRight(_ subView: UIView, toSuperView superView: UIView) {
        superView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.addConstraintsRight(fromView: subView, toView: superView, constraintInsets: UIEdgeInsets.zero)
    }
    class func addConstraintsRight(fromView view: UIView, toView baseView: UIView, constraintInsets insets: UIEdgeInsets) {
//        baseView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top)
//        let topConstraint = baseView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top)
//        let bottomConstraint = baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
//        let leftConstraint = baseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -insets.left)
        let rightConstraint = baseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right)
        NSLayoutConstraint.activate([rightConstraint])
    }
}
