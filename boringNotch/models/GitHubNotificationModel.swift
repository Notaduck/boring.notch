//
//  GitHubNotificationModel.swift
//  boringNotch
//
//  Created for GitHub notifications feature
//

import Foundation

// MARK: - GitHub Notification Model
struct GitHubNotification: Identifiable, Codable, Hashable {
    let id: String
    let repository: Repository
    let subject: Subject
    let reason: String
    let unread: Bool
    let updatedAt: String
    let lastReadAt: String?
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case repository
        case subject
        case reason
        case unread
        case updatedAt = "updated_at"
        case lastReadAt = "last_read_at"
        case url
    }
    
    struct Repository: Codable, Hashable {
        let id: Int
        let name: String
        let fullName: String
        let owner: Owner
        let htmlUrl: String
        let description: String?
        let isPrivate: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case fullName = "full_name"
            case owner
            case htmlUrl = "html_url"
            case description
            case isPrivate = "private"
        }
        
        struct Owner: Codable, Hashable {
            let login: String
            let avatarUrl: String
            
            enum CodingKeys: String, CodingKey {
                case login
                case avatarUrl = "avatar_url"
            }
        }
    }
    
    struct Subject: Codable, Hashable {
        let title: String
        let url: String?
        let latestCommentUrl: String?
        let type: String
        
        enum CodingKeys: String, CodingKey {
            case title
            case url
            case latestCommentUrl = "latest_comment_url"
            case type
        }
    }
    
    // Helper computed properties
    var typeIcon: String {
        switch subject.type {
        case "PullRequest":
            return "arrow.triangle.merge"
        case "Issue":
            return "exclamationmark.circle"
        case "Commit":
            return "arrow.triangle.branch"
        case "Release":
            return "tag"
        case "Discussion":
            return "bubble.left.and.bubble.right"
        default:
            return "bell"
        }
    }
    
    var formattedDate: String {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: updatedAt) else {
            return updatedAt
        }
        
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else {
            return "Just now"
        }
    }
    
    var webUrl: String {
        // Extract the web URL from the API URL
        if let subjectUrl = subject.url {
            // Convert API URL to web URL
            // Example: https://api.github.com/repos/owner/repo/issues/123
            // To: https://github.com/owner/repo/issues/123
            return subjectUrl
                .replacingOccurrences(of: "https://api.github.com/repos/", with: "https://github.com/")
                .replacingOccurrences(of: "/pulls/", with: "/pull/")
        }
        return repository.htmlUrl
    }
}

// MARK: - GitHub API Response
struct GitHubNotificationResponse: Codable {
    let notifications: [GitHubNotification]
}
