//
//  PinCodeActionViewController.swift
//  CYBAVOAuth
//
//  Created by Eva Hsu on 2019/11/22.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import UIKit
import CYBAVOAuth
public class PinCodeActionViewController: UIViewController{
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

    @IBOutlet weak var topConstrain: NSLayoutConstraint!
    @IBOutlet weak var certerYConstrain: NSLayoutConstraint!
    var pinInputIndecatorView: PinInputIndicatorView?
    //MARK: Property
    var pinInputView: NumericPinCodeInputView?
    var styleAttr: CYBAVOAuth.StyleAttr = CYBAVOAuth.StyleAttr()
    let pinCodeLength = 6
    public var delegate: ViewControllerDelegate?
    @IBAction func onAccept(_ sender: Any) {
        onMessage(accept: true)
    }
    @IBAction func onReject(_ sender: Any) {
        pinInputIndecatorView!.inputDotCount = 0
        pinInputView?.clear()
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
        guard let pinInputView = self.pinInputView else{
            return
        }
        //Create an optional action
        let nextAction: UIAlertAction = accept ?
            UIAlertAction(title: "Confirm", style: .default) { action -> Void in
                if let text = alertController.textFields?.first?.text {
                    self.toggleLoading(show: true, a: a)
                    ServiceHolder.get().approve(token: a.token, deviceId: a.deviceId, pinSecret: pinInputView.submit(), message: text){ result in
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
        print("toggleButton accept:\(!show && pinInputView!.getCurrentLength() >= pinCodeLength)")
        toggleButton(btn: acceptBtn, enable: !show && pinInputView!.getCurrentLength() >= pinCodeLength)
        toggleButton(btn: rejectBtn, enable: !show)
        pinInputView?.setDiabled(disabled: show)
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
          pinInputIndecatorView = PinInputIndicatorView(frame: CGRect(x: time.bounds.minX, y: time.bounds.minY + time.bounds.height + 10, width: 250, height: 35))
        title = a.getTitle()
          
          pinInputView = NumericPinCodeInputView(frame: CGRect(x: pinInputIndecatorView!.bounds.minX, y: pinInputIndecatorView!.bounds.minY + pinInputIndecatorView!.bounds.height + 10, width: 250, height: 400))
          pinInputView?.setOnPinInputListener(delegate: self)
          let lightGray = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
          let darkGray = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 58.0/255.0, alpha: 1.0)
          styleAttr =  CYBAVOAuth.StyleAttr(
              fixedOrder: false,
              disabled: false,
              buttonWidth: 66,
              buttonHeight: 66,
              horizontalSpacing: 15,
              verticalSpacing: 7,
              buttonTextColor: darkGray,
              buttonTextColorPressed: lightGray,
              buttonTextColorDisabled: UIColor.lightGray,
              buttonBackgroundColor: lightGray,
              buttonBackgroundColorPressed: darkGray,
              buttonBackgroundColorDisabled: UIColor.darkGray,
              buttonBorderRadius: 33,
              buttonBorderWidth: 0,
              buttonBorderColor: UIColor.green,
              buttonBorderColorPressed: UIColor.blue,
              buttonBorderColorDisabled: UIColor.orange,
              backspaceButtonWidth: 66,
              backspaceButtonHeight: 66,
              backspaceButtonTextColor: darkGray,
              backspaceButtonTextColorPressed: lightGray,
              backspaceButtonTextColorDisabled: UIColor.lightGray,
              backspaceButtonBackgroundColor: lightGray,
              backspaceButtonBackgroundColorPressed: darkGray,
              backspaceButtonBackgroundColorDisabled: UIColor.darkGray,
              backspaceButtonBorderRadius: 33,
              backspaceButtonBorderWidth: 0,
              backspaceButtonBorderColor: UIColor.blue,
              backspaceButtonBorderColorPressed: UIColor.red,
              backspaceButtonBorderColorDisabled: UIColor.black)

          pinInputView?.styleAttr = styleAttr
          pinInputIndecatorView!.strokeColor = darkGray
          pinInputIndecatorView!.fillColor = lightGray
          pinInputIndecatorView!.drawText = true
          pinInputIndecatorView!.filledPlaceholder = "*"
          pinInputIndecatorView!.unfilledPlaceholder = "-"
          
          mainStackView.addArrangedSubview(pinInputIndecatorView!)
          mainStackView.addArrangedSubview(pinInputView!)
      
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
            pinInputView?.isHidden = false
            pinInputIndecatorView?.isHidden = false
            topConstrain.isActive = true
            certerYConstrain.isActive = false
            figure.isHidden = true
        }else{
            acceptBtn.isHidden = true
            rejectBtn.isHidden = true
            result.text = "\(a.getStateDesc()) / \(a.getUserActionDesc())"
            result.isHidden = false
            resultTime.text =  UIUtil.getDateFormateText(dateFormat: "yyyy-M-d HH:mm:ss", from: Date(timeIntervalSince1970: Double(a.updatedTime)))
            resultTime.isHidden = false
            pinInputView?.isHidden = true
            pinInputIndecatorView?.isHidden = true
            topConstrain.isActive = false
            certerYConstrain.isActive = true
            figure.isHidden = false
            if(a.userAction == TwoFactorAuthenticationAction.UserAction.ACCEPT.rawValue){
                UIUtil.setTintImage(named: "fig_pin_code", imageView: figure, tintColor: UIUtil.colorAccept)
                result.textColor = UIUtil.colorAccept
            }else{
                UIUtil.setTintImage(named: "fig_pin_code", imageView: figure, tintColor: UIUtil.colorReject)
                result.textColor = UIUtil.colorReject
            }
        }
        toggleLoading(show: false, a: a)
        toggleButton(btn: acceptBtn, enable: false)
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

extension PinCodeActionViewController: CYBAVOAuth.OnPinInputListener {
    public func onChanged(length: Int) {
        pinInputIndecatorView!.inputDotCount = length
        toggleButton(btn: acceptBtn, enable: length == pinInputView!.getMaxLength())
    }
}

extension PinCodeActionViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? ActionsController {
            controller.refresh2FaActions()
        }
    }
}


