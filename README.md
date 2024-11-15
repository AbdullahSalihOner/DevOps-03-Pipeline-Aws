# DevOps-03-Pipeline-Aws

## About

This project demonstrates a CI/CD pipeline using DevOps practices and AWS Cloud services. The primary tools and technologies utilized in this pipeline include Jenkins, Java, Git, GitHub, Maven, Docker, DockerHub, Kubernetes, SonarQube, ArgoCD, Trivy, and AWS Cloud.

## Table of Contents

- [Project Overview](#project-overview)
- [Technologies Used](#technologies-used)
- [Pipeline Steps](#pipeline-steps)
---

## Project Overview

This project aims to build a complete CI/CD pipeline leveraging various DevOps tools and AWS Cloud infrastructure to automate software development and deployment processes.

![CI/CD Workflow Diagram](images/3.png)


![Updated CI/CD Workflow Diagram with ArgoCD and Trivy](images/10.png)

![Updated CI/CD Workflow Diagram with ArgoCD and Trivy](images/11.png)
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
![SSH Key Setup](images/1.png)
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

![Jenkins Pipeline](images/2.png)

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

### Step 19: Set Up SonarQube Server on EC2

To enable code quality analysis, create an EC2 instance specifically for running SonarQube.

1. **Launch EC2 Instance**:
   - **Instance Name**: `My-SonarQube`
   - **AMI**: Ubuntu
   - **Instance Type**: `t3.xlarge` (provides a balanced CPU, memory, and network performance suitable for SonarQube)
   - **Storage**: Allocate at least 15 GB to accommodate SonarQube requirements.
   - **Security Group**: Configure security group settings to allow access on necessary ports, such as port 9000 for SonarQube’s web interface.
   - **Key Pair**: Select or create a key pair to access the instance.

2. **Connect to SonarQube Instance**: Use an SSH client (e.g., MobaXterm) to connect to the `My-SonarQube` instance.

Next, proceed with installing and configuring SonarQube on the instance to analyze code quality in your Jenkins pipelines.

---

### Step 20: Assign Elastic IPs to Instances

To provide stable IP addresses for easier access, Elastic IPs are assigned to each EC2 instance.

1. **Create Elastic IPs**:
   - In the AWS Management Console, navigate to **EC2 Dashboard** > **Network & Security** > **Elastic IPs**.
   - Allocate new Elastic IP addresses for each instance that requires a static IP (e.g., Jenkins Master, Jenkins Agent, My-SonarQube).

2. **Associate Elastic IPs with Instances**:
   - For each Elastic IP, select **Actions** > **Associate Elastic IP address**.
   - Choose the instance you want to associate the IP with (e.g., `My-Jenkins-Master`, `My-Jenkins-Agent`, or `My-SonarQube`).
   - Confirm and apply the association.

3. **Update MobaXterm**:
   - Open MobaXterm and update the session configurations for each instance.
   - Replace the previous public IPs with the new Elastic IPs assigned to each instance.
   - Save the configurations to maintain stable access to each server.

The instances now have static IP addresses, making it easier to manage and connect without changing IP addresses.

---

### Step 21: Configure My-SonarQube Instance

1. **Update and Upgrade Packages**: After connecting to the `My-SonarQube` instance, update and upgrade system packages.
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
       My-SonarQube
       ```
   - Save and exit:
      - Press `Ctrl + X` to exit.
      - Press `Y` to confirm.
      - Press `Enter` to finalize.

   Alternatively, set the hostname directly using the following command:
    ```bash
    hostnamectl set-hostname My-SonarQube
    ```

3. **Restart the Instance**: Restart the instance to apply the new hostname.
    ```bash
    sudo init 6
    # or
    sudo reboot
    ```

After restarting, reconnect to the instance. The hostname should now be updated to `My-SonarQube`.

---


### Step 22: Install and Configure PostgreSQL for SonarQube

To set up a database for SonarQube, install PostgreSQL on the `My-SonarQube` instance and create a database and user.

1. **Add PostgreSQL Repository**:
   - Add the PostgreSQL repository to the sources list:
       ```bash
       sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
       ```
   - Add the PostgreSQL signing key:
       ```bash
       wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc &>/dev/null
       ```

2. **Install PostgreSQL**:
   - Update the package list and install PostgreSQL.
       ```bash
       sudo apt update
       sudo apt-get -y install postgresql postgresql-contrib
       ```
   - Enable PostgreSQL to start on boot:
       ```bash
       sudo systemctl enable postgresql
       ```

3. **Set PostgreSQL Password**:
   - Set a password for the `postgres` user:
       ```bash
       sudo passwd postgres
       ```
   - Enter the password when prompted (e.g., `123456789`).

4. **Configure SonarQube Database**:
   - Switch to the `postgres` user:
       ```bash
       su - postgres
       ```
   - Create a new PostgreSQL user for SonarQube:
       ```bash
       createuser sonar
       ```
   - Access the PostgreSQL prompt:
       ```bash
       psql
       ```
   - Set a password for the `sonar` user:
       ```sql
       ALTER USER sonar WITH ENCRYPTED password 'sonar';
       ```
   - Create the `sonarqube` database owned by the `sonar` user:
       ```sql
       CREATE DATABASE sonarqube OWNER sonar;
       ```
   - Grant all privileges on the `sonarqube` database to the `sonar` user:
       ```sql
       GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
       ```
   - Exit the PostgreSQL prompt:
       ```sql
       \q
       ```
   - Exit from the `postgres` user:
       ```bash
       exit
       ```

The PostgreSQL database and user for SonarQube are now configured.

---


### Step 23: Add Adoptium Repository

To install a specific version of OpenJDK from the Adoptium repository, first add the repository to the `My-SonarQube` instance.

1. **Switch to Root User**:
    ```bash
    sudo bash
    ```

2. **Add Adoptium Repository Key**:
   - Download and add the GPG key for the Adoptium repository:
       ```bash
       wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
       ```

3. **Add the Adoptium Repository**:
   - Add the Adoptium repository to the sources list:
       ```bash
       echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
       ```

4. **Update Package List**:
   - Update the package list to include the new repository:
       ```bash
       sudo apt update
       ```

The Adoptium repository is now added and ready for installing OpenJDK from Adoptium.

---

### Step 24: Install Java 17 from Adoptium on My-SonarQube

Install Java 17 on the `My-SonarQube` instance to support SonarQube's runtime requirements.

1. **Install Java 17**:
   - You can install either the JRE or the full JDK version of OpenJDK 17:
       ```bash
       sudo apt install openjdk-17-jre -y
       ```
     Or, to install the Temurin JDK 17 package:
       ```bash
       sudo apt install temurin-17-jdk -y
       ```

2. **Configure Java Alternatives**:
   - If multiple Java versions are installed, you can set Java 17 as the default:
       ```bash
       sudo update-alternatives --config java
       ```

3. **Verify Java Installation**:
   - Check the Java version to confirm the installation:
       ```bash
       java --version
       ```

Java 17 is now installed and configured on the `My-SonarQube` instance.

---


### Step 25: Update Linux Kernel Limits for SonarQube

To ensure that SonarQube runs smoothly with sufficient file and process limits, update the kernel limits configuration.

1. **Open Limits Configuration File**:
    ```bash
    sudo vim /etc/security/limits.conf
    ```

2. **Edit Configuration**:
    - Press `i` to enter insert mode.
    - Add the following lines to set the necessary file and process limits:
        ```
        sonarqube   -   nofile   65536
        sonarqube   -   nproc    4096
        ```

3. **Save and Exit**:
    - Press `ESC` to exit insert mode.
    - Type `:wq` and press `Enter` to save changes and close the file.

The kernel limits are now updated to support SonarQube’s requirements.

---

### Step 26: Update `sysctl` Configuration for SonarQube

To ensure that SonarQube has sufficient virtual memory mapping, update the `sysctl` configuration.

1. **Open `sysctl.conf` File**:
    ```bash
    sudo vim /etc/sysctl.conf
    ```

2. **Edit Configuration**:
    - Press `i` to enter insert mode.
    - Add the following line to set the maximum virtual memory map count:
        ```
        vm.max_map_count = 262144
        ```

3. **Save and Exit**:
    - Press `ESC` to exit insert mode.
    - Type `:wq` and press `Enter` to save changes and close the file.

4. **Restart the Instance**:
    - To apply the new configuration, restart the instance:
        ```bash
        sudo init 6
        ```
      Or:
        ```bash
        sudo reboot
        ```

The system configuration is now updated, and the instance has been restarted to apply the new settings.

---

### Step 27: Open Port 9000 for SonarQube Access

To allow external access to the SonarQube web interface, open port 9000 in the security group settings.

1. **Open Security Groups in AWS Console**:
    - Go to the AWS Management Console and navigate to **EC2 Dashboard** > **Network & Security** > **Security Groups**.

2. **Select SonarQube Security Group**:
    - Locate and select the security group associated with the `My-SonarQube` instance.

3. **Edit Inbound Rules**:
    - Click on **Edit inbound rules**.
    - Add a new rule to allow access on port 9000.
        - **Type**: Custom TCP
        - **Port Range**: 9000
        - **Source**: Anywhere (0.0.0.0/0) for IPv4 or configure as needed for your environment.

4. **Save Rules**: Click **Save rules** to apply the changes.

Port 9000 is now open, allowing access to the SonarQube web interface from the internet.

---

### Step 28: Install SonarQube and Configure Permissions

Download and install SonarQube on the `My-SonarQube` instance, then configure a dedicated user to manage it.

1. **Download SonarQube**:
    - Download the SonarQube package from SonarSource:
        ```bash
        sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.6.0.92116.zip
        ```

2. **Install Unzip Utility**:
    - Install `unzip` if it is not already installed:
        ```bash
        sudo apt install unzip
        ```

3. **Extract SonarQube**:
    - Unzip the SonarQube package to the `/opt` directory:
        ```bash
        sudo unzip sonarqube-10.6.0.92116.zip -d /opt
        ```
    - Move to `/opt` and rename the SonarQube directory for simplicity:
        ```bash
        sudo mv /opt/sonarqube-10.6.0.92116 /opt/sonarqube
        ```

4. **Create a SonarQube User and Group**:
    - Create a new group named `sonar`:
        ```bash
        sudo groupadd sonar
        ```
    - Create a new user named `sonar` and assign it to the `sonar` group, setting its home directory to `/opt/sonarqube`:
        ```bash
        sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonar sonar
        ```

5. **Set Ownership**:
    - Grant the `sonar` user and group ownership of the SonarQube directory:
        ```bash
        sudo chown sonar:sonar /opt/sonarqube -R
        ```

SonarQube is now downloaded, extracted, and ready for configuration, with permissions set for the `sonar` user to manage it.

---

### Step 29: Configure SonarQube to Connect to PostgreSQL Database

To enable SonarQube to connect to the PostgreSQL database, update the database connection properties in the configuration file.

1. **Open SonarQube Configuration File**:
    ```bash
    sudo vim /opt/sonarqube/conf/sonar.properties
    ```

2. **Edit Database Connection Settings**:
    - Press `i` to enter insert mode.
    - Update the following lines with the PostgreSQL connection details:
        ```properties
        sonar.jdbc.username=sonar
        sonar.jdbc.password=sonar
        sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
        ```

3. **Save and Exit**:
    - Press `ESC` to exit insert mode.
    - Type `:wq` and press `Enter` to save changes and close the file.

SonarQube is now configured to connect to the PostgreSQL database using the `sonar` user credentials.

---

![SonarQube Database Configuration](images/4.png)

### Step 30: Create SonarQube Service

To manage SonarQube as a systemd service, create a service file and configure it to start SonarQube.

1. **Create SonarQube Service File**:
    ```bash
    sudo vim /etc/systemd/system/sonar.service
    ```

2. **Add Service Configuration**:
    - Press `i` to enter insert mode.
    - Copy and paste the following configuration into the file:
        ```ini
        [Unit]
        Description=SonarQube service
        After=syslog.target network.target

        [Service]
        Type=forking

        ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
        ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

        User=sonar
        Group=sonar
        Restart=always

        LimitNOFILE=65536
        LimitNPROC=4096

        [Install]
        WantedBy=multi-user.target
        ```

3. **Save and Exit**:
    - Press `ESC` to exit insert mode.
    - Type `:wq` and press `Enter` to save changes and close the file.

The SonarQube service is now configured and ready to be started and managed through `systemd`.

---

### Step 31: Enable and Start SonarQube Service

To ensure SonarQube starts automatically when the machine reboots, enable the SonarQube service.

1. **Enable SonarQube Service on Startup**:
    ```bash
    sudo systemctl enable sonar
    ```

2. **Start SonarQube Service**:
    ```bash
    sudo systemctl start sonar
    ```

3. **Check SonarQube Service Status**:
    - Verify that SonarQube is running:
        ```bash
        sudo systemctl status sonar
        ```

With these settings, SonarQube will start automatically whenever the system boots.

---


### Step 32: Monitor SonarQube Logs and Access Web Interface

1. **Monitor SonarQube Logs**:
    - Use the following command to track SonarQube logs in real-time and ensure the service is running smoothly:
        ```bash
        sudo tail -f /opt/sonarqube/logs/sonar.log
        ```

2. **Access SonarQube Web Interface**:
    - Open a web browser and navigate to the SonarQube interface using the public IP of the `My-SonarQube` instance on port 9000:
        ```
        http://<My-SonarQube_Public_IP>:9000
        ```
    - Replace `<My-SonarQube_Public_IP>` with the actual public IP address of the instance.

3. **Login Credentials**:
    - Use the default SonarQube credentials to log in:
        - **Username**: `admin`
        - **Password**: `admin`

After logging in, you can configure SonarQube settings, create projects, and perform code quality analysis.

---
![SonarQube Project Creation](images/5_sonarqube.png)

### Step 33: Create SonarQube Token for Jenkins Integration

To allow Jenkins to connect with SonarQube for code analysis, create a token in SonarQube.

1. **Access SonarQube Security Settings**:
    - Open a web browser and navigate to the following URL, replacing `<MAKINENIN_PUBLIC_IP_DEGERI>` with the public IP address of your SonarQube instance:
        ```
        http://<MAKINENIN_PUBLIC_IP_DEGERI>:9000/account/security
        ```

2. **Generate a New Token**:
    - Under **Tokens**, create a new token:
        - **Name**: `jenkins-sonarqube-token`
    - After creation, you will receive a token string similar to `sqa_1234`.
    - **Copy this token** and keep it secure; you will need it to configure Jenkins.

3. **Add Token to Jenkins**:
    - In Jenkins, go to **Dashboard** > **Manage Jenkins** > **Manage Credentials**.
    - Choose the appropriate credentials domain (usually **Global**).
    - Add a new **Secret text** credential:
        - **Secret**: Paste the generated SonarQube token (`sqa_1234`).
        - **ID**: Optionally, give an ID such as `sonarqube-token`.
        - **Description**: Enter a description for easy reference.

With this token, Jenkins can securely connect to SonarQube to run code quality analysis during your pipelines.

---

### Step 34: Configure SonarQube Token in Jenkins and Install Plugins

To integrate SonarQube with Jenkins, save the SonarQube token in Jenkins and install the necessary plugins.

1. **Save SonarQube Token in Jenkins**:
   - In Jenkins, navigate to **Dashboard** > **Manage Jenkins** > **Manage Credentials**.
   - Choose the appropriate credentials domain (usually **Global**).
   - Click on **Add Credentials** and configure as follows:
      - **Kind**: Secret text
      - **Secret**: Paste the SonarQube token (`sqa_1234`)
      - **ID**: Enter an identifier such as `sonarqube-token`
      - **Description**: (Optional) Enter a description like "SonarQube Token for Jenkins Integration"

2. **Install Required Plugins**:
   - In Jenkins, go to **Dashboard** > **Manage Jenkins** > **Manage Plugins**.
   - Under the **Available** tab, search for the following plugins and install them:
      - **SonarQube Scanner**: Required for Jenkins to run SonarQube analysis.
      - **Pipeline**: Needed if not already installed for managing pipeline jobs.
   - Once plugins are selected, click **Install without restart** to install them immediately.

3. **Configure SonarQube Server in Jenkins**:
   - After plugins are installed, go to **Manage Jenkins** > **Configure System**.
   - Scroll down to the **SonarQube servers** section.
   - Click **Add SonarQube** and enter the following details:
      - **Name**: A descriptive name like `SonarQube-Server`.
      - **Server URL**: Use the private IP and port of the SonarQube server, for example:
        ```
        http://172.31.6.227:9000
        ```
      - **Server authentication token**: Select the token credential (`sonarqube-token`) saved earlier.

4. **Save Configuration**:
   - After completing the setup, click **Save** to store the SonarQube server configuration.

Jenkins is now configured to communicate with SonarQube using the token, enabling code quality analysis as part of your pipeline.

---

### Important: Update Jenkins System Configuration After Elastic IP Change

If the Elastic IP of the Jenkins Master or any integrated services (such as SonarQube) changes, remember to update the IP addresses in Jenkins system settings.

Failing to update the IP addresses can result in slow performance or connectivity issues.

1. **Update Jenkins System IP**:
   - Go to **Manage Jenkins** > **Configure System**.
   - Update any fields referencing the previous IP address with the new Elastic IP.
   - Specifically check the **Jenkins URL** and **SonarQube server** settings.

2. **Save Configuration**:
   - After updating the IP address, click **Save** to apply the changes.

This ensures that Jenkins and its integrations remain responsive and perform optimally.

---

### Step 35: Updated Jenkins Pipeline with SonarQube Analysis Stage

Below is the updated Jenkinsfile with an additional stage for SonarQube analysis, enabling code quality checks as part of the CI/CD pipeline.

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
                git branch: 'master', credentialsId: 'github', url: 'https://github.com/AbdullahSalihOner/DevOps-03-Pipeline-Aws'
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
        stage("SonarQube Analysis") {
           steps {
	           script {
		           withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                      sh "mvn sonar:sonar"
		           }
	           }
           }
       }

        /*
        stage('Docker Image') {
           steps {
               bat 'docker build -t asoner01/my-application:latest .'
           }
        }

        stage('Docker Image to DockerHub') {
            steps {
                script{
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
                          bat 'echo docker login -u asoner01 -p ${dockerhub}'
                          bat 'docker image push asoner01/my-application:latest'
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

![SonarQube CI/CD Integration Diagram](images/6_sonarqube_cicd.png)


![Jenkins Pipeline Complete](images/8_jenkins.png)

### Step 36: Create SonarQube Webhook for Jenkins Integration

To allow SonarQube to send notifications to Jenkins upon analysis completion, create a webhook in SonarQube.

1. **Access SonarQube Webhooks**:
   - In the SonarQube interface, go to **Administration** > **Configuration** > **Webhooks**.

2. **Create a New Webhook**:
   - Click on **Create**.
   - **Name**: Enter a descriptive name for the webhook, such as `Jenkins-SonarQube-Webhook`.
   - **URL**: Enter the URL pointing to the Jenkins server’s SonarQube webhook endpoint. Replace `172.31.0.209` with the private IP address of your Jenkins Master:
     ```
     http://172.31.0.209:8080/sonarqube-webhook
     ```
   - Click **Save** to create the webhook.

With this webhook, SonarQube will automatically notify Jenkins of analysis results, enabling Jenkins to respond to SonarQube events.

---

### Step 37: Create DockerHub Token and Add to Jenkins

To allow Jenkins to push Docker images to DockerHub securely, create a DockerHub token and save it as a credential in Jenkins.

1. **Create DockerHub Token**:
   - Log in to your DockerHub account and navigate to the **Account Settings** > **Security** > **Access Tokens**.
   - Create a new access token with a descriptive name, such as `MyDockerHubToken2024`.
   - Copy the generated token (e.g., `dckr_pat_1234`) and save it securely.

2. **Test DockerHub Login (Optional)**:
   - To confirm the token works, you can use the following command to log in to DockerHub:
     ```bash
     docker login -u asoner01 -p dckr_pat_1234
     ```
   - This command should authenticate successfully, confirming that the token is valid.

3. **Add DockerHub Token to Jenkins**:
   - In Jenkins, navigate to **Dashboard** > **Manage Jenkins** > **Manage Credentials**.
   - Select the appropriate credentials domain (usually **Global**).
   - Click on **Add Credentials** and fill in the following fields:
      - **Kind**: Secret text
      - **Secret**: Paste the DockerHub token (`dckr_pat_1234`).
      - **ID**: Enter an identifier such as `dockerhub-token`.
      - **Description**: (Optional) Enter a description like "DockerHub Token for Jenkins Push".
   - Click **OK** to save the credential.

With this token saved in Jenkins, the pipeline can securely authenticate with DockerHub to push images.

---

![Jenkins Pipeline Trivy Scan](images/7_trivy.png)

### Jenkins Pipeline Script (Jenkinsfile) with DockerHub and Trivy Integration

This Jenkinsfile defines a comprehensive CI/CD pipeline with environment variables for DockerHub integration, Trivy security scanning, and stages for workspace cleanup, code checkout, Maven build, testing, SonarQube code analysis, Docker image creation, and artifact cleanup.

```groovy
pipeline {
   agent {
      label 'My-Jenkins-Agent'
   }
   // agent any
   environment {
      APP_NAME = "devops-03-pipeline-aws"
      RELEASE = "1.0"
      DOCKER_USER = "asoner01"
      DOCKER_LOGIN = "dockerhub"
      IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
      IMAGE_TAG = "${RELEASE}.${BUILD_NUMBER}"
   }
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
            //   checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/AbdullahSalihOner/DevOps-03-Pipeline-Aws']])
            git branch: 'master', credentialsId: 'github', url: 'https://github.com/AbdullahSalihOner/DevOps-03-Pipeline-Aws'
         }
      }
      stage('Build Maven') {
         steps {
            //  sh 'mvn clean install'
            //  bat 'mvn clean install'
            sh 'mvn clean package'
            //  bat 'mvn clean package'
         }
      }
      stage('Test Application') {
         steps {
            sh 'mvn test'
            //  bat 'mvn test'
         }
      }
      stage("SonarQube Analysis") {
         steps {
            script {
               withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                  sh "mvn sonar:sonar"
               }
            }
         }
      }

      /*
            stage("Quality Gate"){
                steps {
                    script {
                         waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                     }
                 }
             }
     */

      stage('Build & Push Docker Image to DockerHub') {
         steps {
            script {
               docker.withRegistry('', DOCKER_LOGIN) {
                  docker_image = docker.build "${IMAGE_NAME}"
                  docker_image.push("${IMAGE_TAG}")
                  docker_image.push("latest")
               }
            }
         }
      }
      stage("Trivy Scan") {
         steps {
            script {
               sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image asoner01/devops-03-pipeline-aws:latest --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
            }
         }
      }
      stage ('Cleanup Artifacts') {
         steps {
            script {
               sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
               sh "docker rmi ${IMAGE_NAME}:latest"
            }
         }
      }

      /*
      stage('Deploy to Kubernetes'){
          steps{
              kubernetesDeploy (configs: 'deployment-service.yml', kubeconfigId: 'kubernetes')
          }
      }


     stage('Docker Image to Clean') {
         steps {
             //   sh 'docker rmi asoner01/my-application:latest'
             //  bat 'docker rmi asoner01/my-application:latest'

             // sh 'docker image prune -f'
              bat 'docker image prune -f'
         }
     }
*/
   }
}
```

### Step 38: Clean Up Disk Space on Jenkins Agent

As the Jenkins Agent machine runs more jobs, Docker images, containers, and volumes may accumulate, consuming disk space. Use the following commands to clean up and free space on the Agent machine.

1. **Remove Docker Images**:
   - To delete all images related to the `devops-003-pipeline-aws` project, use:
     ```bash
     docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'devops-003-pipeline-aws')
     ```

2. **Remove All Docker Containers**:
   - To remove all stopped containers, run:
     ```bash
     docker container rm -f $(docker container ls -aq)
     ```

3. **Prune Docker Volumes**:
   - To remove all unused Docker volumes, use:
     ```bash
     docker volume prune
     ```

Running these commands periodically helps prevent disk space issues and ensures that the Jenkins Agent remains operational.

---

### Step 39: Create and Connect to My-EKS-Bootstrap-Server

To prepare for setting up Amazon EKS (Elastic Kubernetes Service), create an EC2 instance designated as the EKS bootstrap server.

1. **Launch EC2 Instance**:
   - **Instance Name**: `My-EKS-Bootstrap-Server`
   - **Instance Type**: Select an appropriate type based on your workload requirements.
   - **AMI**: Choose an Amazon Machine Image (e.g., Ubuntu or Amazon Linux) compatible with EKS setup tools.
   - **Security Group**: Ensure the security group allows SSH (port 22) for remote access.
   - **Key Pair**: Use or create a key pair for accessing the instance.

2. **Connect to the EKS Bootstrap Server**:
   - Use MobaXterm or an SSH client to connect to the instance.
   - In MobaXterm, configure the session:
      - **Host**: Public IP or DNS of `My-EKS-Bootstrap-Server`.
      - **Username**: `ubuntu` (for Ubuntu AMI) or `ec2-user` (for Amazon Linux).
      - Name the session as **My-EKS-Bootstrap-Server** for easy identification.

The EKS Bootstrap Server is now set up and ready for further configurations for Amazon EKS setup.

---

### Step 40: Configure My-EKS-Bootstrap-Server

1. **Update and Upgrade Packages**: After connecting to the `My-EKS-Bootstrap-Server` instance, update and upgrade system packages.
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
       My-EKS-Bootstrap-Server
       ```
   - Save and exit:
      - Press `Ctrl + X` to exit.
      - Press `Y` to confirm.
      - Press `Enter` to finalize.

