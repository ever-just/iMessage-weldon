//
//  AppDelegate.swift
//  iMessageClone
//
//  Created by Stefan Blos on 28.01.22.
//

import Foundation
import SwiftUI
import StreamChat
import StreamChatSwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    @Injected(\.utils) var utils
    
    var streamChat: StreamChat?
    
    var chatClient: ChatClient = {
        var config = ChatClientConfig(apiKey: .init(AppConfig.streamAPIKey))
        config.applicationGroupIdentifier = "group.vip.weldon.iMessageClone"
        
        let client = ChatClient(config: config)
        return client
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        streamChat = StreamChat(chatClient: chatClient)
        // User connection is now handled by AuthManager
        return true
    }
    
}
