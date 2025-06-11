# Automated Minecraft Server Infrastructure on AWS

Luke Scovel – 934-459-132 – CS312 System Administration

---

## Background

This project provides a fully automated solution for deploying and managing a Minecraft server on AWS infrastructure. The system provisions EC2 instances, configures networking, installs dependencies, and sets up the Minecraft server with proper systemd service management. The server is configured to automatically start on boot and can be managed through systemd commands for proper shutdown procedures.

### What We'll Do:
- Provision AWS EC2 infrastructure using Terraform
- Automate Minecraft server installation and configuration
- Set up systemd service for proper server lifecycle management
- Provide testing and management scripts
- Enable CI/CD deployment through GitHub Actions

### How We'll Do It:
1. **Infrastructure Provisioning**: Terraform creates EC2 instances, security groups, and networking
2. **Server Configuration**: Bash scripts install Java, download Minecraft server, and configure systemd
3. **Service Management**: Systemd ensures proper startup, shutdown, and restart behavior
4. **Testing & Validation**: Automated testing verifies server connectivity and functionality

---

## Requirements

- An AWS account
- A linux machine or WSL setup
- Basic knowledge of Linux commands
- Git installed
- AWS CLI configured with credentials

### AWS Credentials Setup
1. Access your AWS Management Console and retrieve credentials
2. Copy them into `~/.aws/credentials`:
```ini
[default]
aws_access_key_id=<YOUR_ACCESS_KEY>
aws_secret_access_key=<YOUR_SECRET_KEY>
aws_session_token=<YOUR_SESSION_TOKEN>
```

---

## Quick Start

### 1. Clone and Setup
```bash
git clone https://github.com/Flameis/cs312-minecraft.git
cd cs312-minecraft
chmod +x scripts/*.sh
```

### 2. Install Dependencies
```bash
./scripts/install.sh
```

### 3. Create the Resources
```bash
./scripts/create.sh
```

### 4. Test the Minecraft Server (Output will show server IP)
```bash
./scripts/test.sh
```

### 5. Connect to the Server
Open your Minecraft client and add a new server with the IP address shown in the test output, using port `25565`.

## Management Commands

### Restart the AWS Resources 
```bash
./scripts/restart.sh
```

### Destroy the AWS Resources (Warning: This will delete all server data)
```bash
./scripts/destroy.sh
```
---

## Detailed Commands And Pipeline

### `./scripts/install.sh`
Installs all required dependencies for the automation pipeline:
- **aws-cli**: For interacting with AWS services
- **Terraform**: Infrastructure as Code tool for provisioning AWS resources
- **OpenSSH**: For secure connection to EC2 instances
- **jq**: JSON processor for parsing AWS API responses
- **nmap**: Network scanner for testing server connectivity

### `./scripts/create.sh`
Complete infrastructure deployment and server configuration:
1. **AWS Authentication**: Verifies AWS CLI configuration
2. **SSH Key Management**: Generates or uses provided SSH key pairs
3. **Infrastructure Provisioning**: 
   - Runs Terraform to create EC2 instance
   - Sets up security groups with ports 22 (SSH) and 25565 (Minecraft)
   - Configures networking and public IP assignment
4. **Server Configuration**:
   - Installs Java Runtime Environment
   - Downloads latest Minecraft server jar
   - Creates EULA acceptance and server properties
   - Sets up systemd service for automatic startup/shutdown
   - Starts the Minecraft service

### `./scripts/test.sh`
Validates server deployment and functionality:
- **SSH Connectivity**: Tests SSH access to the instance
- **Service Status**: Verifies Minecraft service is running via systemd
- **Port Scanning**: Uses nmap to confirm Minecraft port (25565) is accessible
- **Connection Info**: Displays server IP for client connection

### `./scripts/restart.sh`
Manages server lifecycle and restarts:
- **Instance Reboot**: Safely reboots the EC2 instance using AWS CLI
- **Service Monitoring**: Waits for instance to come back online
- **Service Verification**: Checks and restarts Minecraft service if needed
- **Health Check**: Confirms server is accessible after restart

### `./scripts/destroy.sh`
Complete infrastructure cleanup:
- **Graceful Shutdown**: Terminates EC2 instances properly
- **Resource Cleanup**: Removes security groups and key pairs
- **State Management**: Uses Terraform destroy for complete cleanup
- **Verification**: Ensures all resources are properly removed

### Connecting to Your Server
1. Get your server IP from the test output
2. Open Minecraft client
3. Add server with IP: `<instance_ip>:25565`
4. Join and enjoy!

---

## Resources and Sources

- [Minecraft Server Download](https://www.minecraft.net/en-us/download/server)
- [Minecraft Version Manifest](https://launchermeta.mojang.com/mc/game/version_manifest.json)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Ubuntu Systemd Guide](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [SSH Configuration Guide](https://www.ssh.com/academy/ssh/config)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Copilot](https://github.com/features/copilot)

---