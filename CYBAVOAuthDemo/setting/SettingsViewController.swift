//
//  SecondViewController.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/11/14.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import UIKit
import CYBAVOAuth
class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var endpoint: UILabel!
    @IBOutlet weak var apicode: UILabel!
    @IBOutlet weak var sdkVersion: UILabel!
    
    @IBOutlet weak var pairDesc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshPairDesc()
        refreshDevInfo()
        refreshSdkInfo()
        ServiceHolder.get().addPairingStateListener(listener: self)
    }
    
    func refreshPairDesc(){
        let pairings = ServiceHolder.get().getPairings()
        pairDesc.text = "\(pairings.count) pairing(s)"
    }
    
    func refreshDevInfo(){
        endpoint.text = UserDefaults.standard.string(forKey: "endpoints") ?? ""
        apicode.text = UserDefaults.standard.string(forKey: "apicode") ?? ""
    }
    func refreshSdkInfo(){
        let info =  Authenticator.getSDKInfo()
        sdkVersion.text = "\(info["VERSION_NAME"] ?? "") - \(info["BUILD_TYPE"] ?? "")"
    }
    func showInputDialog(title: String, key: String){

        let alertController: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in}
        let nextAction = UIAlertAction(title: "Confirm", style: .default) { action -> Void in
            if let text = alertController.textFields?.first?.text {
                UserDefaults.standard.setValue(text, forKey: key)
                self.refreshDevInfo()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(nextAction)

        //Add text field
        alertController.addTextField { (textField) -> Void in
            textField.setBottomBorder()
        }
        //Present the AlertController
        present(alertController, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section  == 0){
            performSegue(withIdentifier: "idManagePairing", sender: nil)
            return
        }
        switch indexPath.row{
            case 0:
                showInputDialog(title:"Service endpoint", key: "endpoints")
                break
            case 1:
                showInputDialog(title:"Api code", key: "apicode")
                break
            default:
                break
        }
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
//        view.tintColor = UIUtil.colorPrimary
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor =  UIColor.darkGray
    }
}

extension SettingsViewController : PairingStateListener{
    func onPairingStateChanged(pairings: Array<Pairing>){
        self.pairDesc.text = "\(pairings.count) pairing(s)"
    }
}
