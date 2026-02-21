// mobile/ios/Yoliva/Features/Inbox/ChatDetailView.swift
import SwiftUI

/// Premium iMessage-style interface for real-time chat with spring animations.
struct ChatDetailView: View {
    @StateObject private var viewModel: ChatViewModel
    @State private var inputText: String = ""
    @Environment(\.dismiss) var dismiss
    
    init(conversation: Conversation) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(conversation: conversation))
    }
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Scrollable Chat Bubbles
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 14) {
                            ForEach(viewModel.messages) { message in
                                ChatBubble(message: message)
                                    .id(message.id)
                            }
                            
                            // Real-time Typing Indicator simulation
                            if viewModel.isTyping {
                                TypingIndicator()
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                    }
                    .onChange(of: viewModel.messages) { _ in
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
                // Fixed Chat Input Bar at bottom
                ChatInputBar(text: $inputText) {
                    guard !inputText.isEmpty else { return }
                    viewModel.sendMessage(inputText)
                    inputText = ""
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    // Avatar in Navigation Title
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 32, height: 32)
                        .overlay(Text(String(viewModel.conversation.userName.prefix(1))).font(.caption.bold()))
                    
                    Text(viewModel.conversation.userName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if viewModel.conversation.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundColor(AppTheme.primary)
                    }
                }
            }
        }
    }
}

// MARK: - Chat Components

struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isMe { Spacer() }
            
            VStack(alignment: message.isMe ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(AppTheme.Typography.body(16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        message.isMe ? AppTheme.primary : Color.white.opacity(0.08)
                    )
                    .foregroundColor(message.isMe ? .black : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                
                Text(message.timestamp, style: .time)
                    .font(.system(size: 10))
                    .foregroundColor(.gray.opacity(0.6))
                    .padding(.horizontal, 4)
            }
            
            if !message.isMe { Spacer() }
        }
    }
}

struct ChatInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider().background(Color.white.opacity(0.1))
            
            HStack(spacing: 12) {
                // Glassmorphic Input Container
                HStack {
                    TextField("Mesaj yaz...", text: $text)
                        .font(AppTheme.Typography.body())
                        .foregroundColor(.white)
                        .submitLabel(.send)
                        .onSubmit(onSend)
                    
                    Button(action: { AppTheme.haptic(.light) }) {
                        Image(systemName: "face.smiling.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.05))
                .cornerRadius(22)
                
                // Send Action Button
                Button(action: onSend) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(text.isEmpty ? .gray : AppTheme.primary)
                        .frame(width: 44, height: 44)
                }
                .disabled(text.isEmpty)
                .animation(.spring(), value: text.isEmpty)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .padding(.bottom, 20) // Adjustment for safe area
        }
        .background(AppTheme.background.opacity(0.8))
        .background(.ultraThinMaterial)
    }
}

struct TypingIndicator: View {
    @State private var showDots = false
    
    var body: some View {
        HStack(spacing: 4) {
            Circle().fill(Color.gray.opacity(0.6)).frame(width: 6, height: 6).opacity(showDots ? 1 : 0.4).animation(.easeInOut(duration: 0.6).repeatForever().delay(0), value: showDots)
            Circle().fill(Color.gray.opacity(0.6)).frame(width: 6, height: 6).opacity(showDots ? 1 : 0.4).animation(.easeInOut(duration: 0.6).repeatForever().delay(0.2), value: showDots)
            Circle().fill(Color.gray.opacity(0.6)).frame(width: 6, height: 6).opacity(showDots ? 1 : 0.4).animation(.easeInOut(duration: 0.6).repeatForever().delay(0.4), value: showDots)
        }
        .padding(12)
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear { showDots = true }
    }
}
