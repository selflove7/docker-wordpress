<h1> Terraform and Docker for WordPress Deployment on AWS with RDS </h1>


<p> The goal of this project is to deploy a WordPress application on AWS using Terraform for infrastructure provisioning and Docker for containerization. This project contains the following steps: </p>

    1) Provisioning a virtual machine (VM) in a public subnet using Terraform.
   
    2) Creating a Dockerfile to build a custom Docker image with Apache web server, PHP, and WordPress.
   
    3) Building the Docker image, tagging it, and pushing it to Docker Hub.
   
    4) Running the Docker container on the VM to host the WordPress application.

    5) Deploying a relational database service (RDS) on AWS in a private subnet.

    6) Configuring the WordPress container to connect to the RDS database for data storage.


The project demonstrates the use of infrastructure-as-code (IaC) principles with Terraform, containerization with Docker, and the integration of WordPress with a managed database service. It enables easy deployment of a scalable and manageable WordPress application on a cloud platform.


<h2> Prerequisites for this project: </h2>

<b> 1) Cloud Provider Account:</b> You will need an AWS account to provision the Virtual Server and RDS resources. Make sure you have access to the necessary credentials (access key, secret key, subscription ID, etc.) to authenticate with the cloud provider.

<b> 2) Terraform Installed:</b> Install Terraform on your local machine. You can download the appropriate version for your operating system from the official Terraform website (https://www.terraform.io/downloads.html). Ensure that Terraform is properly installed and configured in your system's PATH.

<b> 3) Docker Installed:</b> Install Docker on your local machine to build and run the Docker image. Docker provides platform-independent containerization capabilities. You can download Docker from the official Docker website (https://www.docker.com/get-started).

<b> 4) GitHub Account:</b> Create a GitHub account if you don't have one. GitHub will be used to store and version control your project code.

<b> 5) Docker Hub Account:</b> Create an account on Docker Hub (https://hub.docker.com) to push and store your Docker image. Docker Hub is a central repository for Docker images.

<b> 6) Basic Knowledge:</b> Familiarize yourself with basic concepts related to virtual machines, networking, Docker, and relational databases. Understanding these concepts will help you navigate through the project and troubleshoot any issues that may arise.



By having these prerequisites in place, you'll be well-equipped to proceed with the project and successfully deploy WordPress on AWS/Azure with Terraform, Docker, and RDS.


<h2> Step 1: Create a Terraform script to deploy a VM. The VM should be in public subnet. </h2>

The Terraform script <b>(main.tf)</b> for deploying the VM in the public subnet can be found in the GitHub repository.

<b> Clone the repository to your local machine: </b>

            git clone https://github.com/selflove7/docker-wordpress.git

<b> Navigate to the project directory: </b>

            cd docker-wordpress

