pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-south-1'
  }

  stages {

    stage('Checkout SCM') {
      steps {
        git url: 'https://github.com/Syedshakeel23/Infra-pipeline.git', branch: 'main'
      }
    }

    stage('Verify Tools') {
      steps {
        sh 'which terraform'
        sh 'terraform version'
        sh 'which ansible'
        sh 'ansible --version'
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        dir('terraform') {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_cred']]) {
            sh 'terraform init'
            sh 'terraform apply -auto-approve'
          }
        }
      }
    }

    stage('Run Ansible Playbooks') {
      steps {
        // Use ssh-agent with 'mumbai-key' during Ansible execution
        sshagent(['mumbai-key']) {
          sh 'ansible --version'
          sh 'ansible-playbook -i ansible/inventory.ini ansible/backend.yml'
          sh 'ansible-playbook -i ansible/inventory.ini ansible/frontend.yml'
        }
      }
    }

  }

  post {
    always {
      echo 'Pipeline completed.'
    }
  }
}
