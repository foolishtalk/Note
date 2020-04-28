//
//  ViewController.swift
//  Note
//
//  Created by Fidetro on 2020/4/24.
//  Copyright © 2020 karim. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    let kUserDefaultFontKey = "kUserDefaultFontKey"
    @IBOutlet var textView: NSTextView!
    private var _openURL : URL?
    var currentFontSize : Int = 0
    public var openURL : URL?{
        set{
            if let window = NSApplication.shared.mainWindow,
                let title = newValue?.lastPathComponent {
                window.title = title
            }
            _openURL = newValue
        }
        get{
            return _openURL
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFont()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveAction), name: kSaveNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveAsAction), name: kSaveAsNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(biggerFontAction), name: kBiggerFontNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(smallerFontAction), name: kSmallerFontNotificationName, object: nil)
    }

    
    func initFont() {
        let userDefaults = UserDefaults.standard
        currentFontSize = userDefaults.integer(forKey: kUserDefaultFontKey)
        if userDefaults.integer(forKey: kUserDefaultFontKey) == 0 {
            textView.font = NSFont.systemFont(ofSize: 14)
            currentFontSize = 14
            updateFontSize()
        }else {
            textView.font = NSFont.systemFont(ofSize: CGFloat(currentFontSize))
        }
    }
    
    @objc func biggerFontAction() {
        currentFontSize += 1
        if currentFontSize > 100 {
            return
        }
        updateFontSize()
    }
    
    @objc func smallerFontAction() {
        currentFontSize -= 1
        if currentFontSize < 1 {
            return
        }
        updateFontSize()
    }
        
    func updateFontSize() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(currentFontSize, forKey: kUserDefaultFontKey)
        textView.font = NSFont.systemFont(ofSize: CGFloat(currentFontSize))
    }
    
    @objc func saveAction() {
        guard let openURL = openURL else {
            saveAsAction()
            return
        }
        
        if self == NSApplication.shared.mainWindow?.contentViewController,
            let data = textView.string.data(using: .utf8) {
            do{
                try data.write(to: openURL)
            }catch{
                KTAlertHelper.alert(message: "提示", info: error.localizedDescription, buttonTitles: ["OK"])
            }
        } else {
            KTAlertHelper.alert(message: "提示", info: "暂时无法保存，请稍后重试", buttonTitles: ["OK"])
        }
    }
    
    @objc func saveAsAction() {
        let savePanel = NSSavePanel()
        savePanel.message = "选择保存路径"
        savePanel.allowedFileTypes = ["txt"]
        guard let window = NSApp.mainWindow else {
            return
        }
        savePanel.beginSheetModal(for: window) {[weak self](response) in
            if response == .OK {
                if let url = savePanel.url,
                    let data = self?.textView.string.data(using: .utf8) {
                    do{
                        try data.write(to: url)
                        self?.openURL = url
                    }catch{
                        KTAlertHelper.alert(message: "提示", info: error.localizedDescription, buttonTitles: ["OK"])
                    }
                }
            }
        }
    }
    
    func update(text: String?) {
        textView.string = text ?? ""
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

