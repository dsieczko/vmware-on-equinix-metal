# VMware on Equinix Metal
This repo has Terraform plans to deploy a multi-node vSphere cluster with vSan enabled on Packet. Follow this simple instructions below and you shold be able to go from zero to vSphere in 30 to 60m.

## Install Terraform 
Terraform is just a single binary.  Visit their [download page](https://www.terraform.io/downloads.html), choose your operating system, make the binary executable, and move it into your path. 
 
Here is an example for **macOS**: 
```bash 
curl -LO https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_darwin_amd64.zip 
unzip terraform_0.12.18_darwin_amd64.zip 
chmod +x terraform 
sudo mv terraform /usr/local/bin/ 
``` 
 
## Download this project
To download this project and get in the directory, run the following commands:

## Initialize Terraform 
Terraform uses modules to deploy infrastructure. In order to initialize the modules you run: `terraform init`. This should download a few modules into a hidden directory called `.terraform` 

## Setup an S3 compatible object store
You need to use an S3 compatible object store in order to download *closed source* packages such as *vCenter* and the *vSan SDK*. [Minio](http://minio.io) works great for this, which is an open source object store is a workable option.

You will need to layout the S3 structure to look like this:
``` 
https://s3.example.com: 
    | 
    |__ vmware 
        | 
        |__ VMware-VCSA-all-7.0-14367737.iso
        | 
        |__ vsanapiutils.py
        | 
        |__ vsanmgmtObjects.py
``` 

These files can be downloaded from [My VMware](http://my.vmware.com).
 
You will need to find the two individual Python files in the vSAN SDK zip file and place them in the S3 bucket as shown above.
 
## Modify your variables 
There is a `tfvars.template` file that you can copy and use to update with your deployment variables. Run `cp tfvars.template terraform.tfvars` and open the file in a text editor to update the variables.

Required are:

* `auth_token` - This is your Equinix API key.
* `ssh_private_key_path` - The local private part of your Equinix Metal SSH key.
* `public_ips_cidr` - A block or blocks of Equinix Metal reserved IPs for your vCenter & ESXi Hosts.
* `project_id` - The Equinix Metal project you'd like to deploy this into.
* `organization_id` - Your Equinix Metal org.
* `s3_access_key`
* `s3_secret_key`
* `s3_url`
* `s3_bucket_name` - Bucket where the required files are located.

The others set how many hosts you'd like, their size, etc. You'll notice some default values in the `tfvars.template` file.
 
## Deploy the Packet vSphere cluster 
 
All there is left to do now is to deploy the cluster! Hopefully you don't get any errors
```bash 
terraform apply
``` 
This should end with output similar to this:

``` 
Apply complete! Resources: 50 added, 0 changed, 0 destroyed. 
 
Outputs: 
 
vCenter_Appliance_Root_Password = n4$REf6p*oMo2eYr 
vCenter_FQDN = vcva.packet.local 
vCenter_Password = bzN4UE7m3g$DOf@P 
vCenter_Username = Administrator@vsphere.local 
``` 
 


## Cleaning the environement
To clean up a created environment (or a failed one), run `terraform destroy --auto-approve`.

If this does not work for some reason, you can manually delete each of the resources created in Packet (including the project) and then delete your terraform state file, `rm -f terraform.tfstate`.
