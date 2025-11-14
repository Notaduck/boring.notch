# Quick Reference: CI/CD Build Checks

## For Developers

### When You Open a PR

**Automated Checks Run:**
- ✅ SwiftLint (code quality)
- ✅ Code Signing Verification
- ✅ **Build** (compilation check) ← **This can block your PR**

### If Build Passes
- ✅ Green checkmark appears
- ✅ PR comment shows "Build Passed"
- ✅ You can request review

### If Build Fails ❌
- ❌ Red X appears on PR
- ❌ PR comment shows "Build Failed - Compilation Errors Detected"
- ❌ **Cannot merge until fixed**

**What to do:**
1. Click "View Full Report" link in PR comment
2. Check the build logs for specific errors
3. Fix the compilation errors locally
4. Push the fixes
5. Checks run automatically again

### Common Build Errors

```
Type 'Defaults' has no member '$githubPollingInterval'
```
→ Check if the property exists in Defaults

```
Generic parameter 'SelectionValue' could not be inferred
```
→ Explicitly specify the generic type

```
Cannot find 'SomeType' in scope
```
→ Add missing import statement

### Testing Locally

Before pushing, build locally:
```bash
xcodebuild -scheme boringNotch -configuration Release build
```

Or in Xcode:
- Product → Build (⌘B)
- Check for any errors or warnings

### Need Help?

- 📖 Read: `.github/CI_BUILD_FEEDBACK.md`
- 💬 Ask in Discord or PR comments
- 🔍 Check build logs in Actions tab

## For Maintainers

### Setup Required Checks
Follow: `.github/BRANCH_PROTECTION_SETUP.md`

### Key Points
- SwiftLint warnings don't block merges (by design)
- Build failures **do** block merges
- Both provide feedback on PRs

---

**Remember:** The build check is your friend! It catches errors before they reach production. 🚀
