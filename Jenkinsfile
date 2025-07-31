pipeline {
  agent any

  environment {
    // Add any credentials you want to use later (e.g., for SSH or domain join)
  }

  stages {
    stage('Install Puppet') {
      steps {
        sh '''
          echo "[INFO] Installing Puppet..."
          if ! command -v puppet &> /dev/null; then
            wget https://apt.puppet.com/puppet7-release-focal.deb
            sudo dpkg -i puppet7-release-focal.deb
            sudo apt-get update
            sudo apt-get install -y puppet-agent
            echo 'export PATH=$PATH:/opt/puppetlabs/bin' >> ~/.bashrc
            export PATH=$PATH:/opt/puppetlabs/bin
          else
            echo "[INFO] Puppet already installed."
          fi
        '''
      }
    }

    stage('Run Puppet Hostname Manifest') {
      steps {
        sh '''
          echo "[INFO] Running Puppet manifest to set hostname..."
          export PATH=$PATH:/opt/puppetlabs/bin
          puppet apply set_hostname.pp
        '''
      }
    }
  }
}
