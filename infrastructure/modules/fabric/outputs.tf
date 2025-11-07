output "capacity_name" {
  description = "Name of the Fabric Capacity"
  value       = var.capacity_name
}

output "workspace_name" {
  description = "Name of the Fabric Workspace"
  value       = var.workspace_name
}

output "lakehouse_name" {
  description = "Name of the Fabric Lakehouse"
  value       = var.create_lakehouse ? var.lakehouse_name : null
}

output "setup_script_path_sh" {
  description = "Path to the generated Fabric setup script (bash)"
  value       = var.generate_setup_script ? local_file.fabric_setup_script[0].filename : null
}

output "setup_script_path_ps1" {
  description = "Path to the generated Fabric setup script (PowerShell)"
  value       = var.generate_setup_script ? local_file.fabric_setup_script_ps1[0].filename : null
}

output "fabric_portal_url" {
  description = "URL to access Microsoft Fabric portal"
  value       = "https://app.fabric.microsoft.com"
}

output "notes" {
  description = "Important notes about Fabric deployment"
  value       = <<-EOT
    Microsoft Fabric resources have limited Terraform support as of AzureRM provider 3.x.
    
    To deploy Fabric resources:
    1. Ensure you have Fabric Admin permissions
    2. Use the generated setup scripts or Azure Portal
    3. Visit https://app.fabric.microsoft.com to configure workspaces and lakehouses
    4. Configure private endpoints for Fabric Lakehouse and Data Pipelines manually
    
    Existing Fabric Capacity: ${var.capacity_name} (${var.use_existing_capacity ? "Referenced" : "To be created"})
    Workspace: ${var.workspace_name}
    Lakehouse: ${var.create_lakehouse ? var.lakehouse_name : "Not created"}
  EOT
}
