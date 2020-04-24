//
//  KTAlertHelper.swift
//  Magellan
//
//  Created by Fidetro on 2019/10/31.
//  Copyright © 2019 karim. All rights reserved.
//

import Cocoa
open class KTAlertHelper: NSObject {
    @discardableResult
    static func alert(message messageText: String?=nil,
                      info informativeText: String?=nil,
                      buttonTitles: String...) -> NSApplication.ModalResponse
    {
        let alert = NSAlert()
        if let messageText = messageText {
            alert.messageText = messageText
        }
        if let informativeText = informativeText {
            alert.informativeText = informativeText
        }
        alert.alertStyle = .warning
        buttonTitles.forEach{alert.addButton(withTitle: $0)}
        return alert.runModal()
    }
    
    @objc static func mainThreadAlert(message messageText: String?=nil,
                                      info informativeText: String?=nil,
                                      buttonTitles: [String],
                                      window:NSWindow?,
                                      alertHandler: ((NSAlert)->())?=nil)
    {
        OperationQueue.main.addOperation {
            let alert = NSAlert()
            if let messageText = messageText {
                alert.messageText = messageText
            }
            if let informativeText = informativeText {
                alert.informativeText = informativeText
            }
            alert.alertStyle = .warning
            buttonTitles.forEach{alert.addButton(withTitle: $0)}
            if let window = window {
                alert.beginSheetModal(for: window) { (reponse) in
                    
                }
            }else{
                alert.runModal()
            }
            
            if let alertHandler = alertHandler {
                alertHandler(alert)
            }
        }
    }
    
    @objc static func mainThreadAlert(message messageText: String?=nil,
                                      info informativeText: String?=nil,
                                      window: NSWindow?,
                                      alertHandler: ((NSAlert)->())?=nil)
    {
        mainThreadAlert(message: messageText,
                        info: informativeText,
                        buttonTitles: ["OK"],
                        window:window,
                        alertHandler:alertHandler)
    }
    
    @objc static func mainThreadAlert(message messageText: String?=nil,
                                      info informativeText: String?=nil)
    {
        mainThreadAlert(message: messageText,
                        info: informativeText,
                        buttonTitles: ["OK"],
                        window:nil)
    }
    
    @discardableResult
    @objc static func alert(message messageText: String?=nil,
                            info informativeText: String?=nil,
                            buttonTitles: [String]) -> NSApplication.ModalResponse
    {
        let alert = NSAlert()
        if let messageText = messageText {
            alert.messageText = messageText
        }
        if let informativeText = informativeText {
            alert.informativeText = informativeText
        }
        alert.alertStyle = .warning
        buttonTitles.forEach{alert.addButton(withTitle: $0)}
        return alert.runModal()
        
    }
    
}
