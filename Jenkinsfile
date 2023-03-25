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
            sh 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk; export PATH=$JAVA_HOME/bin:$PATH'
            sh './gradlew build'
          }
        }
      }
      
  }
}
