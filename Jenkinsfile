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
            withDockerRegistry(credentialsId: 'docker-creds', url: "") {
              sh "printenv"
              sh 'docker build -t ravitheja13/numeric-app:""$GIT_COMMIT"" .'
              sh 'docker push ravitheja13/numeric-app:""$GIT_COMMIT"" '
            }  
          }
        }

      stage('kubernetes Deployment - Dev') {
            steps {
            withKubeConfig(credentialsId: 'kube-config') {
              sh "sed -i 's#replace#ravitheja13/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
              sh "kubectl apply -f k8s_deployment_service.yaml"
            }  
          }
        }   
    }
}