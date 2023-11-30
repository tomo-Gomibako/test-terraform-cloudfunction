# Test Terraform Cloud Functions

## Deploy

```bash
terraform init
terraform plan  # optional
terraform apply
```

## Clean up

```bash
terraform destroy
```

## Required APIs

- [Cloud Functions API](https://console.cloud.google.com/apis/api/cloudfunctions.googleapis.com)
- [Cloud Run API](https://console.cloud.google.com/apis/api/run.googleapis.com)
- [Cloud Scheduler API](https://console.cloud.google.com/apis/api/cloudscheduler.googleapis.com)
- [Eventarc API](https://console.cloud.google.com/apis/api/eventarc.googleapis.com)
- [Identity and Access Management (IAM) API](https://console.cloud.google.com/apis/api/iam.googleapis.com)

## Required Permissions

- cloudfunctions.functions.create
- cloudfunctions.functions.delete
- cloudfunctions.functions.get
- cloudfunctions.functions.update
- cloudfunctions.operations.get
- cloudscheduler.jobs.create
- cloudscheduler.jobs.delete
- cloudscheduler.jobs.enable
- cloudscheduler.jobs.get
- cloudscheduler.jobs.update
- iam.serviceAccounts.actAs
- iam.serviceAccounts.delete
- iam.serviceAccounts.get
- pubsub.topics.get
- run.services.getIamPolicy
- run.services.setIamPolicy
- storage.buckets.get
- storage.objects.create
- storage.objects.delete
- storage.objects.get
