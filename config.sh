#!/usr/bin/env bash
# Script for generating nextflow.config file

# ex. nextflow.config
# cloud {
#     imageId = 'ami-f34507e5'
#     instanceType = 'm4.xlarge'
#     userName = 'your_username'
#     keyName = 'your_keyname'
# }

RED='\033[0;31m'
Green='\033[0;32m' 
NC='\033[0m'


echo -n "Enter keyName [*REQUIRED*]: "
read keyname
if [ -z ${keyname} ];then
	printf "${RED}valid ${RED}keyName ${RED}required!${NC}\n"
	exit 1
fi

username="ec2-user"

echo -n "Enter instance type [default = m4.xlarge]: "
read instance
if [ -z ${instance} ];then
	instance="m4.xlarge"
fi

echo -n "Enter subnet ID: "
read subnet

echo -n "Enter security group: "
read sggroup

echo -n "Enter EFS ID: "
read efsid

echo "cloud{" > nextflow.config
echo "	imageId = 'ami-d1f9a6aa'" >> nextflow.config
echo "	instanceType = '${instance}'" >> nextflow.config
echo "	userName = '${username}'" >> nextflow.config
echo "	keyName = '${keyname}'" >> nextflow.config

if [ ! -z ${sggroup} ];then
	echo "	securityGroup = '${sggroup}'" >> nextflow.config
fi

if [ ! -z ${subnet} ];then
	echo "	subnetId = '${subnet}'" >> nextflow.config
fi

if [ ! -z ${efsid} ];then
	echo "	sharedStorageId = '${efsid}'" >> nextflow.config
else
	printf "${RED}EFS ID is required! ${NC}\n"
fi

echo "}" >> nextflow.config
echo ""
echo "-- nextflow.config --"
cat nextflow.config
echo ""

nextflow=`which nextfldw`
if [ -z ${nextflow} ];then
	echo -n "Would you like to download nextflow? [y/n]"
	read nextdl
	if [ "${nextdl}" == "y" ] || [ "${nextdl}" == "Y" ] || [ "${nextdl}" == "yes" ];then
		curl -fsSL get.nextflow.io | bash
		working=`pwd`
		echo "add $working to your PATH environment variable"
		echo ""
		printf "${Green}*************************************************** ${NC}\n"
		printf "${Green}* You can now create a GFE cluster with nextflow! * ${NC}\n"
		printf "${Green}* ./nextflow cloud create gfe-cluster -c          * ${NC}\n"
		printf "${Green}*************************************************** ${NC}\n"
	fi
else
	printf "${Green}*************************************************** ${NC}\n"
	printf "${Green}* You can now create a GFE cluster with nextflow! * ${NC}\n"
	printf "${Green}* ./nextflow cloud create gfe-cluster -c          * ${NC}\n"
	printf "${Green}*************************************************** ${NC}\n"
fi