3. **Restart the Instance**: Restart the instance to apply the new hostname.
    ```bash
    sudo init 6
    # or
    sudo reboot
    ```

After restarting, reconnect to the instance. The hostname should now be updated to `My-EKS-Bootstrap-Server`.

---

### Step 41: Install AWS CLI on My-EKS-Bootstrap-Server

To interact with AWS services from the EKS Bootstrap Server, install the AWS CLI.

1. **Switch to Root User**:
    ```bash
    sudo su
    ```

2. **Navigate to Home Directory**:
    ```bash
    pwd
    ```

3. **Download AWS CLI**:
   - Use `curl` to download the AWS CLI installer:
       ```bash
       curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
       ```

4. **Install Unzip Utility**:
   - If `unzip` is not already installed, install it:
       ```bash
       apt install unzip
       ```

5. **Extract AWS CLI Installer**:
    ```bash
    unzip awscliv2.zip
    ```

6. **Run AWS CLI Installer**:
   - Install the AWS CLI by running the following command:
       ```bash
       sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
       ```

The AWS CLI is now installed on the `My-EKS-Bootstrap-Server` and ready for use.

---

### Step 42: Install Kubectl on My-EKS-Bootstrap-Server

Kubectl is the command-line tool for managing Kubernetes clusters, and it’s essential for working with Amazon EKS.

