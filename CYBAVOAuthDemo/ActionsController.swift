//
//  FirstViewController.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/11/14.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import UIKit
import CYBAVOAuth
import SwiftEventBus
class ActionsController: UIViewController{
    
    @IBOutlet weak var emptyFig: UIImageView!
    
    @IBOutlet weak var emptyMsg: UILabel!
    
    @IBOutlet weak var pairBtn: UIButton!
    
    @IBAction func onPairClick(_ sender: Any) {
         performSegue(withIdentifier: "idNewPairing", sender: nil)
    }
    @IBOutlet weak var actionTableView: UITableView!
    var refreshControl: UIRefreshControl!
    var actions = [TwoFactorAuthenticationAction]()
    var pairings =  Array<Pairing>()
    override func viewDidLoad() {
        super.viewDidLoad()
        actionTableView.register(
                UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //setEmptyUI()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ActionsController.refresh2FaActions), for: .valueChanged)
        actionTableView.addSubview(refreshControl)
        actionTableView.dataSource = self
        actionTableView.delegate = self
        ServiceHolder.get().addPairingStateListener(listener: self)
        onPairingStateChanged(pairings: ServiceHolder.get().getPairings())
        SwiftEventBus.onMainThread(self, name: "fetch2fa") { result in
             self.fetch2FaActions()
        }
    }
    func setEmptyUI() {
        let margins = view.layoutMarginsGuide
        emptyMsg.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        emptyFig.bottomAnchor.constraint(equalTo: emptyMsg.topAnchor,constant: -5).isActive = true
        pairBtn.topAnchor.constraint(equalTo: emptyMsg.topAnchor,constant: 5).isActive = true
        
    }
    @objc public func refresh2FaActions() {
        ServiceHolder.get().getTwoFactorAuthentications(since: Int64(Date().timeIntervalSince1970-86400)){ result in
            switch result {
               case .success(let r):
                    print("get2fa success")
                    self.onActionUpdate(actions: r.actions)
                break
                case .failure(let error):
                    print("get2fa onFailed")
                break
            }
            self.refreshControl.endRefreshing()
        }
    }
    private func onPairingsUpdate(){
        
    }
    
    private func fetch2FaActions(){
        ServiceHolder.get().getTwoFactorAuthentications(since: Int64(Date().timeIntervalSince1970-86400)){ result in
            switch result {
               case .success(let r):
                    print("get2fa success")
                    self.onActionUpdate(actions: r.actions)
                break
                case .failure(let error):
                    print("get2fa onFailed")
                break
            }
        }
    }
    private func onActionUpdate(actions: Array<TwoFactorAuthenticationAction>){
        self.actions = actions
        self.actionTableView.reloadData()
        updateEmptySate(noPairing: pairings.count == 0, noAction: actions.count == 0)
    }
    private func updateEmptySate(noPairing: Bool, noAction: Bool){
        if(noPairing){
            emptyFig.isHidden = false
            emptyMsg.isHidden = false
            emptyMsg.text = "It seems that you have no pairings."
            UIUtil.setTintImage(named: "fig_new_pairing", imageView: emptyFig, tintColor: UIUtil.colorPrimary)
            pairBtn.isHidden = false
            actionTableView.isHidden = true
        }else if(noAction){
            emptyFig.isHidden = false
            emptyMsg.isHidden = false
            emptyMsg.text = "All set!"
            UIUtil.setTintImage(named: "fig_empty_actions", imageView: emptyFig, tintColor: UIUtil.colorPrimary)
            pairBtn.isHidden = true
            self.actionTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            actionTableView.isHidden = false
        }else{
            emptyFig.isHidden = true
            emptyMsg.isHidden = true
            pairBtn.isHidden = true
            self.actionTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            actionTableView.isHidden = false
        }
    }
}


extension ActionsController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "idActionsView", for: indexPath) as! ActionItemCell
        
        if let action = actions[safe: indexPath.row] {
            let arg = ActionArgument.fromAction(action: action)
            cell.title.text = arg.getTitle()
            cell.body.text = arg.getBody()
            UIUtil.setTintImage(named: action.inputPinCode ? "ic_pin_code" : "ic_otp", imageView: cell.action, tintColor: UIUtil.colorPrimary)
            let timeStr = UIUtil.getDateFormateText(dateFormat: "M/d HH:mm", from: Date(timeIntervalSince1970: Double(arg.createTime)))
            
            if(arg.messageType == 0){
                cell.type.isHidden = true
                wrapContent(label: cell.time, text: timeStr, rightOf: cell.action)
            }else{
                cell.type.isHidden = false
                cell.type.text = "\(arg.messageType)"
                wrapContent(label: cell.time, text: timeStr, rightOf: cell.type)
            }
            cell.state.text = "\(arg.getStateDesc())/\(arg.getUserActionDesc())"
            switch action.userAction{
                case TwoFactorAuthenticationAction.UserAction.NONE.rawValue:
                        cell.bullet.backgroundColor = UIColor.darkGray
                        break
                case TwoFactorAuthenticationAction.UserAction.ACCEPT.rawValue:
                    cell.bullet.backgroundColor = UIUtil.colorAccept
                    break
                case TwoFactorAuthenticationAction.UserAction.REJECT.rawValue:
                    cell.bullet.backgroundColor = UIUtil.colorReject
                    break
                case TwoFactorAuthenticationAction.UserAction.UNKNOWN.rawValue:
                    cell.bullet.backgroundColor = UIColor.black
                    break
                default:
                    break
            }
            cell.contentView.alpha = action.state == TwoFactorAuthenticationAction.State.CREATED.rawValue ? 1 : 0.5
        }
        return cell
    }
    
    func wrapContent(label: UILabel, text: String, rightOf: UIView){
        label.text = text
        let width = text.count * 9
        var frm : CGRect = label.frame
        label.frame = CGRect(x: frm.origin.x, y: frm.origin.y, width: CGFloat(width), height: frm.size.height)
        label.trailingAnchor.constraint(equalTo: rightOf.leadingAnchor,constant: -4).isActive = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "idPinCodeAction" || segue.identifier == "idOtpAction" || else {
//            return
//        }
        switch segue.identifier {
            case "idPinCodeAction":
                let obj = sender as AnyObject
                if let action = obj as? ActionArgument, let vc = segue.destination as? PinCodeActionViewController {
                    vc.delegate = self
                    vc.action = action
                }
                break
            case "idOtpAction":
                let obj = sender as AnyObject
                if let action = obj as? ActionArgument, let vc = segue.destination as? OtpActionViewController {
                    vc.delegate = self
                    vc.action = action
                }
                break
            case "idNewPairing":
                if let vc = segue.destination as? NewPairingViewController {
                    vc.delegate = self
                }
                break
            default:
                break
        }
    }
}

extension ActionsController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let action = actions[safe: indexPath.row] {
            let arg = ActionArgument.fromAction(action: action)
            performSegue(withIdentifier: arg.inputPinCode ? "idPinCodeAction" : "idOtpAction", sender: arg)
            print("click \(action.messageTitle)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ActionsController : PairingStateListener{
    func onPairingStateChanged(pairings: Array<Pairing>){
        self.pairings = pairings
        updateEmptySate(noPairing: pairings.count == 0, noAction: actions.count == 0)
        if(self.pairings.count == 0){
            refreshControl.isEnabled = false
        }else{
            refreshControl.isEnabled = true
            fetch2FaActions()
        }
    }
}

extension ActionsController : ViewControllerDelegate{
    func viewWillDisappear() {
        self.fetch2FaActions()
    }
}
