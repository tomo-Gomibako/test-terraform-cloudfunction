terraform {
  required_providers {
    dotenv = {
      source  = "jrhouston/dotenv"
      version = "~> 1.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.34.0"
    }
  }
}

data dotenv dev {
  filename = "dev.env"
}

locals {
  project_id = "gomibako"
  project_region = "asia-northeast1"
  project_zone   = "a"
}

provider "google" {
  credentials = file(data.dotenv.dev.env.GCP_SERVICE_ACCOUNT_KEY_PATH)
  project     = local.project_id
  region      = local.project_region
  zone        = local.project_zone
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_service_account" "default" {
  account_id   = "test-gcf-sa"
  display_name = "Test Service Account"
}

resource "google_pubsub_topic" "default" {
  name = "functions2-topic"
}

resource "google_storage_bucket" "default" {
  name                        = "${random_id.bucket_prefix.hex}-gcf-source" # Every bucket name must be globally unique
  location                    = local.project_region
  uniform_bucket_level_access = true
}

data "archive_file" "default" {
  type        = "zip"
  output_path = "/tmp/function-source.zip"
  source_dir  = "."
}

resource "google_storage_bucket_object" "default" {
  provisioner "local-exec" {
    command = "npm run build"
  }

  name   = "function-source.zip"
  bucket = google_storage_bucket.default.name
  source = data.archive_file.default.output_path # Path to the zipped function source code
}

resource "google_cloudfunctions2_function" "test-http" {
  name        = "test-http"
  location    = local.project_region
  description = "a new function"

  build_config {
    runtime     = "nodejs20"
    entry_point = "helloHttp" # Set the entry point
    environment_variables = {
      BUILD_CONFIG_TEST = "build_test"
    }
    source {
      storage_source {
        bucket = google_storage_bucket.default.name
        object = google_storage_bucket_object.default.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    min_instance_count = 0
    available_memory   = "256M"
    timeout_seconds    = 60
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloudfunctions2_function.test-http.location
  service  = google_cloudfunctions2_function.test-http.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "function_uri" {
  value = google_cloudfunctions2_function.test-http.service_config[0].uri
}

resource "google_cloudfunctions2_function" "test-pubsub" {
  name        = "test-pubsub"
  location    = local.project_region
  description = "a new function"

  build_config {
    runtime     = "nodejs20"
    entry_point = "helloPubSub" # Set the entry point
    environment_variables = {
      BUILD_CONFIG_TEST = "build_test"
    }
    source {
      storage_source {
        bucket = google_storage_bucket.default.name
        object = google_storage_bucket_object.default.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    min_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
    environment_variables = {
      SERVICE_CONFIG_TEST = "config_test"
    }
    ingress_settings               = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
    service_account_email          = google_service_account.default.email
  }

  event_trigger {
    trigger_region = local.project_region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.default.id
    retry_policy   = "RETRY_POLICY_RETRY"
  }
}

resource "google_cloud_scheduler_job" "test-pubsub-scheduler" {
  name        = "test-pubsub-scheduler"
  description = "test cron job"
  schedule    = "*/10 * * * *"
  time_zone   = "Asia/Tokyo"

  pubsub_target {
    topic_name = google_pubsub_topic.default.id
    data       = base64encode("World")
  }
}