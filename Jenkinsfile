pipeline {
    agent { label 'master' }

    environment {
        SONAR_TOKEN = credentials('sonarid')
        SCANNER_HOME = tool 'scan'
        DOCKER_IMAGE = 'arsenet10/halloween-image'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/Arsenet7/apps1.git'
            }
        }

        stage('Code Scan with SonarQube') {
            steps {
                script {
                    withSonarQubeEnv('sonar') {  // Make sure this matches your SonarQube server name in Jenkins
                        sh """
                        ${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=halloween \
                        -Dsonar.sources=./halloween \
                        -Dsonar.host.url=https://sonarqube.devopseasylearning.uk/ \
                        -Dsonar.login=$SONAR_TOKEN
                        """
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}", "./")
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                script {
                    // Run Trivy scan
                    sh """
                    trivy image --format table \
                    --output trivy-results.txt \
                    ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    """
                }
            }
            post {
                always {
                    // Archive Trivy scan results
                    archiveArtifacts artifacts: 'trivy-results.txt', fingerprint: true
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed'
        }
        success {
            echo 'Code scan, Docker image build, and Trivy scan completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
    }