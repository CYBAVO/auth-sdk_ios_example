//
//  OtpActionViewController.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/11/25.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import UIKit
import CYBAVOAuth
public class OtpActionViewController: UIViewController{
    @IBOutlet weak var type: UILabel!
    var toastView = ToastView()
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var resultTime: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var time: UILabel!
    public var action: ActionArgument?
    @IBOutlet weak var figure: UIImageView!

    public var delegate: ViewControllerDelegate?
    @IBAction func onAccept(_ sender: Any) {
        onMessage(accept: true)
    }
    @IBAction func onReject(_ sender: Any) {
        onMessage(accept: false)
    }
    func onMessage(accept: Bool){
        let alertController: UIAlertController = UIAlertController(title: "Input message", message: nil, preferredStyle: .alert)

        //cancel button
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //cancel code
        }
        alertController.addAction(cancelAction)
        
        guard let a = action else {
            self.dismiss(animated: true)
            return
        }
        //Create an optional action
        let nextAction: UIAlertAction = accept ?
            UIAlertAction(title: "Confirm", style: .default) { action -> Void in
                if let text = alertController.textFields?.first?.text {
                    self.toggleLoading(show: true, a: a)
                    ServiceHolder.get().approve(token: a.token, deviceId: a.deviceId, message: text){ result in
                        switch result {
                        case .success(let result):
                            print("approve success \(result)")
                            if let delegate = self.delegate {
                                delegate.viewWillDisappear()
                            }
                            self.navigationController?.popViewController(animated: true)
                            break
                        case .failure(let error):
                            print("approve fail \(error)")
                            ToastView.instance.showToast(content: "\(error.message)(\(error.code))", duration: 2.0)
                            break
                        }
                        self.toggleLoading(show: false, a: a)
                    }
                }
            } :
            UIAlertAction(title: "Confirm", style: .default) { action -> Void in
                if let text = alertController.textFields?.first?.text {
                    self.toggleLoading(show: true, a: a)
                    ServiceHolder.get().reject(token: a.token, deviceId: a.deviceId, message: text){ result in
                        switch result {
                        case .success(let result):
                            print("reject success \(result)")
                            if let delegate = self.delegate {
                                delegate.viewWillDisappear()
                            }
                            self.navigationController?.popViewController(animated: true)
                            break
                        case .failure(let error):
                            print("reject fail \(error)")
                            ToastView.instance.showToast(content: "\(error.message)(\(error.code))", duration: 2.0)
                            break
                        }

                        self.toggleLoading(show: false, a: a)
                    }
                }
            }
        alertController.addAction(nextAction)

        //Add text field
        alertController.addTextField { (textField) -> Void in
            textField.setBottomBorder()
        }
        //Present the AlertController
        present(alertController, animated: true, completion: nil)
    }
    func toggleLoading(show: Bool, a: ActionArgument){
        toggleButton(btn: acceptBtn, enable: !show )
        toggleButton(btn: rejectBtn, enable: !show)
//        pinInputIndecatorView?.isHidden = (show || a.state != TwoFactorAuthenticationAction.State.CREATED.rawValue)
           if(show){
            toastView.showLoadingView()
           }else{
            toastView.clear()
           }
       }
    
//    override public func viewWillDisappear(_ animated : Bool) {
//        super.viewWillDisappear(animated)
//        if let delegate = self.delegate {
//            delegate.viewWillDisappear()
//        }
//    }
    override public func viewDidLoad() {
          super.viewDidLoad()
        guard let a = action else {
            self.dismiss(animated: true)
            return
        }
        navigationController?.delegate = self
      
        if(a.messageType == 0){
            type.isHidden = true
        }else{
            type.isHidden = false
            type.text = "\(a.messageType)"
        }
        body.text = a.getBody()
        data.text = a.messageData
        data.isHidden = a.messageData == ""

        time.text = UIUtil.getDateFormateText(dateFormat: "yyyy-M-d HH:mm:ss", from: Date(timeIntervalSince1970: Double(a.createTime)))
        
        if(a.rejectable){
            acceptBtn.titleLabel!.text = "ACCEPT"
            rejectBtn.isHidden = false
        }else{
            acceptBtn.titleLabel!.text = "SUBMIT"
            rejectBtn.isHidden = true
        }
        
        if(a.state == TwoFactorAuthenticationAction.State.CREATED.rawValue){
            acceptBtn.isHidden = false
            rejectBtn.isHidden = false
            result.isHidden = true
            resultTime.isHidden = true
            UIUtil.setTintImage(named: "fig_otp", imageView: figure, tintColor: UIUtil.colorPrimary)
            result.textColor = UIUtil.colorAccept
        }else{
            acceptBtn.isHidden = true
            rejectBtn.isHidden = true
            result.text = "\(a.getStateDesc()) / \(a.getUserActionDesc())"
            result.isHidden = false
            resultTime.text =  UIUtil.getDateFormateText(dateFormat: "yyyy-M-d HH:mm:ss", from: Date(timeIntervalSince1970: Double(a.updatedTime)))
            resultTime.isHidden = false
            if(a.userAction == TwoFactorAuthenticationAction.UserAction.ACCEPT.rawValue){
                UIUtil.setTintImage(named: "fig_otp", imageView: figure, tintColor: UIUtil.colorAccept)
                result.textColor = UIUtil.colorAccept
            }else{
                UIUtil.setTintImage(named: "fig_otp", imageView: figure, tintColor: UIUtil.colorReject)
                result.textColor = UIUtil.colorReject
            }
        }
        toggleLoading(show: false, a: a)
      }
    
    func toggleButton(btn: UIButton, enable: Bool){
        if(enable){
            acceptBtn.isEnabled = true
            acceptBtn.alpha = 1
        }else{
            acceptBtn.isEnabled = false
            acceptBtn.alpha = 0.4
        }
    }
}

extension OtpActionViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? ActionsController {
            controller.refresh2FaActions()
        }
    }
}
