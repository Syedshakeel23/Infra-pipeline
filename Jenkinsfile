pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
        PATH                  = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        TF_DIR                = 'terraform'
        ANSIBLE_DIR           = 'ansible'
        SCRIPT_DIR            = 'scripts'
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
                dir("${TF_DIR}") {
                    sh 'terraform init'
                    sh 'AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION terraform apply -auto-approve'
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                dir("${SCRIPT_DIR}") {
                    sh 'bash generate_inventory.bash'
                }
                script {
                    sh "cat ${ANSIBLE_DIR}/inventory.ini"
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
