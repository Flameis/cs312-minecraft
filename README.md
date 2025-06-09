# Automated Minecraft Server Infrastructure on AWS

Luke Scovel – 934-459-132 – CS312 System Administration

## Background

This project automates the provisioning, configuration, and deployment of a Minecraft server on AWS infrastructure using Infrastructure as Code (IaC) principles. Unlike manual setup processes, this solution uses Terraform for infrastructure provisioning, Ansible for configuration management, and bash scripts for orchestration to create a fully automated, reproducible deployment pipeline.

**What we'll do:**
- Provision AWS VPC, subnets, security groups, and EC2 instances using Terraform
- Configure the Minecraft server environment using Ansible
- Implement proper service management with systemd
- Ensure automatic server startup/shutdown on instance reboot
- Create a complete CI/CD pipeline for infrastructure management

**How we'll do it:**
- Use Terraform to define and provision AWS infrastructure
- Use Ansible to configure the EC2 instance and install Minecraft server
- Implement proper service lifecycle management
- Version control all infrastructure and configuration code

---

## Requirements

### Prerequisites
- **AWS Account** with programmatic access
- **AWS CLI v2.x** installed and configured
- **Terraform v1.5+** installed
- **Ansible v2.9+** installed
- **Git** for version control
- **nmap** for connectivity testing
- **jq** for JSON parsing

### AWS Credentials Setup
1. Access your AWS Learner Lab and retrieve credentials
2. Configure AWS CLI:
   ```bash
   aws configure
   # Enter your AWS Access Key ID, Secret Access Key, and region (us-west-2)
   ```
3. Verify access:
   ```bash
   aws sts get-caller-identity
   ```

### Environment Variables
Set the following environment variables (optional but recommended):
```bash
export AWS_DEFAULT_REGION=us-west-2
export TF_VAR_instance_type=t3.small
export TF_VAR_minecraft_port=25565
```

---

## Pipeline Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Git Repository │    │   Terraform      │    │   Ansible       │
│                 │───▶│   Infrastructure │───▶│   Configuration │
│ • IaC Scripts   │    │   Provisioning   │    │   Management    │
│ • Ansible Plays │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   AWS VPC       │    │   EC2 Instance  │
                       │ • Subnets       │    │ • Java Runtime  │
                       │ • Security Grps │    │ • Minecraft Srv │
                       │ • Internet GW   │    │ • Systemd Svc   │
                       └─────────────────┘    └─────────────────┘
```

### Major Pipeline Steps
1. **Infrastructure Provisioning** - Terraform creates AWS resources
2. **Instance Configuration** - Ansible configures the EC2 instance
3. **Minecraft Installation** - Automated download and setup
4. **Service Configuration** - Systemd service for auto-start/stop
5. **Validation** - Network connectivity testing

---

## Quick Start

### 1. Clone and Setup
```bash
git clone <repository-url>
cd minecraft-server-automation
chmod +x scripts/*.sh
```

### 2. Initialize Infrastructure
```bash
# Initialize Terraform
./scripts/init.sh

# Plan infrastructure changes
./scripts/plan.sh

# Apply infrastructure
./scripts/apply.sh
```

### 3. Configure Server
```bash
# Run Ansible configuration
./scripts/configure.sh
```

### 4. Validate Deployment
```bash
# Test connectivity
./scripts/test.sh
```

### 5. Cleanup (when done)
```bash
# Destroy infrastructure
./scripts/destroy.sh
```

---

## Detailed Commands

### Infrastructure Management
```bash
# Initialize Terraform backend and download providers
terraform init

# Create execution plan
terraform plan -out=tfplan

# Apply the planned changes
terraform apply tfplan

# Show current state
terraform show

# Destroy all resources
terraform destroy
```

### Configuration Management
```bash
# Run Ansible playbook
ansible-playbook -i inventory/aws_ec2.yml playbooks/minecraft-setup.yml

# Check Ansible connectivity
ansible all -i inventory/aws_ec2.yml -m ping

# Run specific tags
ansible-playbook -i inventory/aws_ec2.yml playbooks/minecraft-setup.yml --tags="minecraft"
```

### Service Management
```bash
# Check service status (via Ansible)
ansible all -i inventory/aws_ec2.yml -m systemd -a "name=minecraft state=started"

# View service logs
ansible all -i inventory/aws_ec2.yml -m shell -a "journalctl -u minecraft -n 50"
```

---

## Connecting to the Minecraft Server

### Network Validation
```bash
# Test server connectivity (replace with your instance IP)
nmap -sV -Pn -p T:25565 <INSTANCE_PUBLIC_IP>

# Expected output:
# PORT      STATE SERVICE   VERSION
# 25565/tcp open  minecraft Minecraft 1.20.x
```

### Minecraft Client Connection
1. Open Minecraft Java Edition
2. Navigate to "Multiplayer"
3. Click "Add Server"
4. Enter server details:
   - **Server Name**: "Automated AWS Server"
   - **Server Address**: `<INSTANCE_PUBLIC_IP>:25565`
5. Click "Done" and join the server

### Troubleshooting Connection Issues
```bash
# Check if port is accessible
telnet <INSTANCE_PUBLIC_IP> 25565

# Verify security group rules allow port 25565
aws ec2 describe-security-groups --group-ids <SECURITY_GROUP_ID>

# Check service status
ansible all -i inventory/aws_ec2.yml -m systemd -a "name=minecraft"
```

---

## Project Structure

```
minecraft-server-automation/
├── README.md
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── ansible/
│   ├── playbooks/
│   │   └── minecraft-setup.yml
│   ├── inventory/
│   │   └── aws_ec2.yml
│   └── roles/
│       └── minecraft/
├── scripts/
│   ├── init.sh
│   ├── plan.sh
│   ├── apply.sh
│   ├── configure.sh
│   ├── test.sh
│   └── destroy.sh
└── docs/
    └── architecture.md
```

---

## Resources and Sources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Ansible AWS Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html)
- [Minecraft Server Download API](https://launchermeta.mojang.com/mc/game/version_manifest.json)
- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
- [Systemd Service Management](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [Infrastructure as Code Principles](https://www.terraform.io/intro/index.html)

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.
