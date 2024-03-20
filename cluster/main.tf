
resource "time_static" "now" {}

# get our (client) id
data "aws_caller_identity" "current" {}

locals {

  // build some tags for all things
  management_tags = {
    "stack"   = var.name
    "created" = time_static.now.rfc3339
    "expire"  = timeadd(time_static.now.rfc3339, "72h")
    "user_id" = data.aws_caller_identity.current.user_id
  }

}
