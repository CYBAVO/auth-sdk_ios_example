//
//  ActionArument.swift
//  CYBAVOAuthDemo
//
//  Created by Eva Hsu on 2019/11/21.
//  Copyright © 2019 Cybavo. All rights reserved.
//

import Foundation
import CYBAVOAuth
public class ActionArgument {
    public static func fromAction(action: TwoFactorAuthenticationAction) -> ActionArgument{
        return ActionArgument(type: action.type, token: action.token, deviceId: action.deviceId, messageType: action.messageType, messageTitle: action.messageTitle, messageBody: action.messageBody, messageData: action.messageData, createTime: action.createTime, rejectable: action.rejectable, inputPinCode: action.inputPinCode, state: action.state, userAction: action.userAction, updatedTime: action.updatedTime, clientPlatform: action.clientInfo.platform, clientIp: action.clientInfo.ip)
    }
    
    public var type: Int = 0
    public var token: String = ""
    public var deviceId: String = ""
    public var messageType: Int = 0
    public var messageTitle: String = ""
    public var messageBody: String = ""
    public var messageData: String
    public var createTime: Int64 = 0
    public var rejectable: Bool = false
    public var inputPinCode: Bool = false
    public var state: Int = 0
    public var userAction: Int = 0
    public var updatedTime: Int64 = 0
    public var clientPlatform: Int = 0;
    public var clientIp: String = ""
    
    init(type: Int, token: String, deviceId: String, messageType: Int,messageTitle: String, messageBody: String, messageData: String = "", createTime: Int64,
         rejectable: Bool, inputPinCode: Bool, state: Int, userAction: Int, updatedTime: Int64, clientPlatform: Int, clientIp: String) {
        self.type = type
        self.token = token
        self.deviceId = deviceId
        self.messageType = messageType
        self.messageTitle = messageTitle
        self.messageBody = messageBody
        self.messageData = messageData
        self.createTime = createTime
        self.rejectable = rejectable
        self.inputPinCode = inputPinCode
        self.state = state
        self.userAction = userAction
        self.updatedTime = updatedTime
        self.clientPlatform = clientPlatform
        self.clientIp = clientIp
    }
    
    public func getTitle() -> String{
        print("\(type)|SETUP_PIN_CODE:\(TwoFactorAuthenticationAction.Types.SETUP_PIN_CODE),:\(TwoFactorAuthenticationAction.Types.CUSTOM_PIN_CODE_ACTION),CUSTOM_OTP_ACTION:\(TwoFactorAuthenticationAction.Types.CUSTOM_OTP_ACTION)")
        switch type{
            case TwoFactorAuthenticationAction.Types.SETUP_PIN_CODE:
                return "Setup PIN code"
            case TwoFactorAuthenticationAction.Types.CUSTOM_PIN_CODE_ACTION:
                return messageTitle
            case TwoFactorAuthenticationAction.Types.CUSTOM_OTP_ACTION:
                return messageTitle
            default:
                return "Unknow action (\(type))"
        }
    }
    public func getBody() -> String{
        switch type{
           case TwoFactorAuthenticationAction.Types.SETUP_PIN_CODE:
               return "Setup PIN code to protect your property"
           case TwoFactorAuthenticationAction.Types.CUSTOM_PIN_CODE_ACTION:
               return messageBody
           case TwoFactorAuthenticationAction.Types.CUSTOM_OTP_ACTION:
               return messageBody
           default:
               return "Unknow action type (\(type)) is unreconized"
       }
    }
    public func getStateDesc() -> String{
         switch state{
            case TwoFactorAuthenticationAction.State.CREATED.rawValue:
                return "Created"
            case TwoFactorAuthenticationAction.State.DONE.rawValue:
                return "Done"
            case TwoFactorAuthenticationAction.State.PASSED.rawValue:
                return "Passed"
            case TwoFactorAuthenticationAction.State.CANCELLED.rawValue:
                return "Cancelled"
            case TwoFactorAuthenticationAction.State.FAILED.rawValue:
                return "Failed"
            case TwoFactorAuthenticationAction.State.UNKNOWN.rawValue:
                return "Unknown"
            default:
                return "Unknown"
        }
    }
    public func getUserActionDesc() -> String{
         switch userAction{
         case TwoFactorAuthenticationAction.UserAction.NONE.rawValue:
                return "None"
            case TwoFactorAuthenticationAction.UserAction.ACCEPT.rawValue:
                return "Accept"
            case TwoFactorAuthenticationAction.UserAction.REJECT.rawValue:
                return "Reject"
            case TwoFactorAuthenticationAction.UserAction.UNKNOWN.rawValue:
                return "Unknown"
            default:
                return "Unknown"
        }
        
    }
}
