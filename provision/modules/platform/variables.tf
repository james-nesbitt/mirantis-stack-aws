
variable "platform_key" {
  description = "Platform name/label key for the platforms list, which must match the internal library of platforms."
  type        = string
}

variable "windows_password" {
  description = "Password to use with windows & winrm, which is used to generate the windows user_data."
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.windows_password) >= 10
    error_message = "Password must have at least 10 characters."
  }

  validation {
    condition     = can(regex("[A-Z]", var.windows_password))
    error_message = "Password must contain at least one uppercase letter."
  }

  validation {
    condition     = can(regex("[a-z]", var.windows_password))
    error_message = "Password must contain at least one lowercase letter."
  }

  validation {
    condition     = can(regex("[^a-zA-Z0-9]", var.windows_password))
    error_message = "Password must contain at least one character that isn't a letter or a digit."
  }

  validation {
    condition     = can(regex("[0-9]", var.windows_password))
    error_message = "Password must contain at least one digit."
  }
}
