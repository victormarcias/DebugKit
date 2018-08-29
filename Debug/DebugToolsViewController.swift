//
//  DebugToolsViewController.swift
//  VMApp
//
//  Created by Victor on 2018-08-29.
//  Copyright © 2018 Victor Marcias. All rights reserved.
//

import UIKit

final class DebugToolsViewController: DebugOptionsViewController {
    
    override func setup() {
        navigationItem.title = "Debug Tools"
        tableView.rowHeight = 55
        
        let action: DebugOption.DebugOptionAction = { option in
            if let tool = option as? DebugToolOption, let toolVC = tool.toolType?.viewController {
                self.navigationController?.pushViewController(toolVC, animated: true)
            }
        }
        
        options = [[
            DebugToolOption(.appSettings, action),
            DebugToolOption(.userDefaultsViewer, action)
        ]]
    }
}

// MARK: - Debug Tool Option

private final class DebugToolOption: DebugOption {
    
    enum DebugToolType: Int {
        case appSettings
        case userDefaultsViewer
        
        var viewController: UIViewController {
            switch self {
            case .appSettings:          return DebugSettingsViewController()
            case .userDefaultsViewer:   return DebugUserDefaultsViewController()
            }
        }
    }
    
    var toolType: DebugToolType?
    
    required convenience init(_ toolType: DebugToolType, _ action: DebugOptionAction? = nil) {
        self.init(type: .disclosure, action: action)
        self.toolType = toolType
        self.title = prettyEnumName(for: "\(toolType)")
    }
}