1. **Switch to Root User**:
    ```bash
    sudo su
    ```

2. **Navigate to Home Directory**:
    ```bash
    pwd
    ```

3. **Download Kubectl**:
   - Use `curl` to download the specific version of `kubectl`:
       ```bash
       curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.4/2024-09-11/bin/linux/amd64/kubectl
       ```

4. **Make Kubectl Executable**:
   - Update permissions to make `kubectl` executable:
       ```bash
       chmod +x ./kubectl
       ```

5. **Move Kubectl to System Path**:
   - Move `kubectl` to `/bin` so it’s accessible from anywhere:
       ```bash
       mv kubectl /bin
       ```

6. **Update PATH Variable**:
   - Ensure the `kubectl` path is correctly set:
       ```bash
       export PATH=$HOME/bin:$PATH
       ```

7. **Verify Kubectl Installation**:
   - Confirm the installation and check the version:
       ```bash
       kubectl version --output=yaml
       ```

Kubectl is now installed and ready for managing Kubernetes clusters on the `My-EKS-Bootstrap-Server`.

---

### Step 43: Install eksctl on My-EKS-Bootstrap-Server

Eksctl is a command-line tool for managing Amazon EKS clusters, making it easier to create and manage Kubernetes clusters on AWS.

1. **Switch to Root User**:
    ```bash
    sudo su
    ```

