pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                withCredentials([
                    azureServicePrincipal(credentialsId: 'a2db8054-fba6-44a5-8ea4-c2f239f23ba6', subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID', clientIdVariable: 'ARM_CLIENT_ID', clientSecretVariable: 'ARM_CLIENT_SECRET', tenantIdVariable: 'ARM_TENANT_ID')
                ]) {
                    script {
                        def initOutput = sh(script: 'terraform init -input=false', returnStdout: true).trim()
                        echo "Terraform init output:\n${initOutput}"
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                withCredentials([
                    azureServicePrincipal(credentialsId: 'a2db8054-fba6-44a5-8ea4-c2f239f23ba6', subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID', clientIdVariable: 'ARM_CLIENT_ID', clientSecretVariable: 'ARM_CLIENT_SECRET', tenantIdVariable: 'ARM_TENANT_ID'),
                    string(credentialsId: 'defonte-ssh-public-key', variable: 'SSH_PUBLIC_KEY')
                ]) {
                    script {
                        def planOutput = sh(script: 'terraform plan -out=tfplan -var "ssh_public_key=${SSH_PUBLIC_KEY}"', returnStdout: true).trim()
                        echo "Terraform plan generated:\n${planOutput}"
                    }
                }
            }
        }
        stage('Manual Approval') {
            steps {
                input message: 'Review the Terraform plan. If everything looks good, proceed with the apply.', ok: 'Deploy'
            }
        }
        stage('Terraform Apply') {
            steps {
                withCredentials([
                    azureServicePrincipal(credentialsId: 'a2db8054-fba6-44a5-8ea4-c2f239f23ba6', subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID', clientIdVariable: 'ARM_CLIENT_ID', clientSecretVariable: 'ARM_CLIENT_SECRET', tenantIdVariable: 'ARM_TENANT_ID'),
                ]) {
                    sh 'terraform apply tfplan'
                }
            }
        }
    }
}
