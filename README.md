# Automated Minecraft Server Infrastructure on AWS

Luke Scovel – 934-459-132 – CS312 System Administration

---

## Requirements

- An AWS account
- Basic knowledge of Linux commands
- A Minecraft client installed on your local machine
- A linux environment with `git`, `terraform`, and `aws-cli` installed

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
git clone <your-repository-url>
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

### 4. Test the Minecraft Server
```bash
./scripts/test.sh
```

---

## Detailed Commands


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
