pipeline {
    agent { label 'master' }
    
    stages {
        stage('Git Clone') {
            steps {
                // Cloning the repository
                git branch: 'main', 
                    url: 'https://github.com/Arsenet7/apps1.git'
            }
        }
        
        stage('Code Scan') {
            steps {
                script {
                    // Run SonarQube scan
                    withSonarQubeEnv('SonarQube') {
                        sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=apps1 \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://your-sonarqube-server-url \
                        -Dsonar.login=${SONAR_TOKEN}
                        '''
                    }
                }
            }
        }
        
        stage('Quality Gate') {
            // Wait for SonarQube quality gate result
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
