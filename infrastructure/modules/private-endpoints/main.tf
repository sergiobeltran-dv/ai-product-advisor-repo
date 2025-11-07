# Private Endpoints
resource "azurerm_private_endpoint" "private_endpoints" {
  for_each = var.private_endpoints

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = each.value.subnet_id

  private_service_connection {
    name                           = "${each.value.name}-connection"
    private_connection_resource_id = each.value.private_connection_resource_id
    is_manual_connection           = lookup(each.value, "is_manual_connection", false)
    subresource_names              = lookup(each.value, "subresource_names", [])
    request_message                = lookup(each.value, "is_manual_connection", false) ? lookup(each.value, "request_message", null) : null
  }

  dynamic "private_dns_zone_group" {
    for_each = lookup(each.value, "private_dns_zone_ids", null) != null ? [1] : []
    content {
      name                 = "${each.value.name}-dns-group"
      private_dns_zone_ids = each.value.private_dns_zone_ids
    }
  }

  tags = var.tags
}
