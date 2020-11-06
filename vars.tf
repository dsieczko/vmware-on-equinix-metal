variable "auth_token" {}
variable "organization_id" {}
variable "public_ips_cidr" {}
variable "project_id" {}
variable "ssh_private_key_path" {}
variable "router_hostname" {}
variable "esxi_hostname" {}
variable "router_size" {}
variable "esxi_size" {}
variable "facility" {}
variable "router_os" {}
variable "vmware_os" {}
variable "billing_cycle" {}
variable "esxi_host_count" {}
variable "vcenter_portgroup_name" {}
variable "domain_name" {}
variable "vpn_user" {}
variable "vcenter_datacenter_name" {}
variable "vcenter_cluster_name" {}
variable "vcenter_domain" {}
variable "vcenter_user_name" {}
variable "s3_url" {}
variable "s3_bucket_name" {}
variable "s3_access_key" {}
variable "s3_secret_key" {}
variable "vcenter_iso_name" {}

/*
Valid vsphere_service_types are:
    faultToleranceLogging
    vmotion
    vSphereReplication
    vSphereReplicationNFC
    vSphereProvisioning
    vsan
    management

The subnet name "Management" is reserved for ESXi hosts.
Whichever subnet is labeled with vsphere_service_type: management will share a vLan with ESXi hosts.
*/

variable "private_subnets" {
  default = [
    {
      "name" : "VM Private Net 1",
      "nat" : true,
      "vsphere_service_type" : null,
      "routable" : true,
      "cidr" : "172.16.0.0/24"
    },
    {
      "name" : "vMotion",
      "nat" : false,
      "vsphere_service_type" : "vmotion",
      "routable" : false,
      "cidr" : "172.16.1.0/24"
    },
    {
      "name" : "vSAN",
      "nat" : false,
      "vsphere_service_type" : "vsan",
      "routable" : false,
      "cidr" : "172.16.2.0/24"
    }
  ]
}

variable "public_subnets" {
  default = [
    {
      "name" : "VM Public Net 1",
      "nat" : false,
      "vsphere_service_type" : "management",
      "routable" : true,
      "ip_count" : 4
    }
  ]
}
