//
//  ServiceHolder.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/11/14.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import CYBAVOAuth
public class ServiceHolder {
    public static var shared: Authenticator? = nil
    public static func get() -> Authenticator{
        guard let endPoint = UserDefaults.standard.string(forKey: "endpoints"),let apicode = UserDefaults.standard.string(forKey: "apicode") else{
             print("missing settings")
            return shared!
        }
        print("apiCode:\(apicode), endpoint:\(endPoint)")
        if shared == nil {
            #if DEBUG
            let apnsSandbox = true
            #else
            let apnsSandbox = false
            #endif
            shared = Authenticator.create(endPoint:endPoint,apiCode: apicode, apnsSandbox: apnsSandbox)
        }
        return shared!
    }
}
