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


### Step 8: Create EC2 Instance for Jenkins Agent

To set up a Jenkins Agent node, create a new EC2 instance on AWS.

1. **Launch EC2 Instance**: Create an EC2 instance to serve as the Jenkins Agent.

   - **Instance Name**: `Jenkins-Agent`
   - **Instance Type**: Select an appropriate instance type based on workload requirements.
   - **AMI**: Choose an Amazon Machine Image (AMI), such as Ubuntu or Amazon Linux.
   - **Storage**: `gp3`, recommended minimum size.
   - **Security Group**: Ensure the security group has necessary ports open (e.g., port 22 for SSH).
   - **Key Pair**: Use an existing key pair or create a new one for access.

2. **Connect to Instance**: Use MobaXterm to connect to the `Jenkins-Agent` instance.

   - Open MobaXterm and initiate a new SSH session.
   - Use the **key pair** associated with the EC2 instance for secure access.
   - Set session name as `Jenkins Agent` in MobaXterm for easy identification.

The Jenkins Agent instance is now set up and connected. Proceed with necessary configurations and installations for it to act as a Jenkins node.

---


### Step 9: Configure Jenkins Agent Instance

1. **Update and Upgrade Packages**: After connecting to the `My-Jenkins-Agent` instance, update and upgrade system packages.
    ```bash
    sudo apt update
    sudo apt upgrade -y
    clear
    ```

2. **Set Hostname**:
   - Open the hostname configuration file:
       ```bash
       sudo nano /etc/hostname
       ```
   - Change the hostname to:
       ```
       My-Jenkins-Agent
       ```
   - Save and exit:
      - Press `Ctrl + X` to exit.
      - Press `Y` to confirm.
      - Press `Enter` to finalize.

   Alternatively, set the hostname directly using the following command:
    ```bash
    hostnamectl set-hostname My-Jenkins-Agent
    ```

3. **Restart the Instance**: Restart the instance to apply the new hostname.
    ```bash
    sudo init 6
    # or
    sudo reboot
    ```

After restarting, reconnect to the instance. The hostname should now be updated to `My-Jenkins-Agent`.

---


### Step 10: Install Java and Docker on Jenkins Agent

To prepare the Jenkins Agent, install Java and Docker on the instance.

1. **Install Java**: Jenkins requires Java to run, so install OpenJDK.
    ```bash
    sudo apt install openjdk-21-jre -y
    ```

2. **Verify Java Installation**:
    ```bash
    java --version
    ```
   This command should display the installed Java version, confirming that Java is properly installed.

3. **Install Docker**: Install Docker to allow Jenkins to manage containers on the agent.
    ```bash
    sudo apt install docker.io -y
    ```
   Alternatively:
    ```bash
    sudo apt-get install docker.io -y
    ```

4. **Add User to Docker Group**: Add the current user to the Docker group to enable Docker command usage without `sudo`.
    ```bash
    sudo usermod -aG docker $USER
    ```

5. **Restart the Instance**: Restart the instance to apply the changes.
    ```bash
    sudo reboot
    ```

After the restart, the Jenkins Agent is now configured with both Java and Docker.

---

### Step 11: Configure SSH for Jenkins Agent

To ensure secure and proper SSH key-based authentication for the Jenkins Agent, modify the SSH configuration file.

1. **Edit SSH Configuration File**:
    ```bash
    sudo nano /etc/ssh/sshd_config
    ```

2. **Uncomment and Set the Following Parameters**:
   - Find and uncomment (remove `#` at the beginning) the following lines:
       ```
       PubkeyAuthentication yes
       AuthorizedKeysFile      .ssh/authorized_keys .ssh/authorized_keys2
       ```

3. **Save and Exit**:
   - Press `Ctrl + X` to exit the editor.
   - Press `Y` to confirm saving changes.
   - Press `Enter` to finalize and close the editor.

4. **Reload SSH Service**: Apply the changes to the SSH configuration.
    ```bash
    sudo service ssh reload
    ```

The SSH configuration is now updated for key-based authentication on the Jenkins Agent.

---


### Step 12: Configure SSH for Jenkins Master

