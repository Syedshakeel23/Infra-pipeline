pipeline {
  agent any

  environment {
    TF_VAR_aws_region = 'ap-south-1'
  }

  stages {
    stage('Checkout SCM') {
      steps {
        git 'https://github.com/Syedshakeel23/Infra-pipeline.git'
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
        withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          dir('terraform') {
            sh '''
              export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
              export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
              terraform init
              terraform apply -auto-approve
            '''
          }
        }
      }
    }

    stage('Run Ansible Playbooks') {
      steps {
        dir('ansible') {
          sh 'ansible-playbook -i hosts disable-selinux-firewalld.yml'
          sh 'ansible-playbook -i hosts backend.yml'
          sh 'ansible-playbook -i hosts frontend.yml'
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
