//
//  GitHubNotificationManager.swift
//  boringNotch
//
//  Created for GitHub notifications feature
//

import AppKit
import Combine
import Defaults
import Foundation
import Security

class GitHubNotificationManager: ObservableObject {
    static let shared = GitHubNotificationManager()
    
    @Published var notifications: [GitHubNotification] = []
    @Published var unreadCount: Int = 0
    @Published var isLoading: Bool = false
    @Published var lastError: String?
    @Published var isAuthenticated: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var pollingTimer: Timer?
    private let keychainService = "com.thebored.boringNotch.github"
    private let keychainAccount = "githubToken"
    
    private init() {
        setupObservers()
        checkAuthentication()
    }
    
    private func setupObservers() {
        // Observe changes to GitHub notification settings
        Defaults.publisher(.enableGitHubNotifications)
            .sink { [weak self] change in
                if change.newValue {
                    self?.startPolling()
                } else {
                    self?.stopPolling()
                }
            }
            .store(in: &cancellables)
        
        Defaults.publisher(.githubPollingInterval)
            .sink { [weak self] _ in
                self?.restartPolling()
            }
            .store(in: &cancellables)
    }
    
    private func checkAuthentication() {
        isAuthenticated = getToken() != nil
    }
    
    // MARK: - Token Management (Keychain)
    
    func saveToken(_ token: String) {
        let tokenData = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: tokenData
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            isAuthenticated = true
            if Defaults[.enableGitHubNotifications] {
                startPolling()
            }
        } else {
            lastError = "Failed to save token to keychain"
        }
    }
    
    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        
        SecItemDelete(query as CFDictionary)
        isAuthenticated = false
        notifications = []
        unreadCount = 0
        stopPolling()
    }
    
    // MARK: - Polling
    
    private func startPolling() {
        guard isAuthenticated else { return }
        
        stopPolling()
        
        // Fetch immediately
        fetchNotifications()
        
        // Set up timer for periodic polling
        let interval = Defaults[.githubPollingInterval]
        pollingTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.fetchNotifications()
        }
    }
    
    private func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
    
    private func restartPolling() {
        if Defaults[.enableGitHubNotifications] && isAuthenticated {
            startPolling()
        }
    }
    
    // MARK: - API Calls
    
    func fetchNotifications() {
        guard let token = getToken() else {
            lastError = "No GitHub token found"
            return
        }
        
        isLoading = true
        lastError = nil
        
        var urlComponents = URLComponents(string: "https://api.github.com/notifications")!
        urlComponents.queryItems = [
            URLQueryItem(name: "all", value: "false"), // Only unread
            URLQueryItem(name: "per_page", value: "50")
        ]
        
        guard let url = urlComponents.url else {
            lastError = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.lastError = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.lastError = "No data received"
                    return
                }
                
                // Check for HTTP errors
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                        self?.lastError = "Invalid token or unauthorized"
                        self?.isAuthenticated = false
                        return
                    } else if httpResponse.statusCode != 200 {
                        self?.lastError = "HTTP \(httpResponse.statusCode)"
                        return
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    let fetchedNotifications = try decoder.decode([GitHubNotification].self, from: data)
                    
                    self?.notifications = fetchedNotifications
                    self?.unreadCount = fetchedNotifications.filter { $0.unread }.count
                } catch {
                    self?.lastError = "Failed to decode: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func markAsRead(notification: GitHubNotification) {
        guard let token = getToken() else { return }
        
        // GitHub API endpoint to mark a notification as read
        let urlString = "https://api.github.com/notifications/threads/\(notification.id)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            if error == nil, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 205 {
                DispatchQueue.main.async {
                    // Remove from local list
                    self?.notifications.removeAll { $0.id == notification.id }
                    self?.updateUnreadCount()
                }
            }
        }.resume()
    }
    
    func markAllAsRead() {
        guard let token = getToken() else { return }
        
        let urlString = "https://api.github.com/notifications"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            if error == nil, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 205 {
                DispatchQueue.main.async {
                    self?.notifications = []
                    self?.unreadCount = 0
                }
            }
        }.resume()
    }
    
    func openNotificationInBrowser(_ notification: GitHubNotification) {
        if let url = URL(string: notification.webUrl) {
            NSWorkspace.shared.open(url)
        }
    }
    
    private func updateUnreadCount() {
        unreadCount = notifications.filter { $0.unread }.count
    }
    
    deinit {
        stopPolling()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
