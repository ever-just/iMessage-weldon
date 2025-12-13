//
//  MessageListHeaderViewModel.swift
//  iMessageClone
//
//  Created by Stefan Blos on 29.06.22.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

class MessageListHeaderViewModel: ObservableObject {
    
    @Injected(\.utils) var utils
    @Injected(\.chatClient) var chatClient
    
    @Published var headerImage: UIImage?
    @Published var channelName: String?
    
    init(channel: ChatChannel) {
        headerImage = ChannelHeaderLoader().image(for: channel)
        
        // Use channel name if set, otherwise use the other member's name
        if let name = channel.name, !name.isEmpty {
            channelName = name
        } else {
            // Get the other member's name (not the current user)
            let currentUserId = chatClient.currentUserId ?? ""
            let otherMember = channel.lastActiveMembers.first { $0.id != currentUserId }
            channelName = otherMember?.name ?? utils.channelNamer(channel, currentUserId)
        }
    }
    
}
