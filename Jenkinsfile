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
                    withSonarQubeEnv('sonar') {
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
                    docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}", "./")
                }
            }
        }

        stage('Install Trivy') {
            steps {
                script {
                    sh '''
                    sudo apt-get update
                    sudo apt-get install -y wget apt-transport-https gnupg lsb-release
                    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
                    echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
                    sudo apt-get update
                    sudo apt-get install -y trivy
                    '''
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                script {
                    try {
                        sh """
                        trivy image --format table \
                        --output trivy-results.txt \
                        ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        """
                    } catch (Exception e) {
                        echo "Trivy scan failed: ${e.message}"
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy-results.txt', allowEmptyArchive: true, fingerprint: true
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed'
            // Clean up Docker images
            script {
                try {
                    sh "docker rmi ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    // Remove any dangling images
                    sh 'docker image prune -f'
                } catch (Exception e) {
                    echo "Cleanup failed: ${e.message}"
                }
            }
            // Clean workspace
            cleanWs()
        }
        success {
            echo 'Code scan, Docker image build, and Trivy scan completed successfully.'
        }
        unstable {
            echo 'Pipeline completed with unstable status. Check Trivy scan results.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
    }
}