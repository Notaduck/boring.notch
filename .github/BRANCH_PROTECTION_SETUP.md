# Branch Protection Setup Guide

This guide explains how to configure GitHub branch protection rules to ensure that PRs with compilation errors cannot be merged.

## Why Branch Protection?

While the CI/CD workflow now properly fails when there are compilation errors, GitHub won't automatically block PRs from being merged unless branch protection rules are configured. This guide shows how to set that up.

## Setting Up Branch Protection

### For Repository Maintainers

1. **Navigate to Settings**
   - Go to the repository on GitHub
   - Click on "Settings" tab
   - Click on "Branches" in the left sidebar

2. **Add Branch Protection Rule**
   - Click "Add rule" or "Add branch protection rule"
   - In "Branch name pattern", enter: `main` (or `dev` for your development branch)

3. **Configure Required Status Checks**
   - ✅ Check "Require status checks to pass before merging"
   - ✅ Check "Require branches to be up to date before merging" (optional but recommended)
   - Search for and select these status checks:
     - `Build Boring Notch` - This is the critical one that catches compilation errors
     - `SwiftLint Analysis` (optional - only if you want to require no linting warnings)
     - `Code Signing Verification` (optional)

4. **Additional Recommended Settings**
   - ✅ Check "Require a pull request before merging"
   - ✅ Check "Require approvals" (set to at least 1)
   - ✅ Check "Dismiss stale pull request approvals when new commits are pushed"
   - ✅ Check "Do not allow bypassing the above settings"

5. **Save Changes**
   - Click "Create" or "Save changes" at the bottom

## What This Achieves

Once configured, GitHub will:
- ❌ **Block PR merges** when the build fails
- ✅ **Allow PR merges** only when the build passes
- 📊 Show clear status indicators on PRs
- 🔒 Prevent accidental merges of broken code

## Testing the Setup

To verify it's working:

1. Create a test branch with intentional compilation errors
2. Open a PR from that branch
3. Check that:
   - The "Build Boring Notch" check fails
   - The "Merge" button is disabled or shows "Merging is blocked"
   - The PR shows a red X indicator
   - You cannot merge the PR

## For Multiple Branches

If you want to protect multiple branches (e.g., `main`, `dev`):
- Create separate branch protection rules for each branch
- Or use wildcards in branch name patterns (e.g., `main*` or `dev*`)

## Troubleshooting

### "Status check not found"
- The status check names must match exactly what appears in the workflow
- Run a PR first to generate the status checks, then they'll appear in the list

### "Can still merge despite failed checks"
- Make sure "Require status checks to pass before merging" is checked
- Verify you selected the correct status checks
- Check that "Do not allow bypassing the above settings" is enabled

### "Checks not running"
- Verify the workflow file is in `.github/workflows/`
- Check that the workflow triggers on `pull_request` events
- Look at the Actions tab to see if workflows are being triggered

## Further Reading

- [GitHub Docs: Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Docs: Required Status Checks](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches#require-status-checks-before-merging)

## Current Configuration Status

As of this commit, branch protection rules need to be configured by a repository administrator. This document serves as a guide for setting them up.

### Who Can Configure This?

Only users with admin access to the repository can configure branch protection rules.
