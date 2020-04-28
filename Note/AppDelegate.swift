//
//  AppDelegate.swift
//  Note
//
//  Created by Fidetro on 2020/4/24.
//  Copyright © 2020 karim. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var openMenuItem: NSMenuItem!
    @IBOutlet weak var saveMenuItem: NSMenuItem!
    @IBOutlet weak var saveAsMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        openMenuItem.isEnabled = true
        
    }

    @IBAction func helpAction(_ sender: Any) {
        openMailApp()
    }
    
    func openMailApp() {
        let toEmail = "zykzzzz@hotmail.com"
        let subject = "Note Help".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let
        urlString = "mailto:\(toEmail)?subject=\(subject)"
        if let url = URL(string:urlString) {
            NSWorkspace.shared.open(url)
        }
    }
    
    @IBAction func newAction(_ sender: Any) {
        openNewWindow(with: nil)
    }
    
    func openNewWindow(with text: String?,openURL: URL?=nil) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name.init("Main"), bundle: nil)
        if let controller = storyboard.instantiateInitialController() as? NSWindowController,
            let window = NSApplication.shared.windows.first,
            let contentController = controller.contentViewController as? ViewController {
            controller.showWindow(window)
            contentController.openURL = openURL
            contentController.update(text: text)
        } else {
            KTAlertHelper.alert(message: "提示", info: "无法创建新窗口", buttonTitles: ["OK"])
        }
    }
    
    
    @IBAction func openAction(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.message = "打开文件"
        openPanel.allowedFileTypes = ["txt"]
        openPanel.begin { [weak self] (response) in
            if response == .OK,
                let url = openPanel.url  {
                do{
                    let data = try Data.init(contentsOf: url)
                    let str = String(data: data, encoding: .utf8)
                    self?.openNewWindow(with: str,openURL: url)
                }catch{
                    KTAlertHelper.alert(message: "提示", info: error.localizedDescription, buttonTitles: ["OK"])
                }
            }
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        NotificationCenter.default.post(name: kSaveNotificationName, object: nil)
        print(self)
    }
    
    @IBAction func saveAsAction(_ sender: Any) {
        NotificationCenter.default.post(name: kSaveAsNotificationName, object: nil)
    }
    
    @IBAction func biggerAction(_ sender: Any) {
        NotificationCenter.default.post(name: kBiggerFontNotificationName, object: nil)
    }
    
    @IBAction func smallerAction(_ sender: Any) {
        NotificationCenter.default.post(name: kSmallerFontNotificationName, object: nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

