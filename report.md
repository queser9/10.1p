# Project Report

## Project Overview

The objective of this project is to demonstrate the implementation of monitoring and visibility for a cloud-native application using Google Cloud Platform (GCP) tools. We containerized a simple Node.js application using Docker and Kubernetes, and deployed it to a GCP Kubernetes cluster. We then applied monitoring and visibility tools to collect and analyze metrics and logs from both the application and the Kubernetes cluster.

## Steps to Containerize the Application

1. **Write Node.js Application Code:**
   - Create a simple Node.js application that provides basic API endpoints.
   - Example code in `index.js`.

2. **Create Dockerfile:**
   - Write a Dockerfile to build the Docker image for the application.
   - Example Dockerfile:
     ```dockerfile
     FROM node:14

     WORKDIR /usr/src/app

     COPY package*.json ./

     RUN npm install

     COPY . .

     EXPOSE 3000

     CMD ["npm", "start"]
     ```

3. **Build Docker Image:**
   - Build the Docker image on your local machine.
   - Command:
     ```bash
     docker build -t your-dockerhub-username/calculator-app:latest .
     ```

4. **Push Image to Docker Hub:**
   - Push the built Docker image to Docker Hub.
   - Command:
     ```bash
     docker push your-dockerhub-username/calculator-app:latest
     ```

## Kubernetes Deployment Steps

1. **Create Kubernetes Manifest Files:**
   - Write Kubernetes manifest files for deploying the application and MongoDB.

2. **Application Deployment Manifest:**
   - `app-deployment.yaml`:
     ```yaml
     apiVersion: apps/v1
     kind: Deployment
     metadata:
       name: my-node-app
     spec:
       replicas: 3
       selector:
         matchLabels:
           app: my-node-app
       template:
         metadata:
           labels:
             app: my-node-app
         spec:
           containers:
           - name: my-node-app
             image: your-dockerhub-username/calculator-app:latest
             env:
             - name: MONGO_URI
               value: "mongodb://mongodb:27017"
             ports:
             - containerPort: 3000
     ```

   - `service.yaml`:
     ```yaml
     apiVersion: v1
     kind: Service
     metadata:
       name: my-node-app
     spec:
       selector:
         app: my-node-app
       ports:
         - protocol: TCP
           port: 80
           targetPort: 3000
           nodePort: 30000
       type: NodePort
     ```

   - `mongodb-deployment.yaml`:
     ```yaml
     apiVersion: apps/v1
     kind: Deployment
     metadata:
       name: mongodb
     spec:
       replicas: 1
       selector:
         matchLabels:
           app: mongodb
       template:
         metadata:
           labels:
             app: mongodb
         spec:
           containers:
           - name: mongodb
             image: mongo:4.2
             ports:
             - containerPort: 27017
     ```

   - `mongodb-service.yaml`:
     ```yaml
     apiVersion: v1
     kind: Service
     metadata:
       name: mongodb
     spec:
       selector:
         app: mongodb
       ports:
         - protocol: TCP
           port: 27017
           targetPort: 27017
     ```

3. **Deploy to Kubernetes Cluster:**
   - Apply the manifest files to the Kubernetes cluster using `kubectl apply` command.
   - Commands:
     ```bash
     kubectl apply -f app-deployment.yaml
     kubectl apply -f service.yaml
     kubectl apply -f mongodb-deployment.yaml
     kubectl apply -f mongodb-service.yaml
     ```

## Monitoring and Logging Configuration Steps

1. **Configure Cloud Monitoring:**
   - Create a monitoring dashboard and add key metrics such as CPU usage, memory usage, and network traffic.
   - Example steps:
     - Log in to the GCP console and navigate to Cloud Monitoring.
     - Create a new monitoring dashboard.
     - Add line charts and select appropriate metrics (e.g., `kubernetes.io/container/cpu/usage_time`, `kubernetes.io/container/memory/used_bytes`).

2. **Configure Cloud Logging:**
   - Use Logs Explorer to view and analyze logs.
   - Example steps:
     - Log in to the GCP console and navigate to Logs Explorer.
     - Select the resource type (e.g., `Kubernetes Container`) and set filters to view relevant logs.

## Challenges Encountered and Solutions

1. **Docker Image Build Issues:**
   - **Problem:** Some dependencies failed to download during the Docker image build.
   - **Solution:** Check network connection and add retry logic in the Dockerfile.

2. **Kubernetes Service Exposure Issues:**
   - **Problem:** The application service was not accessible via external IP.
   - **Solution:** Use the appropriate service type (e.g., NodePort) and ensure firewall rules allow the required ports.

3. **Monitoring Metrics Not Displaying:**
   - **Problem:** Some key metrics were not found in Cloud Monitoring.
   - **Solution:** Check application and Kubernetes configurations to ensure monitoring agents are enabled and metrics are correctly exported.

4. **High Log Volume Causing Analysis Difficulties:**
   - **Problem:** High volume of log entries caused Logs Explorer to respond slowly.
   - **Solution:** Set appropriate filters, narrow down the time range, and focus on key log entries.

By following these steps, the project was successfully completed, demonstrating the ability to implement monitoring and visibility for a cloud-native application on GCP.
