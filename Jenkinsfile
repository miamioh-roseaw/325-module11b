pipeline {
  agent any

  stages {
    stage('Install Puppet') {
      steps {
        sh '''
          echo "[INFO] Installing Puppet..."
          wget https://apt.puppet.com/puppet7-release-focal.deb
          sudo dpkg -i puppet7-release-focal.deb
          sudo apt-get update
          sudo apt-get install -y puppet-agent
          export PATH=/opt/puppetlabs/bin:$PATH
          puppet --version
        '''
      }
    }

    stage('Apply Puppet Manifest') {
      environment {
        PATH = "/opt/puppetlabs/bin:$PATH"
      }
      steps {
        sh '''
          echo "[INFO] Running Puppet..."
          puppet apply set_hostname.pp
        '''
      }
    }
  }
}