<b> Initialize the Terraform project:</b>

            terraform init
             
   ![Screenshot_597](https://github.com/selflove7/docker-wordpress/assets/115529646/c7cfebde-5b4d-40bc-b8c1-1cf70b089293)
      
<b> Validate the Terraform configuration:</b>

            terraform validate
              
![Screenshot_598](https://github.com/selflove7/docker-wordpress/assets/115529646/9703c0b5-7c09-4c80-a228-7737cbd95014)

<b> Generate an execution plan:</b>

            terraform plan
            
 ![Screenshot_599](https://github.com/selflove7/docker-wordpress/assets/115529646/972b5e1b-2538-429a-9b2d-1a553499554b)
 
<b> Apply the Terraform configuration to create the VM:</b>

            terraform apply
            
![Screenshot_600](https://github.com/selflove7/docker-wordpress/assets/115529646/40bdf6d5-8681-40c3-b059-69dd63f64db9)

Confirm the changes by entering <b> "yes"</b>  when prompted.

Once the VM is provisioned, access the public IP/DNS to verify its availability.

<b> To destroy the infrastructure and clean up resources:</b>

            terraform destroy
            
Confirm the destruction by entering <b> "yes" </b> when prompted.

<h3> OUTPUT </h3>

![Screenshot_601](https://github.com/selflove7/docker-wordpress/assets/115529646/290b4614-0b97-467d-829c-321b08fa0d91)

![Screenshot_602](https://github.com/selflove7/docker-wordpress/assets/115529646/277cab30-b04a-4a3f-bf22-4553002fa01d)

![Screenshot_604](https://github.com/selflove7/docker-wordpress/assets/115529646/4b6e9ff2-4152-479f-a88f-2cc4082f5de2)

![Screenshot_603](https://github.com/selflove7/docker-wordpress/assets/115529646/f67396a3-2313-4d4a-a7a3-8960ee4b8cb3)


<h2> Step 2: To create a Dockerfile for deploying Apache webserver, PHP, and WordPress: </h2>

Create a new file in your project directory and name it <b> Dockerfile </b> (without any file extension).

Open the Dockerfile using a text editor.

In the Dockerfile, you will define the steps to build your Docker image. Here's a Dockerfile for deploying Apache webserver, PHP, and WordPress

                FROM ubuntu

                ARG WORDPRESS_VERSION=latest

                # Set environment variables to avoid interactive prompts
                ENV DEBIAN_FRONTEND=noninteractive
                ENV DEBIAN_PRIORITY=critical

                # Install Apache, PHP, and other dependencies
                RUN apt-get update && \
                    apt-get install -y apache2 php libapache2-mod-php php-mysql wget && \
                    apt-get clean && \
                    rm -rf /var/lib/apt/lists/*

                # Download and extract WordPress files
                RUN wget -O wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
                    tar -xvf wordpress.tar.gz -C /var/www/html/ && \
                    rm wordpress.tar.gz

                # Add the ServerName directive to the Apache configuration
                RUN echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf

                # Set the working directory
                WORKDIR /var/www/html/wordpress

                # Create the uploads directory and set ownership and permissions
                RUN mkdir -p /var/www/html/wordpress/wp-content/uploads && \
                    chown -R www-data:www-data /var/www/html/wordpress && \
                    chmod -R 755 /var/www/html/wordpress && \
                    chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads

                # Expose port 80
                EXPOSE 80
                EXPOSE 443

                # Start Apache in the foreground
                CMD ["apache2ctl", "-D", "FOREGROUND"]


You can customize the Dockerfile further based on your specific requirements.


<h2> Step 3. Build the Docker image, Tag the image and Push the Docker image to Docker Hub and Run the container </h2>

<b> Build the Docker image </b>

        docker build -t my-wordpress .
        
 ![Screenshot_605](https://github.com/selflove7/docker-wordpress/assets/115529646/0a77fbd5-c486-4bfa-972c-e477855b6eaf)
   
<b> Log in to Docker Hub & Enter your Docker Hub credentials when prompted. </b>
    
        docker login

<b> Tag the imageTag the image </b> 
    
        docker tag my-wordpress:latest 91469/my-wordpress:v1.0.0
        
<b> Push the Docker image to Docker Hub </b> 
        
        docker push 91469/my-wordpress:v1.0.0
        
![Screenshot_607](https://github.com/selflove7/docker-wordpress/assets/115529646/ae9917de-8ad5-4e03-b0b7-3840ca3707d4)

![Screenshot_608](https://github.com/selflove7/docker-wordpress/assets/115529646/5afa35f9-d20f-4a5a-99a9-c6e306c84495)

![Screenshot_609](https://github.com/selflove7/docker-wordpress/assets/115529646/933e08c3-7956-48e7-b492-4c4ad0d115c4)

<b> Run the container </b> 
    
    docker run -d -p 80:80 -p 443:443 --name my-wordpress-container my-wordpress
    
 ![Screenshot_610](https://github.com/selflove7/docker-wordpress/assets/115529646/2e6d4226-e286-46e4-9d89-3040ca066e18)


<h2> Step 4: Deploy the RDS on AWS in a private subnet </h2>

In this step, we will deploy a relational database service (RDS) on AWS in a private subnet to ensure enhanced security and isolation.

                1. Open the AWS Management Console and navigate to the RDS service.
                
                2. Click on  "Create database"  to start the RDS creation process.
                
                3. Select the desired database engine (e.g., MySQL, PostgreSQL, etc.) and specify the required configurations such as DB instance class, storage, and master username/password.
                
                4. Choose the appropriate VPC and subnet for the RDS deployment. Select a private subnet to ensure it's not publicly accessible.
                
                5. Configure the database security group to allow inbound connections from the Docker container hosting the WordPress application. You may need to open the respective database port (e.g., port 3306 for MySQL) in the security group settings.
                
                6. Proceed with the remaining RDS configuration options as per your project requirements.
                
                7. Review the settings and click on  "Create database" to initiate the RDS deployment process.

![Screenshot_611](https://github.com/selflove7/docker-wordpress/assets/115529646/341926b1-964f-4d27-9c74-0e923b71bdf5)

![Screenshot_612](https://github.com/selflove7/docker-wordpress/assets/115529646/fb5b4d8a-21e5-452e-9eef-4678e7daafc1)

![Screenshot_614](https://github.com/selflove7/docker-wordpress/assets/115529646/19deb748-9699-4c05-9ceb-79ba0f99f8dd)

![Screenshot_625](https://github.com/selflove7/docker-wordpress/assets/115529646/045ae59b-0dfe-44ae-a912-f5057d598ee3)


Make sure to note down the RDS connection details, such as the <b> endpoint URL, port, database name, master username, and password, </b> as you will need these details to establish the connection between the WordPress container and the RDS database in the next step.


<h2> Step 5:  To connect WordPress container with the RDS database </h2>

Access the WordPress application through its public IP or DNS.

Perform necessary WordPress setup steps (e.g., providing website information, creating an admin account).

During the setup, WordPress will attempt to establish a connection with the RDS database using the provided connection details. Make sure the connection is successful.


![Screenshot_616](https://github.com/selflove7/docker-wordpress/assets/115529646/48e8f880-1d12-4e00-875c-620bf6c70641)

![Screenshot_617](https://github.com/selflove7/docker-wordpress/assets/115529646/42e438b4-23ad-45f0-a47b-3801e1b74000)

![Screenshot_618](https://github.com/selflove7/docker-wordpress/assets/115529646/1f2da54d-ee07-4d4c-96b7-8b8425708a22)

![Screenshot_619](https://github.com/selflove7/docker-wordpress/assets/115529646/bcb35b9c-e431-4abb-9ea1-85005361f1fc)

![Screenshot_620](https://github.com/selflove7/docker-wordpress/assets/115529646/eca0f43e-13dd-4f4f-b084-59b2dc8b2e77)

![Screenshot_621](https://github.com/selflove7/docker-wordpress/assets/115529646/4c182e82-1c9f-4f40-8e26-0a0ccac7204a)

![Screenshot_622](https://github.com/selflove7/docker-wordpress/assets/115529646/c794a8b0-155b-4ea4-8b10-69492d6495d0)

![Screenshot_623](https://github.com/selflove7/docker-wordpress/assets/115529646/dcf22826-f7cf-47e2-af08-38e14ec294ef)



<b> Official Documentation for References: </b>

For further information and detailed documentation, you can refer to the following official resources:

Terraform Documentation: https://www.terraform.io/docs/index.html

This documentation provides comprehensive information about Terraform, including installation instructions, configuration syntax, available resources, and provider-specific details.
Docker Documentation: https://docs.docker.com/

The official Docker documentation covers various topics related to Docker, including Dockerfile syntax, container management, networking, and best practices.
AWS Documentation: https://docs.aws.amazon.com/index.html

The official AWS documentation provides detailed information about the AWS services, including EC2, RDS, VPC, security groups, and more. It offers step-by-step guides, API references, and best practices.

    

