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
                    docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}", "./halloween")
                    
                    // If you need to push the image to a registry, uncomment and modify the following line:
                    // docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                    //     docker.image("${DOCKER_IMAGE}:${BUILD_NUMBER}").push()
                    // }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed'
        }
        success {
            echo 'Code scan and Docker image build completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
    }
}