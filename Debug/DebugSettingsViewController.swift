//
//  StaffController.swift
//  VMApp
//
//  Created by Victor on 2018-08-29.
//  Copyright © 2018 Victor Marcias. All rights reserved.
//

import UIKit

final class DebugSettingsViewController: DebugOptionsViewController {
    
    override func setup() {
        navigationItem.title = "App Settings"
        tableView.rowHeight = 55
        
        options = [[
            DebugSettingOption(.setting1),
            DebugSettingOption(.setting2),
            DebugSettingOption(.setting3),
            DebugOption(type: .text, title: "Reset All", action: { _ in self.resetAllSettings() })
        ]]
    }
    
    private func resetAllSettings() {
        DebugSettingOption.resetAllSettings()
        
        // unselect all
        if let settingOptions = options.first {
            for option in settingOptions {
                option.isOn = false
            }
            tableView.reloadData()
        }
    }
}

// MARK: - DebugSettingOption

final class DebugSettingOption: DebugOption {
    
    enum DebugSettingType: Int {
        case setting1
        case setting2
        case setting3
        // and so on...
        
        var key: String { return "\(self)" }
    }
    
    fileprivate convenience init(_ settingType: DebugSettingType) {
        self.init(type: .toggle)
        self.title = prettyEnumName(for: settingType.key)
        self.isOn = DebugSettingOption.isSettingEnabled(settingType)
        
        self.action = { _ in
            if self.isOn {
                DebugSettingOption.addSetting(settingType)
            } else {
                DebugSettingOption.removeSetting(settingType)
            }
        }
    }
    
    // MARK: - UserDefaults Helper
    
    private static let debugSettingsKey = "debug.myApp.appSettings"
    
    public static func isSettingEnabled(_ setting: DebugSettingType) -> Bool {
        #if RELEASE
            return false // never allow for end users
        #else
            let settings = getAllSettings() ?? []
            return settings.contains(setting.key)
        #endif
    }
    
    private static func getAllSettings() -> [String]? {
        return UserDefaults.standard.array(forKey: debugSettingsKey) as? [String]
    }
    
    fileprivate static func addSetting(_ setting: DebugSettingType) {
        var settings = getAllSettings() ?? []
        settings.append(setting.key)
        UserDefaults.standard.set(settings, forKey: debugSettingsKey)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate static func removeSetting(_ setting: DebugSettingType) {
        let settings = getAllSettings() ?? []
        UserDefaults.standard.set(settings.filter({ $0 != setting.key}), forKey: debugSettingsKey)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate static func resetAllSettings() {
        UserDefaults.standard.set([String](), forKey: debugSettingsKey)
        UserDefaults.standard.synchronize()
    }
}
