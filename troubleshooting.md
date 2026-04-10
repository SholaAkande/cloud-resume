# Troubleshooting & Learning Journal

## Git & Terraform Binaries
- **Problem:** GitHub rejected push due to 600MB+ Terraform provider binaries.
- **Solution:** Configured `.gitignore` to exclude `.terraform/` and used `git reset --mixed origin/main` to scrub the history.

