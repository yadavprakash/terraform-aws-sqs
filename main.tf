#Module      : label
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
module "labels" {
  source = "git::https://github.com/yadavprakash/terraform-aws-labels.git?ref=v1.0.0"

  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  attributes  = var.attributes
  label_order = var.label_order
}

# Module      : SQS
# Description : Terraform module to create SQS resource on AWS for managing queue.
#tfsec:ignore:aws-sqs-enable-queue-encryption
resource "aws_sqs_queue" "default" {
  count = var.enabled ? 1 : 0

  name                              = var.fifo_queue ? format("%s.fifo", module.labels.id) : module.labels.id
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  policy                            = var.policy
  sqs_managed_sse_enabled           = var.sqs_managed_sse_enabled
  redrive_policy                    = var.redrive_policy
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  tags                              = module.labels.tags
}
