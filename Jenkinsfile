pipeline {
    agent any

    environment {
        SSH_USER = 'student'
        SSH_PASS = credentials('ssh-creds')  // Jenkins credential ID for Linux SSH password
        WINDOWS_USER = 'Administrator'
        WINDOWS_PASS = credentials('win-creds') // Jenkins credential ID for Windows password
    }

    stages {
        stage('Install Puppet on Linux') {
            steps {
                script {
                    def linuxHosts = [
                        '10.10.10.11', // ham-l
                        '10.10.10.12', // mid-l
                        '10.10.10.13'  // oxf-l
                    ]

                    for (host in linuxHosts) {
                        sh """
                            echo "[INFO] Installing Puppet on Linux host ${host}..."
                            sshpass -p '${SSH_PASS}' ssh -o StrictHostKeyChecking=no ${SSH_USER}@${host} \\
                              'curl -O https://apt.puppet.com/puppet7-release-jammy.deb && \\
                               sudo dpkg -i puppet7-release-jammy.deb && \\
                               sudo apt-get update && \\
                               sudo apt-get install -y puppet-agent && \\
                               /opt/puppetlabs/bin/puppet --version'
                        """
                    }
                }
            }
        }

        stage('Install Puppet on Windows') {
            steps {
                echo '[PLACEHOLDER] Install Puppet on Windows machines using WinRM or PowerShell'
                // You can later implement:
                // - PowerShell plugin to run Puppet MSI install via remoting
                // - WinRM + ps1 script
            }
        }
    }

    post {
        success {
            echo '✅ Puppet installed successfully on all devices.'
        }
        failure {
            echo '❌ Puppet installation failed.'
        }
    }
}
