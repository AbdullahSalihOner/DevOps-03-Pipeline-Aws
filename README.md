# DevOps-03-Pipeline-Aws

## About

This project demonstrates a CI/CD pipeline using DevOps practices and AWS Cloud services. The primary tools and technologies utilized in this pipeline include Jenkins, Java, Git, GitHub, Maven, Docker, DockerHub, Kubernetes, SonarQube, ArgoCD, Trivy, and AWS Cloud.

## Table of Contents

- [Project Overview](#project-overview)
- [Technologies Used](#technologies-used)
- [Pipeline Steps](#pipeline-steps)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [References](#references)

---

## Project Overview

This project aims to build a complete CI/CD pipeline leveraging various DevOps tools and AWS Cloud infrastructure to automate software development and deployment processes.

## Technologies Used

- **Jenkins**: For continuous integration and automation.
- **Java**: The programming language for the application.
- **Git & GitHub**: Version control and code repository.
- **Maven**: Dependency management and build automation.
- **Docker & DockerHub**: Containerization and image repository.
- **Kubernetes**: Container orchestration.
- **SonarQube**: Code quality and security analysis.
- **ArgoCD**: GitOps continuous delivery.
- **Trivy**: Container security scanning.
- **AWS Cloud**: Infrastructure and cloud services.

---

## Pipeline Steps

### Step 1: Create EC2 Instance for Jenkins Master

1. **Launch EC2 Instance**: Create an EC2 instance on AWS to serve as the Jenkins Master server.

    - Instance Name: `My-Jenkins-Master`
    - Instance Type: `t3.xlarge` (This instance type provides a balance of CPU, memory, and network performance.)    
    - AMI: Choose an Amazon Machine Image (AMI), such as Ubuntu or Amazon Linux.
    - Storage: `gp3`, 12 GB (General Purpose SSD)
    - Security Group: Configure the security group to allow necessary ports (e.g., port 8080 for Jenkins UI and port 22 for SSH access).
    - Key Pair: Create or use an existing key pair to access the instance.

2. **Instance Configuration**: After launching, ensure that the instance has access to necessary AWS resources (IAM Role, VPC configuration, etc.).

3. **Connect to Instance**: Use SSH to connect to the `My-Jenkins-Master` instance and proceed with Jenkins installation.

---

### Step 2: Connect to EC2 Instance

1. **Connect to EC2 Instance**: Use MobaXterm to establish an SSH connection to the `My-Jenkins-Master` EC2 instance.

    - Open MobaXterm and start a new SSH session.
    - Use the **key pair** associated with the EC2 instance for secure access.
    - Connect with the following parameters:
        - **Host**: The public IP or DNS of the `My-Jenkins-Master` instance.
        - **Username**: Typically `ubuntu` for Ubuntu AMI or `ec2-user` for Amazon Linux AMI.

2. **Session Naming**: Name the session as `Master` in MobaXterm for easy identification.

After connecting to the EC2 instance, proceed with Jenkins installation.

---


### Step 3: Update and Upgrade Packages on Jenkins Master

Once connected to the `My-Jenkins-Master` instance, update and upgrade the system packages to ensure it is ready for Jenkins installation.

1. **Update the Package List**:
    ```bash
    sudo apt update
    ```

2. **Upgrade Installed Packages**:
    ```bash
    sudo apt upgrade -y
    ```

3. **Clear the Terminal** (optional):
    ```bash
    clear
    ```

The system is now updated and ready for the Jenkins installation steps.

---

### Step 4: Set Hostname and Restart Jenkins Master

1. **Set Hostname**: Open the hostname configuration file to set a custom hostname for the `My-Jenkins-Master` instance.
    ```bash
    sudo nano /etc/hostname
    ```

2. **Edit Hostname**: Change the content to:
    ```
    My-Jenkins-Master
    ```

3. **Save and Exit**:
    - Press `Ctrl + X` to exit the editor.
    - Press `Y` to confirm saving changes.
    - Press `Enter` to finalize and close the editor.

4. **Restart the Instance**: Restart the instance to apply the new hostname.
    ```bash
    sudo init 6
    # or
    sudo reboot
    ```

After restarting, reconnect to the instance. The hostname should now be updated to `My-Jenkins-Master`.

---

### Step 5: Configure Security Group for Jenkins Access

To allow external access to the Jenkins UI, open port 8080 in the instance's security group.

1. **Navigate to Security Groups**: In the AWS Management Console, go to **EC2 Dashboard** > **Network & Security** > **Security Groups**.

2. **Select Security Group**: Locate and select the security group associated with the `My-Jenkins-Master` instance.

3. **Edit Inbound Rules**:
    - Click on **Edit inbound rules**.
    - Add a new rule to allow access on port 8080.
    - **Type**: Custom TCP
    - **Port Range**: 8080
    - **Source**: Anywhere (0.0.0.0/0) for IPv4

4. **Save Rules**: Click **Save rules** to apply the changes.

Port 8080 is now open, allowing access to Jenkins UI from the internet.

---

### Step 6: Install Java for Jenkins

Jenkins requires Java to run. Install Java on the `My-Jenkins-Master` instance with the following steps:

1. **Check if Java is Already Installed**:
    ```bash
    java -version
    ```
   If Java is not installed, proceed with the installation.

2. **Install Java**: Install OpenJDK version 21.
    ```bash
    sudo apt install openjdk-21-jre -y
    ```

3. **Verify Java Installation**:
    ```bash
    java --version
    ```
   This should display the installed Java version, confirming the installation.

Java is now installed and ready for Jenkins installation.

---

### Step 7: Install and Start Jenkins

1. **Add Jenkins Repository Key**: Download the Jenkins GPG key and add it to the keyring.
    ```bash
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian/jenkins.io-2023.key
    ```

2. **Add Jenkins Repository**: Add the Jenkins repository to the package manager.
    ```bash
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/" | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    ```

3. **Update Package List**: Update the package list to include the Jenkins repository.
    ```bash
    sudo apt-get update
    ```

4. **Install Jenkins**:
    ```bash
    sudo apt-get install jenkins -y
    ```

5. **Configure Jenkins to Start on Boot and Start Service**:
    - Enable Jenkins to start at boot:
        ```bash
        sudo systemctl enable jenkins
        ```
    - Start Jenkins service:
        ```bash
        sudo systemctl start jenkins
        ```
    - Check Jenkins service status:
        ```bash
        sudo systemctl status jenkins
        ```

6. **Access Jenkins**: Once Jenkins is running, access the Jenkins UI in a web browser using the following URL:
    ```
    http://<My-Jenkins-Master_Public_IPv4_address>:8080/
    ```
   Replace `<My-Jenkins-Master_Public_IPv4_address>` with the actual public IPv4 address of the EC2 instance.

7. **Retrieve Jenkins Initial Admin Password**: To complete the setup, retrieve the initial admin password.
    ```bash
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    ```

Copy this password to unlock Jenkins and continue with the setup in the browser.

---


