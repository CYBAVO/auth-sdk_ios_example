//
//  NewPairingViewController.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/11/14.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import UIKit
import CYBAVOAuth
import Toast_Swift

class NewPairingViewController: UIViewController {
    var toastView = ToastView()
    public var delegate: ViewControllerDelegate?
    @IBOutlet weak var figure: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var token: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBAction func onSubmitClick(_ sender: Any) {
        guard let code = token.text else{
            return
        }
        dismissKeyboard()
        self.onScan(code: code)
    }
    @IBAction func onButtonClick(_ sender: Any) {
        print("currentTitle\(button.currentTitle)")
        if(button.currentTitle == "Scan"){
            performSegue(withIdentifier: "idQRCodeScan", sender: nil)
        }else{
            if let delegate = self.delegate {
                delegate.viewWillDisappear()
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scan"
        #if DEBUG
        token.isHidden = false
        submitBtn.isHidden = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        #else
        token.isHidden = true
        submitBtn.isHidden = true
        #endif
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "idQRCodeScan" else {
            return
        }
        if let vc = segue.destination as? QRCodeScanController {
            vc.delegate = self
        }
    }
    func chageToFinish(){
        UIUtil.setTintImage(named: "fig_security", imageView: self.figure, tintColor: UIUtil.colorPrimary)
        desc.text = "Congratulations! This device was paired successfully!"
        button.setTitle("DONE", for: .normal)
    }
}
extension NewPairingViewController : QRCodeContentDelegate {
    func onScan(code: String) {
        print("code: \(code), PushDeviceToken:\(PushDeviceToken)")
        toastView.showLoadingView()
        ServiceHolder.get().pair(token: code, pushToken: PushDeviceToken){ result in
            switch result {
            case .success(_):
                self.chageToFinish()
                print("pair onSuccess")
                break
            case .failure(let error):
                ToastView.instance.showToast(content: "\(error.message)(\(error.code))", duration: 2.0)
                print("pair onFailed")
                break
            }
            self.toastView.clear()
        }
        //        addressTextField.text = code
    }
}
