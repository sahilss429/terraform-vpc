pipeline {

properties([
    buildDiscarder(logRotator(numToKeepStr: '5')), 
    disableConcurrentBuilds()
])

node('dood') {
        wrap([$class: 'AnsiColorBuildWrapper']) {
            stage('Checkout Code') {
                checkout scm
            }
            stage('Are we building?') {
                sh 'git log -1 --pretty=%B > git_message'
                if (!readFile('git_message').startsWith('[blacksmith]')) {
                    stage('Setup Gitconfig') {
                        tokens = "${env.JOB_NAME}".tokenize('/')
                        org = tokens[0]
                        repo = tokens[1]
                        branch = tokens[2]
                        sh "git remote set-url origin git@github.com:${org}/${repo}.git"
                        sh("git config user.email sahilss429@gmail.com")
                        sh("git config user.name 'sahilss429'")
                    }
                    stage('Validate') {
                        sh '"bundle exec rake lint syntax"'
                    }
                    stage('Test') {
                        sh '"bundle exec rake spec"'
                    }
                    stage('Build') {
                        sh '"git checkout -b publish_tmp && git checkout -B master publish_tmp && bundle exec rake publish && git branch -d publish_tmp && git push --tags origin master"'
                    }
                }
            }
        }
    }
}
