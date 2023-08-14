//
//  AppDelegate.swift
//  XeroProgrammingExercise
//
//  Created by Francesco P on 5/05/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {       
        return true
    }
    
    var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

