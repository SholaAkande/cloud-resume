# ☁️ AWS Cloud Resume Challenge (UK Edition)

A full-stack, serverless resume website built on AWS, featuring a live visitor counter. This project demonstrates proficiency in cloud architecture, infrastructure as code (GitHub Actions), and serverless backend development.

## 🚀 Live Demo
[View my Live Resume here!](https://dox67qshzudv7.cloudfront.net/)

## 🏗️ Architecture Overview

![Image](https://github.com/user-attachments/assets/5ccbe64c-7f6a-467b-b361-7ccea4c992ba)

The project is hosted entirely on AWS using a serverless approach to ensure high availability, scalability, and cost-efficiency.

- **Frontend:** HTML5, CSS3 (Responsive Design), and JavaScript.
- **Hosting:** **Amazon S3** (Static Website Hosting).
- **Content Delivery:** **Amazon CloudFront** for global distribution and SSL/TLS termination.
- **Backend:** **AWS Lambda** (Python) triggered via Function URL.
- **Database:** **Amazon DynamoDB** to store and increment the visitor count.
- **CI/CD:** **GitHub Actions** for automated deployment to S3.



## 🛠️ Features & Implementation

### 1. The "London" Migration (Region Isolation)
Originally prototyped in `us-east-1`, the entire stack was successfully migrated to the **London (`eu-west-2`)** region to optimize latency for UK-based users. This involved re-configuring IAM Policies, DynamoDB ARNs, and Lambda triggers.

### 2. Visitor Counter Logic
I developed a Python-based Lambda function that performs an atomic update on a DynamoDB table. It increments the `views` count and returns a JSON response to the frontend, handling **CORS** (Cross-Origin Resource Sharing) to allow secure communication between the CloudFront domain and the Lambda URL.

### 3. Automated Deployment (DevOps)
I implemented a CI/CD pipeline using **GitHub Actions**. Every time I push code to this repository, the workflow automatically:
- Syncs the updated frontend files to the **S3 Bucket**.
- (Optional) Invalidates the **CloudFront Cache** to ensure the latest version is live instantly.

## 📖 Key Learnings
- **Infrastructure Troubleshooting:** Debugged `Internal Server Errors` by analyzing **CloudWatch Logs** and fixing IAM Permission mismatches.
- **Networking & DNS:** Configured **Route 53** Alias records and **ACM (AWS Certificate Manager)** for custom domain mapping (Theory/Practical).
- **Responsive Design:** Used CSS Media Queries to ensure a "cinematic" experience on Desktop and a clean, readable layout on Mobile.

## 🧑‍💻 Author
**Ishola Akande**
*Cloud Engineer in Training*


---
**Note:** For a detailed log of all technical challenges and solutions encountered during this build, see [troubleshooting.md](./troubleshooting.md).
