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

- Identity and Access Management (IAM) API
- Cloud Functions API
- Eventarc API
- Cloud Scheduler API

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
- iam.serviceAccounts.get
- pubsub.topics.get
- run.services.getIamPolicy
- run.services.setIamPolicy
- storage.buckets.get
- storage.objects.create
- storage.objects.delete
- storage.objects.get
