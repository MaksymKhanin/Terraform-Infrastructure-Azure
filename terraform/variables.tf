variable "subscription_type" {
  description = "The type of subscription (build, inte, prod)"
  type        = string

  validation {
    condition     = contains(["build", "inte", "prod"], var.subscription_type)
    error_message = "The subscription_type value can only be 'build', 'inte' or 'prod'."
  }
}

variable "environment_id" {
  description = "The unique (subscription wide) one char ID of the apiTemplate environment. It's only used in the 'build' subscription"
  type        = string

  validation {
    condition     = contains(["d", "i"], var.environment_id)
    error_message = "The environment_id value can only be 'd' or 'i' as we don't have another environments for now."
  }
}

variable "environment_name" {
  description = "The unique (subscription wide) environment name"
  type        = string

  validation {
    condition     = length(var.environment_name) > 0
    error_message = "The environment_name must be supplied."
  }
}

variable "plan_sku" {
  description = "The Sku of the App Service Plan"
  type = object({
    tier = string
    size = string
  })
}

variable "default_log_level" {
  description = "The default logging level used by Azure App Services and Azure Functions"
  type        = string
}

variable "external_key_vault_id" {
  description = "The Azure resource ID of the Key Vault containing external secrets, such as Kafka ones"
  type        = string
}