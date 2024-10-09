pipeline {
    agent { label 'master' }

    environment {
        SONAR_TOKEN = credentials('sonarid')
        SCANNER_HOME = tool 'scan'
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
    }

    post {
        always {
            echo 'Pipeline completed'
        }
        success {
            echo 'Code scan completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
    }
}