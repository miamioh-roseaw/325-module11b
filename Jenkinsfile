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
       stage('Install Puppet on Windows') {
            steps {
                script {
                    def windowsHosts = [
                        '10.10.10.14', // mid-w
                        '10.10.10.15'  // ham-w
                    ]

                    for (host in windowsHosts) {
                        powershell """
                            \$Session = New-PSSession -ComputerName ${host} -Credential (New-Object System.Management.Automation.PSCredential("${env.WINDOWS_USER}", (ConvertTo-SecureString "${env.WINDOWS_PASS}" -AsPlainText -Force)))
                            Invoke-Command -Session \$Session -ScriptBlock {
                                Invoke-WebRequest -Uri 'https://downloads.puppet.com/windows/puppet7/puppet-agent-x64-latest.msi' -OutFile 'C:\\Temp\\puppet-agent.msi'
                                Start-Process 'msiexec.exe' -ArgumentList '/i C:\\Temp\\puppet-agent.msi /qn' -Wait
                                'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet.bat' --version
                            }
                            Remove-PSSession \$Session
                        """
                    }
                }
            }
        }
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
