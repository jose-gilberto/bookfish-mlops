variable "aws_connection_profile" {
    type        = string
    default     = "<AWS connection profile name>"
    description = "The name of the AWS connection profile to use."
}

variable "aws_region" {
    type        = string
    default     = "<AWS Region code>"
    description = "The code of the AWS Region to use."
}

variable "databricks_connection_profile" {
    type        = string
    default     = "<Databricks connection profile name>"
    description = "The name of the Databricks connection profile to use."
}

terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 3.27"
    }

    databricks = {
        source  = "databrickslabs/databricks"
        version = "0.3.2"
    }
  }
}

provider "aws" {
    profile = var.aws_connection_profile
    region  = var.aws_region
}

provider "databricks" {
    profile = var.databricks_connection_profile
}

variable "resource_prefix" {
    description = "The prefix to use when naming the notebook and job"
    type        = string
    default     = "terraform-demo"
}

variable "email_notifier" {
    description = "The email address to send job status to"
    type        = list(string)
    default     = ["<Your email address>"]
}

// Get the information about the databricks user that is calling
// The databricks API (the one associated with "databricks_connection_profile")
data "databricks_current_user" "me" {}

// Create a simple, sample notebook. Store it in a subfolder within
// the databricks current user's folder. The notebook contains
// the following basic spark code in python
resource "databricks_notebook" "this" {
    path            = "${data.databricks_current_user.me.home}/Terraform/${var.resource_prefix}-notebook.ipynb"
    language        = "PYTHON"
    content_base_64 = base64encode(<<-EOT
        # created from ${abspath(path.module)}
        display(spark.range(10))
        EOT
    )
}

// Create a job to run the sample notebook. The job will create
// a cluster to run on. The cluster will use the smallest available
// node type and run the latest version of spark

// get the smallest available node type to use for the cluster. Choose
// only from among available node types with local storage
data "databricks_node_type" "smallest" {
    local_disk = true
}

// Get the latest spark version to use for the cluster.
data "databricks_spark_version" "latest" {}

// Create the job, emailing notifiers about job success or failure.
resource "databricks_job" "this" {
    name    = "${var.resource_prefix}-job-${data.databricks_current_user.me.alphanumeric}"
    new_cluster {
        num_workers     = 1
        spark_version   = data.databricks_spark_version.latest.id
        node_type_id    = data.databricks_node_type.smallest.id
    }
    notebook_task {
        notebook_path   = databricks_notebook.this.path
    }
    email_notifications {
        on_success  = var.email_notifier
        on_failure  = var.email_notifier
    }
}

// Print the URL to the notebook
output "notebook_url" {
    value = databricks_notebook.this.url
}

// Print the URL to the job
output "job_url" {
    value = databricks_job.this.url
}

