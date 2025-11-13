# Manual Steps to Complete GitHub Notifications Integration

## Overview
The GitHub notifications feature code has been implemented, but the Swift files need to be added to the Xcode project to be compiled. This document provides step-by-step instructions.

## Files to Add to Xcode Project

The following files have been created and need to be added to the Xcode project:

1. **Models** (in `boringNotch/models/` folder):
   - `GitHubNotificationModel.swift` - Data structures for GitHub notifications

2. **Managers** (in `boringNotch/managers/` folder):
   - `GitHubNotificationManager.swift` - Handles API calls and state management

3. **Views** (in `boringNotch/components/Notch/` folder):
   - `GitHubNotificationView.swift` - UI components for displaying notifications

## Step-by-Step Instructions

### Step 1: Open the Project
1. Navigate to the repository folder
2. Double-click `boringNotch.xcodeproj` to open it in Xcode

### Step 2: Add GitHubNotificationModel.swift
1. In Xcode's Project Navigator (left sidebar), locate the `boringNotch` folder
2. Expand it to find the `models` folder
3. Right-click on the `models` folder
4. Select "Add Files to 'boringNotch'..."
5. Navigate to `boringNotch/models/GitHubNotificationModel.swift`
6. **Important**: Uncheck "Copy items if needed" (the file is already in place)
7. Ensure the "boringNotch" target is checked
8. Click "Add"

### Step 3: Add GitHubNotificationManager.swift
1. In Xcode's Project Navigator, locate and right-click on the `managers` folder
2. Select "Add Files to 'boringNotch'..."
3. Navigate to `boringNotch/managers/GitHubNotificationManager.swift`
4. **Important**: Uncheck "Copy items if needed"
5. Ensure the "boringNotch" target is checked
6. Click "Add"

### Step 4: Add GitHubNotificationView.swift
1. In Xcode's Project Navigator, expand `components`, then locate the `Notch` folder
2. Right-click on the `Notch` folder
3. Select "Add Files to 'boringNotch'..."
4. Navigate to `boringNotch/components/Notch/GitHubNotificationView.swift`
5. **Important**: Uncheck "Copy items if needed"
6. Ensure the "boringNotch" target is checked
7. Click "Add"

### Step 5: Verify Files Are Added
1. In the Project Navigator, you should now see:
   - `models/GitHubNotificationModel.swift` (grouped with CalendarModel.swift, etc.)
   - `managers/GitHubNotificationManager.swift` (grouped with MusicManager.swift, etc.)
   - `components/Notch/GitHubNotificationView.swift` (grouped with NotchHomeView.swift, etc.)
2. All three files should appear in the project structure

### Step 6: Build the Project
1. Select the boringNotch scheme in the toolbar
2. Press `Cmd+B` to build the project
3. Wait for the build to complete
4. Check for any errors in the Issue Navigator (left sidebar, last icon)

### Expected Build Result
The project should build successfully without errors. The modified files already reference the new components:
- `BoringHeader.swift` - Shows GitHub notification badge
- `NotchHomeView.swift` - Displays GitHub notification list
- `SettingsView.swift` - Provides GitHub settings panel
- `Constants.swift` - Defines configuration defaults

## Verification Checklist

After adding the files and building successfully:

- [ ] Project builds without errors
- [ ] No "Cannot find type 'GitHubNotification'" errors
- [ ] No "Cannot find type 'GitHubNotificationManager'" errors
- [ ] No "Cannot find 'GitHubNotificationListView'" errors
- [ ] No "Cannot find 'GitHubNotificationBadge'" errors
- [ ] Settings window opens and shows "GitHub" section
- [ ] GitHub settings panel is accessible

## Testing the Feature

After successful build:

1. Run the application (Cmd+R)
2. Open Settings (click gear icon or menu bar → Settings)
3. Navigate to "GitHub" in the sidebar
4. Verify the settings panel appears correctly
5. Try adding a test token (you can use a fake token to test UI, or create a real one at https://github.com/settings/tokens)
6. Enable GitHub notifications
7. Open the notch and verify the notification area appears (when authenticated)

## Troubleshooting

### Build Errors

**"Cannot find type 'GitHubNotification' in scope"**
- Solution: Ensure `GitHubNotificationModel.swift` is added to the project and checked for the boringNotch target

**"Cannot find type 'GitHubNotificationManager' in scope"**
- Solution: Ensure `GitHubNotificationManager.swift` is added to the project and checked for the boringNotch target

**"Cannot find 'GitHubNotificationListView' in scope"**
- Solution: Ensure `GitHubNotificationView.swift` is added to the project and checked for the boringNotch target

**"Duplicate symbol" errors**
- Solution: Check that each file is only added once to the project. Look in the "Compile Sources" build phase.

### File Not Showing in Project

If a file doesn't appear after adding:
1. Check the file actually exists in the correct folder
2. Try adding it again using the "Add Files" method
3. Make sure you didn't accidentally check "Copy items if needed"
4. Verify the file is checked for the boringNotch target

### Clean Build

If you encounter persistent issues:
1. Product menu → Clean Build Folder (Cmd+Shift+K)
2. Close and reopen Xcode
3. Try building again (Cmd+B)

## Alternative Method: Manual Project File Editing

If the above steps don't work, you can manually edit the project file (advanced):

1. Close Xcode completely
2. Make a backup of `boringNotch.xcodeproj/project.pbxproj`
3. Open `project.pbxproj` in a text editor
4. Find similar file entries (e.g., CalendarModel.swift) and add corresponding entries for the new files
5. Generate UUIDs for the new entries
6. Save and reopen in Xcode

**Warning**: Manual editing of `.pbxproj` files is error-prone. Only attempt this if you're comfortable with XML-like formats.

## Support

If you encounter issues:
1. Check the error messages in Xcode's Issue Navigator
2. Verify all files are in their correct locations
3. Ensure file permissions are correct (files should be readable)
4. Try the Clean Build Folder option
5. Refer to `GITHUB_NOTIFICATIONS_IMPLEMENTATION.md` for additional context

## Success Indicators

When successfully integrated, you should be able to:
- ✅ Build the project without errors
- ✅ See "GitHub" option in Settings
- ✅ Configure a GitHub Personal Access Token
- ✅ View GitHub notifications in the notch when authenticated
- ✅ Mark notifications as read
- ✅ Open notifications in browser
- ✅ See notification count badge in the header

## Next Steps After Integration

Once the files are added and building successfully:
1. Test with a real GitHub account
2. Verify API calls work correctly
3. Test marking notifications as read
4. Test opening notifications in browser
5. Verify token storage in Keychain
6. Check performance and polling behavior
7. Update README.md to mention the new feature
8. Create release notes for the feature
