# Shift-Left Security Demo Script

A professional presentation guide for demonstrating Terraform security scanning with CrowdStrike FCS CLI.

## 🎯 Demo Objectives

**Duration:** 10-15 minutes
**Audience:** Technical teams, security professionals, executives
**Goal:** Demonstrate the value of shift-left security in DevOps workflows

## 📋 Pre-Demo Checklist

- [ ] GitHub repository set up with FCS CLI credentials
- [ ] Demo environment tested (run workflow once to verify)
- [ ] Browser tabs prepared:
  - GitHub repository main page
  - GitHub Actions tab
  - CrowdStrike Falcon Console (optional)
- [ ] Backup plan: Screenshots of expected results

## 🎤 Demo Script

### Opening (2 minutes)

**"Today I'm going to show you how shift-left security works in practice using Infrastructure as Code scanning."**

**Key Points:**
- Traditional security: Find issues in production → expensive, risky fixes
- Shift-left security: Catch issues during development → cheaper, safer fixes
- Real-world example using Terraform and CrowdStrike

**Show:** GitHub repository homepage, explain the simple structure

### The Problem (2 minutes)

**"Let's look at what we're scanning - this Terraform configuration has intentional security issues."**

**Navigate to:** [`terraform/main.tf`](terraform/main.tf)

**Highlight these issues:**
1. **S3 Bucket (lines 20-50):**
   - "No encryption configured - data at rest is vulnerable"
   - "Public access allowed - anyone can read/write data"
   - "No versioning - risk of data loss"

2. **IAM Role (lines 80-110):**
   - "PowerUserAccess - overly broad permissions"
   - "Wildcard permissions on all resources"
   - "No condition restrictions"

3. **Additional Issues (lines 120+):**
   - "Programmatic access keys instead of roles"
   - "User policies with broad S3 access"

**Key Message:** *"These are real security issues that could expose your data and AWS account to attackers."*

### The Solution (3 minutes)

**"Here's how we automatically catch these issues before deployment."**

**Navigate to:** [`.github/workflows/security-scan.yml`](.github/workflows/security-scan.yml)

**Explain the workflow:**
1. **Triggers (lines 3-8):** "Runs on every code push and pull request"
2. **Validation (lines 33-39):** "First checks Terraform syntax and runs terraform validate"
3. **Security Scan (lines 41-56):** "FCS CLI scans for security issues"
4. **Results Upload:** "Findings sent to CrowdStrike Falcon Console"

**Key Message:** *"This runs automatically - developers get immediate feedback without manual security reviews."*

### Live Demo (5 minutes)

**"Let's see this in action."**

**Option A: Make a live change**
```hcl
# Add a comment or change description in the Terraform configuration
variable "environment" {
  description = "Updated demo - showing live scanning"
  type        = string
  default     = "demo"
}
```

**Option B: Re-run existing workflow**
- Go to Actions tab → Select latest workflow → Re-run

**While workflow runs, explain:**
1. **Real-time feedback:** "Developers see results immediately in GitHub"
2. **No deployment delays:** "Scan runs in parallel with other CI/CD steps"
3. **Comprehensive coverage:** "Checks multiple security domains automatically"

### Results Analysis (3 minutes)

**"Let's examine what the scanner found."**

**Show workflow results:**
1. **Workflow status:** Green/red indicator shows pass/fail
2. **Detailed logs:** Expand the "Display Security Scan Results" step
3. **Findings summary:** Point out critical/high/medium counts
4. **Sample issues:** Show specific vulnerabilities detected

**Expected Results:**
```
🔴 Critical: 3+ (Wildcard permissions, public write access, admin policies)
🟠 High: 4+ (Public S3 access, no encryption, broad IAM permissions)
🟡 Medium: 4+ (No versioning, access keys, missing conditions)
📊 Total: 11+ issues
```

**Key Message:** *"Every issue would have been a production vulnerability - caught automatically during development."*

### Business Value (2 minutes)

**"Here's why this matters for your organization."**

**ROI Calculation:**
- **Traditional approach:** Production incident = $100K+ (downtime, reputation, remediation)
- **Shift-left approach:** Fix during development = $1K (developer time)
- **ROI:** 100:1 cost savings

**Additional Benefits:**
- **Faster delivery:** No security bottlenecks in deployment pipeline
- **Developer enablement:** Instant feedback improves security knowledge
- **Compliance automation:** Automatic evidence for audits
- **Reduced technical debt:** Fix issues immediately vs. accumulating over time

## 🎯 Key Talking Points

### For Technical Audiences
- "Zero configuration scanning - works with existing Terraform"
- "SARIF output integrates with GitHub Security tab"
- "Policy-as-code allows custom security rules"
- "Scales across multiple repositories and teams"

### For Security Teams
- "Centralized visibility in CrowdStrike Falcon Console"
- "Consistent policy enforcement across all environments"
- "Historical trending shows security posture improvements"
- "Integration with existing security workflows and tools"

### For Executives
- "Dramatic cost reduction in security remediation"
- "Faster time-to-market without compromising security"
- "Automated compliance reporting reduces audit overhead"
- "Proactive risk management vs. reactive incident response"

## 🔧 Troubleshooting

### If Workflow Fails
- **Check credentials:** Verify Falcon API secrets are configured
- **Show backup results:** Use screenshots of previous successful runs
- **Explain the failure:** "This demonstrates how the pipeline prevents insecure deployments"

### If No Issues Found
- **Verify template:** Ensure the vulnerable template is being scanned
- **Check thresholds:** Show the `fail_on` configuration
- **Discuss false negatives:** "Real-world scanning requires tuning policies"

### Questions & Answers

**"How do you handle false positives?"**
- FCS CLI allows policy customization and exception handling
- Teams can adjust thresholds based on risk tolerance
- Integration with approval workflows for justified exceptions

**"What about performance impact?"**
- Scanning adds ~2-3 minutes to CI/CD pipeline
- Runs in parallel with other build steps
- Caching reduces scan times for repeated runs

**"Can this work with other IaC tools?"**
- Yes - CloudFormation, Kubernetes YAML, Docker files
- Same principles apply across all infrastructure code
- CrowdStrike supports multiple IaC formats

## 📊 Success Metrics

**Immediate demo success:**
- ✅ Workflow completes successfully
- ✅ Security issues detected and displayed
- ✅ Results uploaded to Falcon Console
- ✅ Clear business value articulated

**Follow-up engagement:**
- Questions about implementation in their environment
- Interest in CrowdStrike Falcon Cloud Security
- Discussion of broader DevSecOps practices
- Requests for pilot or proof-of-concept

---

**Demo Duration:** 10-15 minutes
**Preparation Time:** 5 minutes
**Technical Level:** Intermediate
**Success Rate:** High (simple, reliable demo)