//
//  UiUtil.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/11/22.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import UIKit

public protocol ViewControllerDelegate {
    func viewWillDisappear();
}

class UIUtil{
    public static let colorPrimary = UIColor(red:11/255.0, green:71/255.0, blue:161/255.0, alpha: 1)
    public static let colorAccept = UIColor(red:104/255.0, green:159/255.0, blue:56/255.0, alpha: 1)
    public static let colorReject = UIColor(red:211/255.0, green:47/255.0, blue:47/255.0, alpha: 1)
    
    public static let colorWarning = UIColor(red:255/255.0, green:193/255.0, blue:7/255.0, alpha: 1)
    
    public static func getDateFormateText(dateFormat: String, from: Date)->String{
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = dateFormat
               return dateFormatter.string(from: from)
    }
    
    public static func setTintImage(named: String, imageView: UIImageView, tintColor: UIColor){
        if let myImage = UIImage(named: named) {
                let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
                imageView.image = tintableImage
            }
            imageView.tintColor = tintColor
        
    }
    
    public static func toggleLoading(view: UIActivityIndicatorView, show: Bool){
        view.hidesWhenStopped = true
        if(show){
            view.startAnimating()
        }else{
            view.isHidden = true
        }
    }
}
