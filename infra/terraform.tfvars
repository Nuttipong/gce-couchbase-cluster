gcp_project_id = "tdg-ct-carbontrace-nonprod-brx"
nodes = [
    {
        zone            = "asia-southeast1-a"
        machine_type    = "n1-standard-1"
        image_family    = "ubuntu-2004-lts"
        image_project   = "ubuntu-os-cloud"
        tags            = ["couchbase-tag"]
        subnet          = "default"
    },
    {
        zone            = "asia-southeast1-b"
        machine_type    = "n1-standard-1"
        image_family    = "ubuntu-2004-lts"
        image_project   = "ubuntu-os-cloud"
        tags            = ["couchbase-tag"]
        subnet          = "default"
    },
    {
        zone            = "asia-southeast1-c"
        machine_type    = "n1-standard-1"
        image_family    = "ubuntu-2004-lts"
        image_project   = "ubuntu-os-cloud"
        tags            = ["couchbase-tag"]
        subnet          = "default"
    },
    {
        zone            = "asia-southeast1-a"
        machine_type    = "n1-standard-1"
        image_family    = "ubuntu-2004-lts"
        image_project   = "ubuntu-os-cloud"
        tags            = ["couchbase-tag"]
        subnet          = "default"
    },
    {
        zone            = "asia-southeast1-b"
        machine_type    = "n1-standard-1"
        image_family    = "ubuntu-2004-lts"
        image_project   = "ubuntu-os-cloud"
        tags            = ["couchbase-tag"]
        subnet          = "default"
    },
    {
        zone            = "asia-southeast1-c"
        machine_type    = "n1-standard-1"
        image_family    = "ubuntu-2004-lts"
        image_project   = "ubuntu-os-cloud"
        tags            = ["couchbase-tag"]
        subnet          = "default"
    },
]