To enable secure SSH key-based authentication on the Jenkins Master instance, modify its SSH configuration file.

1. **Edit SSH Configuration File**:
    ```bash
    sudo nano /etc/ssh/sshd_config
    ```

2. **Uncomment and Set the Following Parameters**:
   - Locate and uncomment (remove `#` at the beginning) the following lines:
       ```
       PubkeyAuthentication yes
       AuthorizedKeysFile      .ssh/authorized_keys .ssh/authorized_keys2
       ```

3. **Save and Exit**:
   - Press `Ctrl + X` to exit the editor.
   - Press `Y` to confirm saving changes.
   - Press `Enter` to finalize and close the editor.

4. **Reload SSH Service**: Apply the changes to the SSH configuration.
    ```bash
    sudo service ssh reload
    ```

The SSH configuration is now updated to support key-based authentication on the Jenkins Master.

---


### Step 13: Set Up SSH Key Authentication Between Jenkins Master and Agent

To enable secure SSH communication between the Jenkins Master and Jenkins Agent, generate an SSH key on the Master and configure it on the Agent.

1. **Generate SSH Key on Jenkins Master**:
   - On the Jenkins Master, generate an SSH key pair:
       ```bash
       ssh-keygen
       ```
     Or, specify the key type:
       ```bash
       ssh-keygen -t ed25519
       ```

2. **Copy the Public Key**:
   - Open the public key file `id_ed25519.pub` on the Jenkins Master.
   - Copy the entire contents of this file.

3. **Add Public Key to Jenkins Agent**:
   - On the Jenkins Agent, open the `authorized_keys` file:
       ```bash
       nano ~/.ssh/authorized_keys
       ```
   - Paste the copied public key from the Master into this file.
   - Save and exit:
      - Press `Ctrl + X`, then `Y` to confirm, and `Enter` to finalize.

4. **Restart Both Instances**: To apply SSH changes, restart both the Jenkins Master and Agent instances.
    ```bash
    sudo reboot
    ```

After restarting, the SSH key authentication setup between Jenkins Master and Agent is complete.

---

### Step 14: Retrieve Jenkins Initial Admin Password and Add Agent Node

1. **Retrieve Jenkins Initial Admin Password**:
   - On the Jenkins Master, retrieve the initial admin password to unlock Jenkins.
       ```bash
       sudo cat /var/lib/jenkins/secrets/initialAdminPassword
       ```
   - Copy the password and paste it into the Jenkins setup screen in your web browser.

2. **Add Jenkins Agent as a Node**:
   - Go to the Jenkins Dashboard in your browser.
   - Navigate to **Manage Jenkins** > **Manage Nodes and Clouds** > **New Node**.
   - Enter a name for the Agent node (e.g., `Jenkins-Agent`), select the **Permanent Agent** option, and configure the required settings:
      - **Remote root directory**: Set the directory on the Agent where Jenkins will run jobs.
      - **Labels**: Add any relevant labels for the node, such as "agent" or "docker".
      - **Launch method**: Use "Launch agents via SSH" and provide the Agent's IP address, credentials, and SSH details.

3. **Save and Connect**: Save the configuration. Jenkins Master will connect to the Agent node using SSH and add it as a build agent.

The Jenkins Agent node is now connected and ready to use for job executions.

---

### Step 15: Add Jenkins Agent as a Node Using SSH

To connect the Jenkins Agent to the Jenkins Master, configure it as a node via SSH.

1. **Add Jenkins Agent Node in Jenkins Dashboard**:
   - In the Jenkins Dashboard, go to **Manage Jenkins** > **Manage Nodes and Clouds** > **New Node**.
   - Enter a name for the Agent node (e.g., `Jenkins-Agent`), select the **Permanent Agent** option, and configure the following settings:
      - **Remote root directory**: Set the directory on the Agent where Jenkins will run jobs (e.g., `/home/ubuntu`).
      - **Labels**: Add any relevant labels, such as "agent" or "docker", to categorize the node.
      - **Launch method**: Select **Launch agents via SSH**.

