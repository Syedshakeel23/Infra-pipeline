pipeline {
    agent any

    environment {
        TF_DIR = 'terraform'
        ANSIBLE_DIR = 'ansible'
        SCRIPT_DIR = 'scripts'
    }

    stages {
        stage('Terraform Init & Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                dir("${SCRIPT_DIR}") {
                    sh 'bash generate_inventory.sh'
                }
                script {
                    sh 'cat ${ANSIBLE_DIR}/inventory.ini'
                }
            }
        }

        stage('Run Ansible Playbooks') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sh 'ansible-playbook playbook.yml'
                    sh 'ansible-playbook backend.yml'
                    sh 'ansible-playbook frontend.yml'
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

