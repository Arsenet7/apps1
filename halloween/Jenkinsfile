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
    }
}
