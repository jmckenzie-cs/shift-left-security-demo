# Shift-Left Security Demo - Terraform Edition

A simple, clean demonstration of shift-left security principles using Terraform Infrastructure as Code (IaC) scanning with CrowdStrike Falcon Cloud Security CLI.

## 🎯 Demo Overview

This repository demonstrates how to integrate security scanning into your development workflow to catch infrastructure security issues **before** they reach production. The demo showcases:

- **Terraform configuration** with intentional security misconfigurations
- **Automated scanning** using CrowdStrike FCS CLI in GitHub Actions
- **Automated remediation** with pull requests containing security fixes
- **Real-time results** displayed in GitHub workflow and uploaded to Falcon Console
- **Professional presentation** suitable for external demonstrations

## 🏗️ What's Included

### Terraform Configuration
[`terraform/main.tf`](terraform/main.tf) contains:

**S3 Bucket Misconfigurations:**
- ❌ Public read/write access enabled
- ❌ No encryption configured
- ❌ No versioning enabled
- ❌ No access logging

**IAM Security Issues:**
- ❌ Overly permissive roles with `PowerUserAccess`
- ❌ Wildcard permissions (`*` actions on `*` resources)
- ❌ No condition restrictions
- ❌ Programmatic access keys instead of roles

### Security Scanning Pipeline
[`.github/workflows/security-scan.yml`](.github/workflows/security-scan.yml) provides:

- ✅ Terraform syntax validation
- ✅ FCS CLI security scanning
- ✅ **Automated remediation branches** for critical/high severity issues
- ✅ Results uploaded to CrowdStrike Falcon Console
- ✅ SARIF results uploaded to GitHub Security Hub
- ✅ Detailed findings displayed in GitHub
- ✅ PR comments with security feedback
- ✅ Downloadable scan artifacts

## 🚀 Quick Start

### Prerequisites
- GitHub repository with Actions enabled
- CrowdStrike Falcon Cloud Security subscription
- Falcon API credentials (Client ID and Secret)

### Setup

1. **Clone or fork this repository**
   ```bash
   git clone <your-repo-url>
   cd shift-left-security-demo-v2
   ```

2. **Configure GitHub Secrets**
   Go to Repository Settings → Secrets and Variables → Actions, and add:
   - `FALCON_CLIENT_ID`: Your CrowdStrike Falcon API Client ID
   - `FALCON_CLIENT_SECRET`: Your CrowdStrike Falcon API Client Secret

3. **Trigger the demo**
   - Push to `main` or `develop` branch
   - Create a pull request
   - Or manually trigger via Actions tab

### View Results

**In GitHub:**
- Check the Actions tab for workflow results
- View detailed scan output in workflow logs
- **View security alerts in Security tab → Code scanning alerts**
- **Check for automated remediation branches** (fixes critical/high issues)
- Download scan artifacts for offline analysis

**In CrowdStrike Falcon Console:**
- Navigate to Cloud Security → IaC Security
- Find your project: `shift-left-security-demo-terraform`
- Review detailed security findings and remediation guidance

## 📊 Expected Results

This demo template contains **11+ intentional security issues** that FCS CLI will detect:

| Severity | Count | Examples |
|----------|-------|----------|
| Critical | 2+ | Wildcard IAM permissions, Public S3 write access |
| High | 2+ | Public S3 access, No encryption |
| Medium | 2+ | No versioning, Access keys usage |

## 🔧 Automated Remediation

When critical or high severity security issues are detected, the workflow automatically:

1. **Creates a fix branch** (`security-fixes/critical-high-remediation`)
2. **Applies security fixes** using secure Terraform templates
3. **Pushes the branch** with comprehensive security improvements
4. **Documents all changes** with detailed fix descriptions and security impact

### Example Automated Fixes:
- 🛡️ Block S3 bucket public access (prevents data exposure)
- 🔐 Enable S3 server-side encryption (protects data at rest)
- 📋 Enable S3 versioning (prevents accidental data loss)
- 🚫 Remove wildcard IAM permissions (enforces least privilege)
- 📍 Add IAM condition restrictions (limits permission scope)
- 🔑 Replace access keys with IAM roles (reduces credential risk)

## 🎪 Demo Script

See [`DEMO.md`](DEMO.md) for a complete presentation script with talking points and expected outcomes.

## 🔧 Customization

### Adjusting Scan Thresholds
Edit the `fail_on` parameter in the GitHub workflow:
```yaml
fail_on: 'critical=5,high=10'  # Adjust numbers as needed
```

### Adding More Vulnerabilities
Extend the Terraform configuration with additional misconfigurations:
- RDS instances without encryption
- Security groups with open access
- Lambda functions with excessive permissions
- Missing CloudTrail logging

### Multi-Environment Support
Use Terraform variables to deploy different configurations:
```bash
terraform plan -var="environment=dev"
terraform apply -var="environment=prod"
```

## 🔒 Security Note

**⚠️ WARNING:** This template contains intentional security vulnerabilities for demonstration purposes.
- **DO NOT** deploy this template to production environments
- Use only in isolated demo/test accounts
- Review and understand each vulnerability before presenting

## 📚 Learn More

- [Shift-Left Security Principles](https://www.crowdstrike.com/cybersecurity-101/shift-left-security/)
- [CrowdStrike Falcon Cloud Security](https://www.crowdstrike.com/products/cloud-security/)
- [Terraform Best Practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices)
- [AWS Terraform Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Infrastructure as Code Security](https://docs.aws.amazon.com/whitepapers/latest/introduction-devops-aws/infrastructure-as-code.html)

## 🤝 Contributing

This is a demonstration repository. For improvements or questions:
1. Fork the repository
2. Make your changes
3. Test thoroughly in a safe environment
4. Submit a pull request

---

**Demo Version:** Terraform Edition
**Last Updated:** January 2026
**Purpose:** External demonstration of shift-left security principles