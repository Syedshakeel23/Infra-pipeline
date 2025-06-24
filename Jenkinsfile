pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        PATH               = "/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin"
        TF_DIR             = 'terraform'
        ANSIBLE_DIR        = 'ansible'
        SCRIPT_DIR         = 'scripts'
    }

    stages {
        stage('Verify Tools') {
            steps {
                sh 'echo "PATH=$PATH"'
                sh 'which terraform'
                sh 'terraform version'
                sh 'which ansible'
                sh 'ansible --version'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init'
                    withCredentials([[
                        credentialsId: 'aws_cred',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        sh '''
                            echo "Applying Terraform infrastructure..."
                            echo "Using Access Key: $AWS_ACCESS_KEY_ID"
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
                            terraform plan
                            terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                dir("${SCRIPT_DIR}") {
                    sh 'bash generate_inventory.bash'
                }
                dir("${ANSIBLE_DIR}") {
                    sh 'cat inventory.ini'
                }
            }
        }

        stage('Run Ansible Playbooks') {
            steps {
                sshagent(['mumbai-key']) {
                    dir("${ANSIBLE_DIR}") {
                        sh 'ansible-playbook playbook.yml'
                        sh 'ansible-playbook backend.yml'
                        sh 'ansible-playbook frontend.yml'
                    }
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
