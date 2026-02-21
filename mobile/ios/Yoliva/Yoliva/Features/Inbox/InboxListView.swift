// mobile/ios/Yoliva/Features/Inbox/InboxListView.swift
import SwiftUI

/// Premium Inbox List for Yoliva showing conversations with real-time updates.
struct InboxListView: View {
    @StateObject private var viewModel = InboxViewModel()
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    ProgressView().padding(.top, 40)
                } else if viewModel.conversations.isEmpty {
                    // Empty State for Inbox
                    VStack(spacing: 20) {
                        Image(systemName: "tray.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.1))
                        Text("Henüz bir mesajın bulunmuyor.")
                            .font(AppTheme.Typography.body())
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.top, 60)
                } else {
                    // Conversation List with Dividers
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.conversations) { conversation in
                                ConversationRow(conversation: conversation) {
                                    AppTheme.haptic(.light)
                                    // Navigate to ChatDetailView with rideId
                                    router.navigate(to: .chat(rideId: conversation.id.uuidString))
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.horizontal, 24)
                            }
                            
                            Spacer(minLength: 120) // Floating Tab Bar offset
                        }
                    }
                }
            }
        }
        .navigationTitle("Mesajlar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews

struct ConversationRow: View {
    let conversation: Conversation
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Avatar with Glassmorphic Circle
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 56, height: 56)
                    .overlay(Text(String(conversation.userName.prefix(1))).font(.title3.bold()))
                    .glassCard(cornerRadius: 28)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        // User Name with Verified Shield
                        Text(conversation.userName)
                            .font(.headline)
                            .foregroundColor(.white)
                        if conversation.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption2)
                                .foregroundColor(AppTheme.primary)
                        }
                        
                        Spacer()
                        
                        // Last Message Timestamp
                        Text(conversation.timestamp, style: .time)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    // Ride Route Hint
                    Text(conversation.tripRoute)
                        .font(.caption2.bold())
                        .foregroundColor(AppTheme.primary.opacity(0.8))
                    
                    // Message Snippet
                    Text(conversation.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                // Glowing Teal Unread Badge
                if conversation.unreadCount > 0 {
                    Circle()
                        .fill(AppTheme.primary)
                        .frame(width: 10, height: 10)
                        .shadow(color: AppTheme.primary.opacity(0.7), radius: 6)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
