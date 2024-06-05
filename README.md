# aws_dba_terraform_modules
Collection of terraform modules designed for DBRE/DBA roles


# Mission
The `mission` of this repo is to provide other DBRE/DBAs with resources to stay up to date with our evolving role. I was unable to find related modules when trying to build out infrastructure for my employeers. I wish to share what I have learn, and continue to learn, with the public in the hope to help other DBRE/DBAs on their efforts. 


## Disclosure
These modules may not work out of the box according to your aws infrastructure. These are meant to be editted to your liking, but still provide a good template to start with. I am happy to receive contributors, but I want this to be a resource for other fellow DBRE/DBAs


## New Instances

The following modules are to be used for creating instances without a snapshot. 

## Spindown_instances

The following modules are to be used for creating instances from snapshots. The intention is to spin up one of these resources, and spin them down when done. 

## Utilities 

This folder contains modules that can assist the modules included in this repo. Included you will find modules for creating kms keys, parameter groups, and other utilities that RDS instances will require. However, if you wish to use existing resources, feel free to dictate that in your datasource.tf files.

