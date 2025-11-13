//
//  GitHubNotificationView.swift
//  boringNotch
//
//  Created for GitHub notifications feature
//

import SwiftUI
import Defaults

struct GitHubNotificationListView: View {
    @ObservedObject var githubManager = GitHubNotificationManager.shared
    @State private var hoveredNotificationId: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundColor(.white)
                Text("GitHub Notifications")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                if githubManager.unreadCount > 0 {
                    Text("\(githubManager.unreadCount)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if githubManager.isLoading {
                    ProgressView()
                        .scaleEffect(0.7)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 4)
            
            if githubManager.notifications.isEmpty {
                EmptyNotificationsView()
            } else {
                ScrollView {
                    VStack(spacing: 6) {
                        ForEach(githubManager.notifications.prefix(10)) { notification in
                            NotificationItemView(
                                notification: notification,
                                isHovered: hoveredNotificationId == notification.id
                            )
                            .onTapGesture {
                                githubManager.openNotificationInBrowser(notification)
                                githubManager.markAsRead(notification: notification)
                            }
                            .onHover { hovering in
                                hoveredNotificationId = hovering ? notification.id : nil
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .frame(maxHeight: 250)
                
                // Footer actions
                HStack {
                    Button(action: {
                        githubManager.fetchNotifications()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.clockwise")
                            Text("Refresh")
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    if githubManager.unreadCount > 0 {
                        Button(action: {
                            githubManager.markAllAsRead()
                        }) {
                            Text("Mark all as read")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            
            if let error = githubManager.lastError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)
            }
        }
        .frame(width: 300)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
    }
}

struct NotificationItemView: View {
    let notification: GitHubNotification
    let isHovered: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Type icon
            Image(systemName: notification.typeIcon)
                .foregroundColor(typeColor)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                // Repository name
                Text(notification.repository.fullName)
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                // Notification title
                Text(notification.subject.title)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                // Time and type
                HStack {
                    Text(notification.subject.type)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text(notification.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Unread indicator
            if notification.unread {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(isHovered ? Color.white.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
    
    var typeColor: Color {
        switch notification.subject.type {
        case "PullRequest":
            return .green
        case "Issue":
            return .orange
        case "Commit":
            return .blue
        case "Release":
            return .purple
        default:
            return .gray
        }
    }
}

struct EmptyNotificationsView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("All caught up!")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("No new notifications")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// Compact badge view for closed notch
struct GitHubNotificationBadge: View {
    @ObservedObject var githubManager = GitHubNotificationManager.shared
    
    var body: some View {
        if Defaults[.enableGitHubNotifications] && githubManager.isAuthenticated && githubManager.unreadCount > 0 {
            HStack(spacing: 4) {
                Image(systemName: "bell.fill")
                    .font(.caption)
                Text("\(githubManager.unreadCount)")
                    .font(.caption)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
}

#Preview {
    GitHubNotificationListView()
        .frame(width: 400, height: 500)
        .background(Color.black)
}
