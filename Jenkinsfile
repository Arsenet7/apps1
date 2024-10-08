pipeline {
    agent { label 'master' }

    environment {
        // SonarQube authentication token
        SONAR_TOKEN = credentials('sonarid')  // Securely using Jenkins credentials
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Cloning the GitHub repository from the main branch
                git branch: 'main', 
                    url: 'https://github.com/Arsenet7/apps1.git'
            }
        }

        stage('Code Scan with SonarQube') {
            steps {
                script {
                    // Run SonarQube scan
                    withSonarQubeEnv('halloween') {  // Correct SonarQube scanner name based on your configuration
                        sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=halloween \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=https://sonarqube.devopseasylearning.uk/ \
                        -Dsonar.login=$SONAR_TOKEN  // Securely passing the SonarQube token
                        '''
                    }
                }
            }
        }

        stage('Quality Gate Check') {
            steps {
                script {
                    // Waiting for SonarQube quality gate result
                    timeout(time: 1, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
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
            echo 'Code scan and quality gate passed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
    }
}
