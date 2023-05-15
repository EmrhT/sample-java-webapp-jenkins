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
     stage('unit test') {
      steps {
        script {
            sh 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk; export PATH=$JAVA_HOME/bin:$PATH; ./gradlew test'
          }
        }
      }
    stage('Sonar-Scanner') {
      steps {
        script {
          def sonarqubeScannerHome = tool name: 'sonar', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
          withCredentials([string(credentialsId: 'sonar', variable: 'sonarLogin')]) {
            sh "${sonarqubeScannerHome}/bin/sonar-scanner -e -Dsonar.host.url=http://sonarqube-sonarqube.sonarqube.svc.cluster.local:9000 -Dsonar.login=${sonarLogin} -Dsonar.projectName=java-webapp -Dsonar.projectVersion=${env.BUILD_NUMBER} -Dsonar.projectKey=JW -Dsonar.sources=build/classes/main/ -Dsonar.tests=build/classes/test/ -Dsonar.language=java"
          }  
        }
      }
    }
    stage ('Podman Build & Push') {
      steps {
        sh "echo 192.168.122.15 harbor.example.com >> /etc/hosts"
        sh "podman build --network=host -t harbor.example.com/mantislogic/sample-java-webapp-jenkins:$GIT_COMMIT ."
        sh "podman login --tls-verify=false harbor.example.com -u admin -p $DOCKERHUB_PASS"
        sh "podman push --tls-verify=false harbor.example.com/mantislogic/sample-java-webapp-jenkins:$GIT_COMMIT"
      }
    }
    stage('Trivy Image Scan') {
      steps {
          sh 'curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.18.3'
          sh 'curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl > html.tpl'
          sh 'TRIVY_INSECURE=true trivy image --ignore-unfixed --vuln-type os,library --exit-code 1 --severity CRITICAL harbor.example.com/mantislogic/sample-java-webapp-jenkins:$GIT_COMMIT'
      }
    }
    stage ('Deploy to K8S Test Namespace') {
      steps {
        withCredentials([file(credentialsId: 'afa1a7c1-5e6c-4d9b-82cb-4293f5c144a3', variable: 'KUBECRED')]) {
          sh 'mkdir ~/.kube'
          sh 'cat $KUBECRED > ~/.kube/config'
          sh 'cat deployment-test.yaml | sed "s/{{GIT_COMMIT}}/$GIT_COMMIT/g" | kubectl apply -f -'
        }
      }
    }
    stage ('OWASP-ZAP Dynamic Scan') {
      steps {
          sh 'podman run --tls-verify=false -t harbor.example.com/mantislogic/zap2docker-stable:2.12.0 zap-baseline.py -t http://nginx-svc.django-brad-test.svc.cluster.local | tee owasp-results.txt || true'
          sh 'cat owasp-results.txt | egrep  "^FAIL-NEW: 0.*FAIL-INPROG: 0"'
      }
    }
    stage ('Deploy to K8S Prod Namespace') {
      steps {
        withCredentials([file(credentialsId: 'afa1a7c1-5e6c-4d9b-82cb-4293f5c144a3', variable: 'KUBECRED')]) {
          sh 'cat $KUBECRED > ~/.kube/config'
          sh 'cat deployment-prod.yaml | sed "s/{{GIT_COMMIT}}/$GIT_COMMIT/g" | kubectl apply -f -'
        }
      }
    }
  }
}
