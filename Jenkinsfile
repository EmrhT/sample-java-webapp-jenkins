pipeline {
  agent {
    node {
      label 'kubeagent'
    }
  }
  stages {
    stage('prep') {
      steps {
        git url: 'https://github.com/wardviaene/gs-gradle.git'
      }
    }

    stage('build') {
      steps {
        script {
            sh 'cd complete && gradle build'
          }
        }
      }

    stage('sonar-scanner') {
      steps {
        script {
          def sonarqubeScannerHome = tool name: 'sonar', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
          withCredentials([string(credentialsId: 'sonar', variable: 'sonarLogin')]) {
            sh "${sonarqubeScannerHome}/bin/sonar-scanner -e -Dsonar.host.url=http://sonarqube-sonarqube.sonarqube.svc.cluster.local:9000 -Dsonar.login=${sonarLogin} -Dsonar.projectName=gs-gradle -Dsonar.projectVersion=${env.BUILD_NUMBER} -Dsonar.projectKey=GS -Dsonar.sources=complete/src/main/ -Dsonar.tests=complete/src/test/ -Dsonar.language=java -Dsonar.java.binaries=."
          }  
        }
      }
    }
  }
}
