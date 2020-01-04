pipeline {
  agent {
    any
  }
  parameters {
    password (name: 'AWS_ACCESS_KEY_ID')
    password (name: 'AWS_SECRET_ACCESS_KEY')
  }
  environment {
    TF_WORKSPACE = 'dev'
    TF_IN_AUTOMATION = 'true'
    AWS_ACCESS_KEY_ID = "${params.AWS_ACCESS_KEY_ID}"
    AWS_SECRET_ACCESS_KEY = "${params.AWS_SECRET_ACCESS_KEY}"
  }
  stages {
    stage('Terraform Init') {
      steps {
        sh "docker run -i -t hashicorp/terraform:light init -input=false"
      }
    }
    stage('Terraform Plan') {
      steps {
        sh "docker run -i -t hashicorp/terraform:light plan -out=tfplan -input=false -var-file='dev.tfvars'"
      }
    }
    stage('Terraform Apply') {
      steps {
        input 'Apply Plan'
        sh "docker run -i -t hashicorp/terraform:light apply -input=false tfplan"
      }
    }
  }
}
