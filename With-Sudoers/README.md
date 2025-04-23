🔧 Linux User Setup Script (Bash Version)
This Bash script automates the creation of a new Linux user with secure password setup and grants passwordless sudo access based on the operating system type.

📌 Features
✅ Prompts for username and password
✅ Auto-detects Linux OS (Debian/Ubuntu or RHEL/CentOS/Rocky/AlmaLinux)
✅ Adds user to the correct sudo group (sudo or wheel)
✅ Configures passwordless sudo via /etc/sudoers.d/username
✅ Designed for system administrators and DevOps engineers
📁 File
create_user-with-sudoers.sh: Main script for automated user setup and sudo provisioning
🚀 Usage
Make sure to run this script as root or with sudo.

chmod +x create_user-with-sudoers.sh
sudo ./create_user-with-sudoers.sh