2. **Navigate to Home Directory**:
    ```bash
    pwd
    ```

3. **Download and Extract eksctl**:
   - Use `curl` to download the latest release of `eksctl` and extract it to the `/tmp` directory:
       ```bash
       curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
       ```

4. **Move eksctl to System Path**:
   - Change to the `/tmp` directory and verify `eksctl` has been downloaded:
       ```bash
       cd /tmp
       ll
       ```
   - Move `eksctl` to `/bin` so it’s accessible from anywhere:
       ```bash
       sudo mv /tmp/eksctl /bin
       ```

5. **Verify eksctl Installation**:
   - Confirm the installation and check the version:
       ```bash
       eksctl version
       ```

6. **Reboot the Instance**:
   - Restart the instance to ensure all PATH settings are applied correctly:
       ```bash
       sudo reboot
       ```

7. **Verify Kubectl After Reboot**:
   - Once the server reboots, verify that `kubectl` is accessible:
       ```bash
       kubectl version --client
       ```

Eksctl is now installed and ready for creating and managing Amazon EKS clusters on the `My-EKS-Bootstrap-Server`.

---

### Step 44: Assign eksctl_ROLE to My-EKS-Bootstrap-Server in AWS

To grant the necessary permissions for managing EKS clusters, assign the **eksctl_ROLE** IAM role to the `My-EKS-Bootstrap-Server` instance.