2. **Configure SSH Details**:
   - **Host**: Enter the IP address of the Agent instance.
   - **Credentials**: Choose or add SSH credentials (key-based) that correspond to the SSH setup between Master and Agent.
   - **Host Key Verification Strategy**: Set to "Non-verifying Verification Strategy" if you prefer to bypass strict verification.

3. **Save and Connect**:
   - After configuring, click **Save**. Jenkins Master will establish an SSH connection with the Agent and add it as a build node.

The Jenkins Agent node is now successfully connected via SSH and ready for job executions.

---

### Step 16: Set Up a Pipeline on Jenkins

With the Jenkins Master and Agent set up, the next step is to create a Jenkins pipeline.

1. **Create a New Pipeline Project**:
   - In the Jenkins Dashboard, navigate to **New Item**.
   - Enter a name for the pipeline project (e.g., `MyPipeline`).
   - Select **Pipeline** and click **OK** to create the new project.

2. **Configure Pipeline**:
   - Go to the **Pipeline** section of the project configuration page.
   - Choose the source of your pipeline script:
      - **Pipeline script**: Write the pipeline script directly in Jenkins.
      - **Pipeline script from SCM**: If the pipeline script (e.g., `Jenkinsfile`) is stored in a version control system like Git, choose this option and configure the repository details.
   - Define the stages of your pipeline in the script, such as build, test, and deploy stages.

3. **Save the Configuration**: Once your pipeline script is set up, click **Save** to finalize the configuration.

4. **Run the Pipeline**:
   - Go to the project page and click **Build Now** to start the pipeline.
   - Monitor the console output and pipeline stages to ensure each step executes correctly.

The initial Jenkins pipeline is now set up and ready for further configuration and stages as needed.

---

### Step 17: Create and Add GitHub Token to Jenkins

1. **Create a GitHub Token**:
   - Open a browser and go to the GitHub token generation page: [https://github.com/settings/tokens](https://github.com/settings/tokens).
   - Click **Generate new token** and provide a descriptive name for the token, such as `MyGitHubTokenForAWS`.
   - Select the necessary scopes, such as `repo` (for accessing repositories) and `workflow` (if working with GitHub Actions).
   - Click **Generate token** and copy the generated token (e.g., `ghp_12345678901234567890`).

2. **Add GitHub Token to Jenkins**:
   - In Jenkins, navigate to **Dashboard** > **Manage Jenkins** > **Manage Credentials**.
   - Select the appropriate credentials domain (usually **Global**).
   - Click on **Add Credentials**.
      - **Kind**: Select **Secret text**.
      - **Secret**: Paste the GitHub token (`ghp_12345678901234567890`).
      - **ID**: Optionally, give an ID to the token (e.g., `MyGitHubTokenForAWS`).
      - **Description**: Enter a description for easy reference.
   - Click **OK** to save the credential.

3. **Using the GitHub Token in Pipelines**:
   - Now, you can reference this token in Jenkins pipeline scripts or configurations when accessing GitHub repositories.

The GitHub token is now securely stored in Jenkins and ready for use in pipeline projects.

---


### Step 18: Jenkins Pipeline Script (Jenkinsfile)

Below is the Jenkinsfile script for automating the CI/CD process. This pipeline includes stages for workspace cleanup, source code checkout, Maven build, testing, and optional stages for Docker and Kubernetes deployment.

```groovy
pipeline {
    agent any
    tools {
        jdk 'JDK21'
        maven 'Maven3'
    }
    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from SCM') {
            steps {
                git branch: 'master', credentialsId: 'github', url: 'https://github.com/mimaraslan/devops-003-pipeline-aws'
            }
        }
        stage('Build Maven') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test Application') {
            steps {
                sh 'mvn test'
            }
        }
        /*
        stage('Docker Image') {
            steps {
                bat 'docker build  -t mimaraslan/my-application:latest  .'
            }
        }

        stage('Docker Image to DockerHub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
                        bat 'echo docker login -u mimaraslan -p ${dockerhub}'
                        bat 'docker image push  mimaraslan/my-application:latest'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                kubernetesDeploy(configs: 'deployment-service.yml', kubeconfigId: 'kubernetes')
            }
        }

        stage('Docker Image to Clean') {
            steps {
                bat 'docker image prune -f'
            }
        }
        */
    }
}
```
