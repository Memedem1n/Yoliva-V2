// mobile/ios/Yoliva/Features/Inbox/InboxViewModel.swift
import SwiftUI

/// A structure representing a conversation in the user's inbox.
struct Conversation: Identifiable, Hashable {
    let id: UUID
    let userName: String
    let tripRoute: String
    let lastMessage: String
    let unreadCount: Int
    let isVerified: Bool
    let timestamp: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// ViewModel for managing a list of conversations in the inbox.
@MainActor
final class InboxViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var isLoading: Bool = false
    
    init() {
        fetchConversations()
    }
    
    /// Fetches mock data for conversations.
    func fetchConversations() {
        isLoading = true
        
        // Mocking conversations
        self.conversations = [
            Conversation(id: UUID(), userName: "Zeynep Y.", tripRoute: "İstanbul ➔ Ankara", lastMessage: "Tamamdır, Boğa heykelinin önündeyim.", unreadCount: 2, isVerified: true, timestamp: Date()),
            Conversation(id: UUID(), userName: "Caner T.", tripRoute: "Bursa ➔ İzmir", lastMessage: "Bagajda yer var mı?", unreadCount: 0, isVerified: true, timestamp: Date().addingTimeInterval(-3600)),
            Conversation(id: UUID(), userName: "Merve G.", tripRoute: "Ankara ➔ İstanbul", lastMessage: "Yolculuk için teşekkürler!", unreadCount: 0, isVerified: false, timestamp: Date().addingTimeInterval(-86400))
        ]
        
        isLoading = false
    }
}

// mobile/ios/Yoliva/Features/Inbox/ChatViewModel.swift
import SwiftUI

/// A structure representing a single message in a chat.
struct Message: Identifiable, Equatable {
    let id: UUID
    let text: String
    let isMe: Bool
    let timestamp: Date
}

/// ViewModel for managing real-time chat messages and simulated replies.
@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isTyping: Bool = false
    
    let conversation: Conversation
    
    init(conversation: Conversation) {
        self.conversation = conversation
        fetchMessages()
    }
    
    /// Fetches mock message history for a conversation.
    func fetchMessages() {
        self.messages = [
            Message(id: UUID(), text: "Merhaba, yolculuk hakkında bir sorum olacaktı.", isMe: true, timestamp: Date().addingTimeInterval(-7200)),
            Message(id: UUID(), text: "Tabii, buyurun dinliyorum.", isMe: false, timestamp: Date().addingTimeInterval(-7100)),
            Message(id: UUID(), text: conversation.lastMessage, isMe: false, timestamp: Date().addingTimeInterval(-3600))
        ]
    }
    
    /// Sends a user message and triggers a simulated response.
    func sendMessage(_ text: String) {
        let newMessage = Message(id: UUID(), text: text, isMe: true, timestamp: Date())
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            messages.append(newMessage)
        }
        
        AppTheme.haptic(.light)
        
        // Simulate real-time reply
        simulateReply()
    }
    
    private func simulateReply() {
        // Start typing after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { self.isTyping = true }
            
            // Send reply after another 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let reply = Message(id: UUID(), text: "Harika! Sizi bekliyor olacağım. 👍", isMe: false, timestamp: Date())
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    self.isTyping = false
                    self.messages.append(reply)
                }
                AppTheme.haptic(.medium)
            }
        }
    }
}
