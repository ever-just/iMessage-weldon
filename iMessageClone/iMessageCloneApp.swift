//
//  iMessageCloneApp.swift
//  iMessageClone
//
//  Created by Stefan Blos on 28.01.22.
//  Modified for weldon.vip
//

import SwiftUI
import StreamChatSwiftUI

@main
struct iMessageCloneApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
