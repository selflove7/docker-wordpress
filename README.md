<h1> Terraform and Docker for WordPress Deployment on AWS with RDS </h1>


<p> The goal of this project is to deploy a WordPress application on AWS using Terraform for infrastructure provisioning and Docker for containerization. The project includes the following steps: </p>

    1) Provisioning a virtual machine (VM) in a public subnet using Terraform.
   
    2) Creating a Dockerfile to build a custom Docker image with Apache web server, PHP, and WordPress.
   
    3) Building the Docker image, tagging it, and pushing it to Docker Hub.
   
    4) Running the Docker container on the VM to host the WordPress application.

    5) Deploying a managed relational database service (RDS) on AWS/Azure in a private subnet.

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


    