1. **Assign eksctl_ROLE in AWS Console**:
   - Go to the **AWS Management Console** > **EC2 Dashboard**.
   - Select the `My-EKS-Bootstrap-Server` instance.
   - Under the **Actions** dropdown, select **Security** > **Modify IAM Role**.
   - Choose the **eksctl_ROLE** IAM role from the list and click **Update IAM Role**.

2. **Verify Role Assignment**:
   - Once assigned, the `My-EKS-Bootstrap-Server` will have the permissions specified in the **eksctl_ROLE** policy, which should include permissions to create and manage EKS clusters.

With **eksctl_ROLE** assigned, the EKS Bootstrap Server can now interact with AWS services required for EKS cluster management.

---



### Step 45: Create an EKS Cluster with 3 Nodes

Use `eksctl` to create an Amazon EKS cluster with 3 nodes on the `My-EKS-Bootstrap-Server`.

1. **Create EKS Cluster**:
   - Run the following `eksctl` command to create an EKS cluster named `my-workspace3-cluster` with 3 nodes of type `t2.large` in the `us-east-1` region:
       ```bash
       eksctl create cluster --name my-workspace3-cluster \
       --region us-east-1 \
       --node-type t2.large \
       --nodes 3
       ```

2. **Wait for Cluster Creation**:
   - The cluster creation process may take several minutes. Eksctl will provision the EKS control plane and set up 3 worker nodes for the cluster.

