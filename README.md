# Automated Minecraft Server Infrastructure on AWS

Luke Scovel – 934-459-132 – CS312 System Administration

---

## Requirements

### AWS Credentials Setup
1. Access your AWS Learner Lab and retrieve credentials
2. Setup your repository with the following repository variables:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_SESSION`
   - `SSH_KEY` (Create your own private key for SSH access)

### Environment Variables
Set the following environment variables:
```bash
export AWS_DEFAULT_REGION=us-west-2
export TF_VAR_instance_type=t3.small
export TF_VAR_minecraft_port=25565
```
---

## Quick Start

### 1. Clone and Setup
```bash
git clone <your-repository-url>
cd cs312-minecraft
chmod +x scripts/*.sh
```

### 2. Create Infrastructure and Configure Server
```bash
# Create infrastructure and configure server
./scripts/create.sh
```

### 3. Test Connectivity
```bash
# Test connectivity
./scripts/test.sh
```

### 4. Cleanup (when done)
```bash
# Destroy infrastructure
./scripts/destroy.sh
```

---

## Detailed Commands

### Infrastructure Management
```bash
# Initialize Terraform backend and download providers
cd terraform
terraform init

# Create and apply infrastructure
terraform apply

# Show current state
terraform show

# Destroy all resources
terraform destroy
```

### Configuration Management
```bash
# SSH into instance for manual configuration (use saved key)
ssh -i minecraft-key.pem ec2-user@<INSTANCE_IP>

# Check service status via SSH
ssh -i minecraft-key.pem ec2-user@<INSTANCE_IP> "sudo systemctl status minecraft"

# View service logs via SSH
ssh -i minecraft-key.pem ec2-user@<INSTANCE_IP> "sudo journalctl -u minecraft -n 50"
```

### Service Management
```bash
# Check service status
ssh -i minecraft-key.pem ec2-user@<INSTANCE_IP> "sudo systemctl status minecraft"

# Restart service
ssh -i minecraft-key.pem ec2-user@<INSTANCE_IP> "sudo systemctl restart minecraft"

# View logs
ssh -i minecraft-key.pem ec2-user@<INSTANCE_IP> "sudo journalctl -u minecraft -f"
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
ssh -i minecraft-key.pem ec2-user@<INSTANCE_IP> "sudo systemctl status minecraft"
```

---

## Resources and Sources

- [Minecraft Server Download](https://www.minecraft.net/en-us/download/server)
- [Minecraft Version Manifest](https://launchermeta.mojang.com/mc/game/version_manifest.json)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Ubuntu Systemd Guide](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [SSH Configuration Guide](https://www.ssh.com/academy/ssh/config)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.
