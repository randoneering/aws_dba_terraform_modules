# aws_dba_terraform_modules
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![MySQL](https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white) ![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white) ![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

Collection of terraform modules designed for DBRE/DBA roles


# mission
The `mission` of this repo is to provide other DBRE/DBAs with resources to stay up to date with our evolving role. I was unable to find related modules when trying to build out infrastructure for my employeers. I wish to share what I have learn, and continue to learn, with the public in the hope to help other DBRE/DBAs on their efforts. 


## disclosure
These modules may not work out of the box according to your aws infrastructure. These are meant to be editted to your liking, but still provide a good template to start with. I am happy to receive contributors, but I want this to be a resource for other fellow DBRE/DBAs


## db_modules

The following modules can be used to deploy Aurora MySQL, Aurora Postgres, and DocumentDB instances. I recently deleted some of the standalone rds and aurora modules to make way for more improved ones. You should see more coming soon.


## Utilities 

This folder contains modules that can assist the modules included in this repo. Included you will find modules for creating kms keys, parameter groups, and other utilities that RDS instances will require. However, if you wish to use existing resources, feel free to dictate that in your datasource.tf files.

## Scripts

The following folder contains bash, python, and shell scripts that can be included inside a resource. These can be used to execute various commands, like creating a payload to send via a webhook. 

## Collaboration

I am open for collaboration as I, myself, am still learning how to sharpen my DBRE skills. If you would like to contribute/collaborate, please contact me at business@randoneering.tech

