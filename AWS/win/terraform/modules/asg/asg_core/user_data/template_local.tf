variable "config" {
    type  = map
    default = {
"$externalhostname"   = "hostname.com"
"$databasehostname"   = "db-hostname.com"
"$databaseUsername"   = "username"
"$databasePassword"   = "pw"
"$storageAccountName" = "accountname"
"$storageAccountKey"  = "acocuntkey" 
    }
}

variable "output_file" {
    type    = string
    default = "test_file.ps1"
  
}

locals {
    our_rendered_content = templatefile("user_data_core.tftpl", { config = var.config })
}

resource "null_resource" "local" {
  triggers = {
    template = local.our_rendered_content
  }

  # Render to local file on machine
  # https://github.com/hashicorp/terraform/issues/8090#issuecomment-291823613
  provisioner "local-exec" {
    command = format(
      "cat <<\"EOF\" > \"%s\"\n%s\nEOF",
      var.output_file,
      local.our_rendered_content
    )
  }
}