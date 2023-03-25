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
            sh 'apk --no-cache add openjdk8'
            sh 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk; export PATH=$JAVA_HOME/bin:$PATH; ./gradlew build'
          }
        }
      }
    stage('Sonar-Scanner') {
      steps {
        script {
          def sonarqubeScannerHome = tool name: 'sonar', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
          withCredentials([string(credentialsId: 'sonar', variable: 'sonarLogin')]) {
            sh "${sonarqubeScannerHome}/bin/sonar-scanner -e -Dsonar.host.url=http://sonarqube-sonarqube.sonarqube.svc.cluster.local:9000 -Dsonar.login=${sonarLogin} -Dsonar.projectName=java-webapp -Dsonar.projectVersion=${env.BUILD_NUMBER} -Dsonar.projectKey=JW -Dsonar.sources=src/main/ -Dsonar.tests=src/test/ -Dsonar.language=java"
          }  
        }
      }
    }
  }
}