3. **Verify Cluster Setup**:
   - Once the cluster is created, use `kubectl` to verify connectivity:
       ```bash
       kubectl get nodes
       ```

The EKS cluster named `my-workspace3-cluster` with 3 nodes is now ready for deploying applications.

---

### Step 46: Verify EKS Cluster Nodes and Pods

After creating the EKS cluster, use the following `kubectl` commands to verify the status of nodes and pods.

1. **Get Nodes**:
   - To see the list of nodes in the EKS cluster, use:
     ```bash
     kubectl get nodes
     ```

2. **Get Pods**:
   - To check the status of pods within the default namespace, you can use any of the following commands:
     ```bash
     kubectl get pods
     ```
     or
     ```bash
     kubectl get pod
     ```
     or
     ```bash
     kubectl get po
     ```

These commands will help verify that the nodes are active and ready, and display any running pods in the EKS cluster.

---


### Step 47: Install ArgoCD on EKS Cluster

ArgoCD is a declarative GitOps continuous delivery tool for Kubernetes. Follow these steps to install ArgoCD on your EKS cluster.

1. **Create ArgoCD Namespace**:
   - To isolate ArgoCD resources, create a dedicated namespace:
     ```bash
     kubectl create namespace argocd
     ```

2. **Install ArgoCD**:
   - Apply the ArgoCD installation manifest to install ArgoCD components in the `argocd` namespace:
     ```bash
     kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
     ```

