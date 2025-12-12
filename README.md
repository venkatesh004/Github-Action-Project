
🚀 Quick Summary of the CI/CD Flow — Better Elaborated

Your pipeline is structured like a secure, quality-gated delivery pipeline.
It moves your application from source code → build → test → security → quality checks → Docker → Kubernetes deployment.

Below is the improved, clearly explained flow:


✅ 1. Build Stage (build job)

Purpose: Make sure the code compiles successfully.

Checkout code

Install Java 17

Run mvn package → generates your JAR file

If the code fails to compile, the entire pipeline stops here.

What this stage ensures:
✔ The code you pushed is valid Java code
✔ Dependencies resolve correctly
✔ You get an initial packaged artifact (in target/)

🔐 2. Security Scan Stage (security-check job)

Runs only if build succeeds

Trivy FS Scan

Scans your entire repository for known vulnerabilities inside files (dependencies, configs, etc.)

Gitleaks Scan

Scans your code for secrets (passwords, keys, tokens)

What this stage ensures:
✔ No accidental secrets pushed
✔ No known vulnerabilities in code/configs
✔ The project is safe enough to proceed

🧪 3. Testing Stage (test job)

Runs only if the security scans pass.

Installs Java again

Executes mvn test

Runs all unit tests

What this stage ensures:
✔ All automated tests pass
✔ No regression or broken features
✔ Code behaves correctly before going further

🔍 4. SonarQube Build + Analysis (build_project_and_sonar_scan job)

Runs only if tests pass.

Steps:

Rebuild the project (mvn package)

Upload the built JAR as an artifact (to use in Docker build later)

Perform SonarQube static code analysis

Wait for Quality Gate result (code smells, coverage, bugs, vulnerabilities)

What this stage ensures:
✔ Code follows maintainable standards
✔ No major code smells or vulnerabilities
✔ Quality Gate must PASS to continue
If Sonar fails → pipeline stops.

This prevents bad-quality code from going into production.

🐳 5. Docker Build + Push (build_docker_image_and_push job)

Runs only if SonarQube quality gate passes.

Steps:

Checkout code

Download the JAR artifact produced earlier

Login to Docker Hub

Build Docker image using your local repository context

Push image → venkatikki/bankapp:latest

What this stage ensures:
✔ Your application is containerized
✔ A fresh Docker image is published
✔ Image includes the actual JAR built previously
✔ Image is now ready to deploy

☸️ 6. Deploy to Kubernetes (deploy_to_kubernetes job)

Runs only if Docker image push succeeds.

Steps:

Install AWS CLI

Configure AWS credentials

Install kubectl

Load kubeconfig from secrets

Deploy Kubernetes manifest (ds.yml) to EKS

What this stage ensures:
✔ Your new Docker image is applied to EKS
✔ Cluster receives updated Deployment/DaemonSet configuration
✔ Your application goes live automatically

This completes the CI/CD flow.
