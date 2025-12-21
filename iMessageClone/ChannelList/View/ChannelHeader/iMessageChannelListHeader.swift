//
//  iMessageChannelListHeader.swift
//  iMessageClone
//
//  Created by Stefan Blos on 01.02.22.
//

import SwiftUI
import StreamChatSwiftUI

struct iMessageChannelListHeader: ToolbarContent {
    
    @Binding var isEditing: Bool
    @Binding var showCreateChannel: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                isEditing.toggle()
            } label: {
                Text(isEditing ? "Done" : "Edit")
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showCreateChannel = true
            } label: {
                Image(systemName: "square.and.pencil")
            }

        }
    }
}
