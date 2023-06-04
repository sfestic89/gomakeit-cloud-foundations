logging module from example foundation:
https://github.com/terraform-google-modules/terraform-example-foundation/blob/58205802533ebd82442d92e48cafec9d294f52ae/1-org/modules/centralized-logging/main.tf

usage of module from above:
https://github.com/terraform-google-modules/terraform-example-foundation/blob/58205802533ebd82442d92e48cafec9d294f52ae/1-org/envs/shared/log_sinks.tf#L94

google module for log exports:
https://github.com/terraform-google-modules/terraform-google-log-export

GCP log routing overview:
https://cloud.google.com/logging/docs/routing/overview

Should GCS buckets for logs be created in the logging module or in a separate module ? 