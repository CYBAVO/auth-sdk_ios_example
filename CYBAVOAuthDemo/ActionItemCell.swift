//
//  ActionItems.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/11/21.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import UIKit
class ActionItemCell : UITableViewCell{
    @IBOutlet weak var bullet: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var action: UIImageView!
}
