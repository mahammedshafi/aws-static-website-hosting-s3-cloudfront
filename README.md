# 🚀 AWS Static Website Hosting using S3 & CloudFront (Production-Style)

## 📌 Project Overview

This project demonstrates hosting a static website on AWS using S3 and CloudFront with secure and scalable architecture.

👉 This simulates a real-world cloud deployment used in production environments.

---

## 🔄 Architecture Flow

User → CloudFront (CDN) → S3 Bucket → Static Website

---

## 🛠 Tools & Technologies

* AWS S3 (Static Website Hosting)
* AWS CloudFront (Content Delivery Network)
* AWS IAM (Access Control & Security)
* HTML, CSS, JavaScript (Frontend)

---

## 📁 Project Structure

index.html → Main webpage
css/ → Styling files
img/ → Images
vendor/ → Libraries

---

## ⚙️ Step-by-Step Implementation

### 🔹 Step 1: Create S3 Bucket

* Go to AWS S3
* Create bucket with unique name
* Disable "Block all public access"

---

### 🔹 Step 2: Upload Website Files

* Upload index.html, CSS, JS, images

---

### 🔹 Step 3: Enable Static Website Hosting

* Enable “Static Website Hosting”
* Set index document: index.html

---

### 🔹 Step 4: Configure Bucket Policy

Allow public access using bucket policy

---

### 🔹 Step 5: Create CloudFront Distribution

* Select S3 website endpoint
* Enable CDN for faster delivery

---

### 🔹 Step 6: Access Website

* Use CloudFront domain URL
* Open in browser

---

## 📷 Proof of Execution

(Add screenshots here)

* S3 bucket created
* Files uploaded
* Static hosting enabled
* CloudFront distribution
* Website running in browser

---

## 🎯 Key Features

* Scalable static website hosting using AWS S3
* Low latency using CloudFront CDN
* Secure access using IAM policies
* Highly available architecture

---

## 🚀 Real-World Use Case

This architecture is widely used for:

* Portfolio websites
* Landing pages
* Frontend hosting for applications

---

## 📌 Conclusion

This project demonstrates how AWS services can be used to host secure, scalable, and high-performance static websites in a real-world DevOps environment.

