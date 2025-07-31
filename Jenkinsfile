pipeline {
  agent any

  environment {
    SSH_USER = 'student'
    SSH_PASS = credentials('ssh-creds')
  }

  stages {
    stage('Deploy Hostname Manifests Remotely') {
      steps {
        script {
          def host_map = [
            '10.10.10.11': 'ham-l',
            '10.10.10.12': 'mid-l',
            '10.10.10.13': 'oxf-l'
          ]

          for (entry in host_map) {
            def ip = entry.key
            def new_hostname = entry.value

            echo "[INFO] Setting hostname on ${ip} to ${new_hostname}..."

            sh """
              sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no $SSH_USER@${ip} \\
                'echo "[OLD] Hostname was: \$(hostname)"'

              sshpass -p "$SSH_PASS" scp -o StrictHostKeyChecking=no set_hostname.pp $SSH_USER@${ip}:/tmp/

              sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no $SSH_USER@${ip} \\
                "sudo puppet apply /tmp/set_hostname.pp --execute \\
                  class { 'hostname_setter':
                    desired_hostname => '${new_hostname}',
                  }"

              sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no $SSH_USER@${ip} \\
                'echo "[NEW] Hostname is now: \$(hostname)"'
            """
          }
        }
      }
    }
  }
}
