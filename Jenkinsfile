pipeline {
  agent {
    node {
      label 'kubeagent'
    }
  }
  stages {
    stage('prep') {
      steps {
        git url: 'https://github.com/EmrhT/sample-java-webapp-jenkins.git'
      }
    }

    stage('build') {
      steps {
        script {
            sh 'sleep 9999'
            sh './gradlew build'
          }
        }
      }
      
  }
}
