//
//  SecurityCheckViewController.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/12/13.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import UIKit
import CYBAVOLibmsec

class SecurityCheckViewController: UIViewController {
    @IBOutlet weak var ignoreBtn: UIButton!
    @IBOutlet open var securityCheckView: [SecurityCheckView]!
    @IBAction func onIgnore(_ sender: Any) {
     showMain()
    }
    
    @IBOutlet weak var insecureConstrain: NSLayoutConstraint!
    @IBOutlet weak var insecureText: UILabel!
    override func viewDidLoad() {
        ignoreBtn.isHidden = true
        insecureText.isHidden = true
        insecureConstrain.constant = -65
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var states: [State] = [.PASS, .PASS, .PASS]
        var secure: Bool = true
        if(DeviceSecurity.isJailBroken()){
            secure = false
            states[0] = .FATAL
        }
        
        if(DeviceSecurity.isEmulator()){
            secure = false
            states[1] = .FATAL
        }
        
        if(DeviceSecurity.isDebuggingEnabled()){
            states[2] = .WARNING
        }
        runCheckAnimate(texts: ["Jail broken not detected","Emulator not detected","Debugger disabled"]
            , states: states, secure: secure)
    }
    func showMain(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
    func runCheckAnimate(texts: [String], states: [State], secure: Bool){
        for i in 0 ..< texts.count {
            securityCheckView[i].text = texts[i]
            let offset = Double(i+1) * 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + offset) {
                self.securityCheckView[i].postCheck(state: states[i])
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double(texts.count+1) * 0.5) {
            if(secure){
                self.showMain()
            }else{
                self.ignoreBtn.isHidden = false
                self.insecureText.isHidden = false
                self.insecureConstrain.constant = 15
            }
        }
    }
}
