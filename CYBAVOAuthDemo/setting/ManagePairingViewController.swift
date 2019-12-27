//
//  ManagePairing.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/11/25.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import UIKit
import CYBAVOAuth
class ManagePairingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyMsg: UILabel!
    
    
    var pairings = [Pairing]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pairing services"
        tableView.delegate = self
        tableView.dataSource = self
        pairings = ServiceHolder.get().getPairings()
        onPairingStateChanged(pairings: pairings)
        ServiceHolder.get().addPairingStateListener(listener: self)
    }
    
}


extension ManagePairingViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairings.count
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "UNPAIR") { (action, indexPath) in
            let pairing = self.pairings[indexPath.row]
                let alertController = UIAlertController(title: "Unpair", message: "Do you want to unpair \(pairing.deviceId)?", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in}

                alertController.addAction(cancelAction)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    ServiceHolder.get().unpair(deviceIds: [pairing.deviceId]){ result in
                        switch result {
                           case .success(let r):
                                print("unpair success")
                            break
                            case .failure(let error):
                                print("unpair onFailed\(error)")
                            break
                        }
                    }
                }))
                self.present(alertController, animated: true)
        }

        return [delete]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "idPairing", for: indexPath) as! PairingItemCell
        
        if let pairing = pairings[safe: indexPath.row] {
            cell.title.text = pairing.deviceId
            cell.desc.text = "Paired at \(UIUtil.getDateFormateText(dateFormat: "yyyy-M-d", from: Date(timeIntervalSince1970: Double(pairing.pairedAt))))"
            
        }
    
        return cell
    }
}

extension ManagePairingViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ManagePairingViewController : PairingStateListener{
    func onPairingStateChanged(pairings: Array<Pairing>){
        self.pairings = pairings
        if(self.pairings.count == 0){
            emptyMsg.isHidden = false
            tableView.isHidden = true
        }else{
            emptyMsg.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}
