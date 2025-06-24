pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        PATH               = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        TF_DIR             = 'terraform'
        ANSIBLE_DIR        = 'ansible'
        SCRIPT_DIR         = 'scripts'
    }

    stages {
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
                withCredentials([usernamePassword(
                    credentialsId: 'aws_cred',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    dir("${TF_DIR}") {
                        sh '''
                            terraform init
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
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
