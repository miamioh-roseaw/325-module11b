pipeline {
  agent any

  environment {
    PATH = "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  }

  stages {
    stage('Install Puppet') {
      steps {
        sh '''
          echo "[INFO] Installing Puppet..."
          wget https://apt.puppetlabs.com/puppet7-release-focal.deb -O puppet.deb
          sudo dpkg -i puppet.deb
          sudo apt-get update
          sudo apt-get install -y puppet-agent
        '''
      }
    }

    stage('Run Puppet Manifest to Set Hostname') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'jenkins-sudo-creds', usernameVariable: 'SSH_USER', passwordVariable: 'SSH_PASS')]) {
          sh '''
            echo "[INFO] Running Puppet manifest..."
            export SSH_USER=$SSH_USER
            export SSH_PASS=$SSH_PASS

            puppet apply set_hostname.pp
          '''
        }
      }
    }
  }
}
