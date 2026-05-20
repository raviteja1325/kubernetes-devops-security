pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' 
            }
        } 
      stage('Unit Tests') {
            steps {
              sh "mvn test" 
            }
        }
      stage('Docker Build and Push') {
            steps {
              sh "print env"
              sh 'docker build -t ravitheja13/numeric-app:""$GIT_COMMIT"" .'
              sh 'docker push ravitheja13/numeric-app:""$GIT_COMMIT"" '
            }
        }   
    }
}