3. **Verify ArgoCD Installation**:
   - Check the status of ArgoCD pods to confirm they are running:
     ```bash
     kubectl get pods -n argocd
     ```

ArgoCD is now installed in the `argocd` namespace on the EKS cluster. You can use it to manage application deployments in a GitOps workflow.

---

### Step 48: Install ArgoCD CLI on My-EKS-Bootstrap-Server

The ArgoCD CLI tool allows you to interact with the ArgoCD server directly from the command line, facilitating application management on Kubernetes.

1. **Switch to Root User**:
    ```bash
    sudo su
    ```

2. **Navigate to Home Directory**:
    ```bash
    pwd
    ```

3. **Retrieve the Latest ArgoCD Version**:
   - You can retrieve the latest ArgoCD version and install it with the following commands:
       ```bash
       curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION
       VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
       curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64
       ```

4. **Alternatively, Install a Specific Version**:
   - If you prefer to install a specific version, use the following command (replace with the desired version):
       ```bash
       curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.12.3/argocd-linux-amd64
       ```

5. **Make the ArgoCD CLI Executable**:
   - Update permissions to make the `argocd` CLI executable:
       ```bash
       chmod +x /usr/local/bin/argocd
       ```

6. **Verify Installation**:
   - Confirm the installation by checking the version:
       ```bash
       argocd version
       ```

The ArgoCD CLI is now installed on the `My-EKS-Bootstrap-Server`, ready to manage applications in ArgoCD.

---

### Step 49: Expose ArgoCD to External Access and Retrieve Admin Password

To access ArgoCD from an external IP, expose the ArgoCD server using a LoadBalancer service type and retrieve the admin password for login.

1. **Switch to Normal User Mode**:
   - If currently in root mode, exit back to the normal user:
       ```bash
       exit
       ```
   - Alternatively, use `Ctrl + C`.

