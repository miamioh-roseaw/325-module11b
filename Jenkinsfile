pipeline {
  agent any

  environment {
    CISCO_CREDS = credentials('cisco-ssh-creds')
    SUDO_CREDS  = credentials('jenkins-sudo-creds')
  }

  stages {
    stage('Install Puppet') {
      steps {
        sh '''
          echo "[INFO] Installing Puppet..."
          if ! command -v puppet > /dev/null; then
            echo "$SUDO_CREDS_PSW" | sudo -S apt-get update
            echo "$SUDO_CREDS_PSW" | sudo -S apt-get install -y wget
            wget https://apt.puppetlabs.com/puppet7-release-focal.deb
            echo "$SUDO_CREDS_PSW" | sudo -S dpkg -i puppet7-release-focal.deb
            echo "$SUDO_CREDS_PSW" | sudo -S apt-get update
            echo "$SUDO_CREDS_PSW" | sudo -S apt-get install -y puppet-agent
          fi
        '''
      }
    }

    stage('Run Puppet Hostname Config') {
      steps {
        echo "[INFO] Running Puppet to set hostnames..."

        sh '''
          puppet apply set_hostname.pp
        '''
      }
    }
  }
}
