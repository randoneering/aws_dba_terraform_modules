# aws_dba_terraform_modules
Collection of terraform modules designed for DBRE/DBA roles


## New Instances

The following modules are to be used for creating instances without a snapshot. 

## Spindown_instances

The following modules are to be used for creating instances from snapshots. The intention is to spin up one of these resources, and spin them down when done. 

## Utilities 

This folder contains modules that can assist the modules included in this repo. Included you will find modules for creating kms keys, parameter groups, and other utilities that RDS instances will require. However, if you wish to use existing resources, feel free to dictate that in your datasource.tf files.