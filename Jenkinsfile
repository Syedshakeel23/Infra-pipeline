pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-south-1'
  }

  stages {

    stage('Checkout SCM') {
      steps {
        git branch: 'main', url: 'https://github.com/Syedshakeel23/Infra-pipeline.git'
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
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                          credentialsId: 'aws_cred',
                          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          dir('terraform') {
            sh '''
              export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
              export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
              export AWS_DEFAULT_REGION=$AWS_REGION

              terraform init
              terraform apply -auto-approve
            '''
          }
        }
      }
    }

    stage('Run Ansible Playbooks') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ansible_ssh_key', keyFileVariable: 'SSH_KEY')]) {
          dir('ansible') {
            sh '''
              chmod 600 $SSH_KEY
              ansible-playbook -i hosts --private-key=$SSH_KEY playbook.yml
              ansible-playbook -i hosts --private-key=$SSH_KEY backend.yml
              ansible-playbook -i hosts --private-key=$SSH_KEY frontend.yml
            '''
          }
        }
      }
    }
  }

  post {
    always {
      echo '✅ CI/CD Pipeline completed.'
    }
    success {
      echo '🎉 All stages completed successfully!'
    }
    failure {
      echo '❌ Pipeline failed. Check stage logs for details.'
    }
  }
}