2. **Expose ArgoCD Server**:
   - Change the ArgoCD server service type to `LoadBalancer` to make it accessible from outside the cluster:
       ```bash
       kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
       ```

3. **Get External Address**:
   - Retrieve the external address created by the LoadBalancer:
       ```bash
       kubectl get svc -n argocd
       ```
   - The external address should appear under the `EXTERNAL-IP` or `ADDRESS` column, similar to:
     ```
     a5b3d196d6343444dbd692184429ca6b-117814533.us-east-1.elb.amazonaws.com
     ```

4. **Retrieve ArgoCD Admin Password**:
   - Use the following command to get the initial admin password for ArgoCD:
       ```bash
       kubectl get secret argocd-initial-admin-secret -n argocd -o yaml
       ```
   - Copy the encoded password and decode it using:
       ```bash
       echo dEJXSzJuVktYY2IxVVpaYw== | base64 --decode
       ```
   - This should output the admin password, for example:
     ```
     tBWK2nVKXcb1UZZc
     ```

5. **Login to ArgoCD and Update Password**:
   - Open a web browser and go to the external ArgoCD address:
     ```
     http://a4acf523475ea4b89ad2c07714c0e6ff-1045934813.us-east-1.elb.amazonaws.com
     ```
   - Login with:
      - **Username**: `admin`
      - **Password**: `tBWK2nVKXcb1UZZc` (or the decoded password you retrieved)
   - Once logged in, navigate to the **User Info** menu to update the default password.

ArgoCD is now accessible externally, and the admin password has been updated for security.

---

### Step 50: Use ArgoCD from the Terminal and Add Kubernetes Cluster

To interact with ArgoCD via the terminal, login to the ArgoCD server and register your Kubernetes cluster.

1. **Login to ArgoCD via CLI**:
   - Use the ArgoCD CLI to login to the ArgoCD server. Replace the external LoadBalancer address with your own:
     ```bash
     argocd login a5b3d196d6343444dbd692184429ca6b-117814533.us-east-1.elb.amazonaws.com --username admin
     ```
   - Enter the password when prompted (use the admin password retrieved earlier).

2. **List Connected Clusters**:
   - View the list of clusters currently connected to ArgoCD:
     ```bash
     argocd cluster list
     ```

3. **Retrieve Current Kubernetes Cluster Name**:
   - To get the name of the Kubernetes cluster currently in use:
     ```bash
     kubectl config get-contexts
     ```

4. **Add Kubernetes Cluster to ArgoCD**:
   - Register the Kubernetes cluster with ArgoCD using the cluster name retrieved in the previous step. Replace the name if necessary:
     ```bash
     argocd cluster add i-019044c0a004f6c9f@my-workspace3-cluster.us-east-1.eksctl.io --name my-workspace3-cluster
     ```

5. **Verify Services**:
   - Confirm that ArgoCD is connected and view available services:
     ```bash
     kubectl get svc
     ```

These steps allow you to manage the Kubernetes cluster directly from ArgoCD, integrating GitOps workflows for streamlined application deployment.

---

![ArgoCD Application Status](images/9_argo.png)

### Step 51: Clean Up Docker on Agent Machine and Delete EKS Cluster

To maintain disk space on the Jenkins Agent and remove unused resources, regularly perform Docker cleanup. Additionally, delete the EKS cluster when it's no longer needed.

#### Docker Cleanup on Jenkins Agent

As Docker images, containers, and volumes accumulate on the Agent machine, they consume disk space. Use the following commands to free up space:

1. **Remove Docker Images**:
   - Delete images related to the project `devops-003-pipeline-aws`:
     ```bash
     docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'devops-003-pipeline-aws')
     ```

2. **Remove All Docker Containers**:
   - Forcefully remove all stopped containers:
     ```bash
     docker container rm -f $(docker container ls -aq)
     ```

3. **Prune Docker Volumes**:
   - Remove all unused Docker volumes to free up space:
     ```bash
     docker volume prune
     ```

#### Deleting EKS Cluster and Associated Resources

If the EKS cluster is no longer required, follow these steps to delete it and all related services.

1. **Check eksctl Version**:
   - Ensure `eksctl` is installed and up to date:
     ```bash
     eksctl version
     ```

2. **List All Running Services**:
   - Before deleting, view all services running across namespaces:
     ```bash
     kubectl get svc --all-namespaces
     ```

3. **View Cluster Details**:
   - To confirm cluster details, use:
     ```bash
     kubectl config view
     ```

4. **Set AWS Region**:
   - Set the AWS region if necessary:
     ```bash
     export AWS_DEFAULT_REGION=us-east-1
     ```

5. **Delete the EKS Cluster**:
   - Use `eksctl` to delete the entire cluster by name. This removes nodes, services, and all associated resources:
     ```bash
     eksctl delete cluster --name my-workspace3-cluster
     ```

These steps help manage disk space on the Agent machine and decommission the EKS cluster when it is no longer in use.

---


