# Troubleshooting & Learning Journal

## Git & Terraform Binaries
- **Problem:** GitHub rejected push due to 600MB+ Terraform provider binaries.
- **Solution:** Configured `.gitignore` to exclude `.terraform/` and used `git reset --mixed origin/main` to scrub the history.

## Terraform Syntax & Scope Errors
- **Problem:** Recieved "Duplicate Block" and "Resource not found" errors while trying to apply WAF rules.
- **Cause:** Incorrectly nested curly braces {} caused the terraform "boxes" to spill into each other, closing the main resource box before all rules were defined.
- **Solution:** Applied the "Nesting Doll" logic, ensuring every opening brace has a matching closing brace and that child blocks (like rule) stay strickly inside the parent resource block. used terraform fmt to visually verify the indentation levels.

## WAF Security Integration (403 Errors)
- **Problem:** Website returned a 403 Forbidden error after enabling the Web Application Firewall.
- **Cause:** The CloudFront distribution was associated with a WAF that had a "Block" default action or misconfigured rules, preventing legitimate traffic. 
- **Solution** Verified the association between CloudFront and WAF. Updated the WAF ACL to include AWS Managed Rules (Common Rule Set) and ensured the Default Action was set to "Allow" so only specific threats are blocked while regular users can see the site.

## Process Management & CLI Troubleshooting

- **Problem:** Terminal became unresponsive during a Git operation.
- **Cause:** Recognised that an incorreect command (git apply) was awaiting a patch imput that wasn't present
- **Solution:** Utilised SIGINT (Ctrl + C) to terminate the process and restored the deployment workflow to successfully push code to the remote repository.
