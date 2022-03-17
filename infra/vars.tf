# VARIABLES #
variable "gcp_project_id" { type = string }
variable "nodes" { 
    type = list(object({
        zone          = string
        machine_type  = string
        image_family  = string
        image_project = string
        tags          = list(string)
        subnet        = string
    })) 
}

# LOCAL VARIABLES #
locals {
    nodes = flatten([ for node in var.nodes: 
                        {
                            zone          = node.zone
                            machine_type  = node.machine_type
                            image_family  = node.image_family
                            image_project = node.image_project
                            tags          = node.tags
                            subnet        = node.subnet
                        }
                    ])
}