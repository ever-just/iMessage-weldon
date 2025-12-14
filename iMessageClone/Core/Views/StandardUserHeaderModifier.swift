//
//  StandardUserHeaderModifier.swift
//  iMessageClone
//
//  weldon.vip - Custom header for standard users with simplified options
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct StandardUserHeaderModifier: ChatChannelHeaderViewModifier {
    var channel: ChatChannel
    
    @State private var infoScreenShown = false
    
    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    infoScreenShown = true
                } label: {
                    VStack(spacing: 4) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text("W")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            )
                        
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("Weldon")
                                .font(.caption)
                                .foregroundColor(.primary)
                            
                            Image(systemName: "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 8, height: 8)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.bottom, 6)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "video")
                    .foregroundColor(.blue)
            }
        }
        .sheet(isPresented: $infoScreenShown) {
            CustomChannelInfoView(channel: channel)
        }
    }
}
