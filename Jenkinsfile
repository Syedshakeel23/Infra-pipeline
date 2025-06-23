pipeline {
    agent any

    environment {
        PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        TF_DIR = 'terraform'
        ANSIBLE_DIR = 'ansible'
        SCRIPT_DIR = 'scripts'
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
                    sh 'terraform apply -auto-approve'
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
                // SSH agent block to inject private key
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
