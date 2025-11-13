# GitHub Notifications Feature

This feature adds GitHub notification support to boring.notch, similar to [Gitify.io](https://gitify.io).

## Features

- 🔔 Real-time GitHub notification monitoring
- 📊 Unread notification count badge
- 🔍 Detailed notification list with repository info
- ✅ Mark individual notifications as read
- 🗑️ Mark all notifications as read
- 🌐 Open notifications directly in browser
- 🔐 Secure token storage using macOS Keychain
- ⚙️ Configurable polling intervals
- 🎨 Seamless integration with boring.notch UI

## Setup

1. **Open Settings**: Click the gear icon in the notch or use the menu bar
2. **Navigate to GitHub**: Select the "GitHub" section from the sidebar
3. **Create a Personal Access Token**:
   - Visit [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens)
   - Click "Generate new token (classic)"
   - Give it a descriptive name (e.g., "boring.notch notifications")
   - Select the `notifications` scope
   - Click "Generate token"
   - Copy the generated token
4. **Add Token**: Paste your token in boring.notch's GitHub settings
5. **Enable**: Toggle "Enable GitHub notifications" on
6. **Configure**: Set your preferred polling interval (default: 1 minute)

## Usage

### Viewing Notifications

When you have unread GitHub notifications:
- A badge with the count appears in the notch header when open
- The full notification list appears in the notch alongside other content
- Each notification shows:
  - Repository name and owner
  - Notification title
  - Type (Pull Request, Issue, Commit, etc.)
  - Time since last update
  - Unread status indicator

### Interacting with Notifications

- **Click a notification** to open it in your browser and mark it as read
- **Refresh button** to manually check for new notifications
- **Mark all as read** to clear all unread notifications at once
- **Hover** over notifications for visual feedback

### Settings Options

- **Enable/Disable**: Toggle the feature on or off
- **Polling Interval**: Choose how often to check for new notifications
  - 30 seconds
  - 1 minute (default)
  - 2 minutes
  - 5 minutes
  - 10 minutes
- **Show Badge**: Toggle the notification count badge in the header
- **Token Management**: Add or remove your GitHub token
- **Test Connection**: Verify your token and connection to GitHub

## Privacy & Security

- Your Personal Access Token is stored securely in the macOS Keychain
- Only the `notifications` scope is required (read-only access to notifications)
- No data is sent to third-party services
- All communication is directly with GitHub's API over HTTPS
- Token can be removed at any time from settings

## Troubleshooting

### "Not connected" status
- Ensure you've added a valid Personal Access Token
- Check that the token has the `notifications` scope
- Try removing and re-adding the token

### No notifications showing
- Verify you have unread notifications on GitHub
- Check your polling interval setting
- Use the "Test Connection" button to verify API access
- Click "Refresh now" to manually fetch notifications

### "Invalid token or unauthorized" error
- Your token may have expired or been revoked
- Regenerate a new token on GitHub and add it to settings
- Ensure the token has the correct scopes

## API Information

This feature uses GitHub's REST API v3:
- Endpoint: `https://api.github.com/notifications`
- Authentication: Personal Access Token
- Rate Limit: 5,000 requests per hour (for authenticated requests)
- Documentation: https://docs.github.com/en/rest/activity/notifications

## Comparison with Gitify

Like Gitify, boring.notch provides:
- ✅ GitHub notification monitoring
- ✅ Unread count badge
- ✅ Mark as read functionality
- ✅ Open in browser
- ✅ Configurable refresh intervals
- ✅ Secure token storage

Unique to boring.notch:
- 🎯 Integrated into the MacBook notch area
- 🎵 Combined with music, calendar, and other features
- 🎨 Native macOS SwiftUI interface
- 🔄 Part of a unified notification experience

## Contributing

If you'd like to enhance this feature:
- Add support for notification filtering by repository
- Implement notification grouping by type
- Add notification sounds
- Support for GitHub Enterprise
- OAuth authentication flow

## Credits

Inspired by [Gitify](https://gitify.io) - a great standalone GitHub notification app.
