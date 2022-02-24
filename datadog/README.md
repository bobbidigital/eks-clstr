# Setting up Datadog IAM Service Accounts

First we need to run Terraform to create the policy

`make init`
`make apply`

If the Datadog API Key isn't already in the Secrets manager lets add it now

`aws secretsmanager create-secret --name datadog/datadog-api-key --secret-string <API_KEY> `

Then we need to run `eksctl` to setup OIDC

`eksctl utils associate-iam-oidc-provider --region=<REGION> --cluster=<CLUSTERNAME> --approve`

Make a note of the policy ARN that's provided

Next we need to create the Service Accounts

`eksctl create iamserviceaccount --name service-datadog --namespace tools --cluster primary-cluster --attach-policy-arn  <ARN OF POLICY GENERATED ABOVE> --approve --override-existing-serviceaccounts`

Next we'll install the Kubernetes Secret Store CSI Driver

`helm repo add secrets-store-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/master/charts`
`helm -n kube-system install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver`

Now we need to install the AWS Secrets and Configuration Provider

`curl -s https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml | kubectl apply -f - `

Next we need to apply the secrets provider class yaml in K8s to the same namespace that the datadog pods will be running in.

`cd ../k8s`
`kubectl apply -f secrets_provider.yaml --namespace tools`
