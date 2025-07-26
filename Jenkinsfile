pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKERHUB_USERNAME = 'ravikumar1997'
        IMAGE_NAME = 'trend-project-repo'
        IMAGE_TAG = "latest"
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Ravikumar-hub97/aws-project-trend-app.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}")
                    dockerImage.tag("${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest")
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        dockerImage.push("${IMAGE_TAG}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                        # Update deployment with new image
                        sed -i "s|YOUR_DOCKERHUB_USERNAME|${DOCKERHUB_USERNAME}|g" k8s/deployment.yaml
                        sed -i "s|latest|${IMAGE_TAG}|g" k8s/deployment.yaml
                        
                        # Apply Kubernetes manifests
                        kubectl apply -f k8s/namespace.yaml
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                        
                        # Wait for rollout
                        kubectl rollout status deployment/trend-app-deployment -n trend-app --timeout=300s
                        
                        # Show deployment status
                        kubectl get pods -n trend-app
                        kubectl get service trend-app-service -n trend-app
                    '''
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker rmi ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} || true'
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
