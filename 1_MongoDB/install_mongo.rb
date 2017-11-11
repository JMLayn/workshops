##########################################################################
# Cookbook Name:: mongodb
# Recipe:: install_mongo
# Author::Jason Layn
# Date: 11/11/2017
# Not sure how to get started?
#
# You could:
# 1.  copy the relevant commands from http://docs.mongodb.org/manual/tutorial/install-mongodb-on-red-hat-centos-or-fedora-linux/
# 2.  comment out everything
# 3.  add the Chef resources and other Chef code necessary
#
# This file is an example of steps 1 and 2 above.
##########################################################################
#

# Create a /etc/yum.repos.d/mongodb.repo file to hold the following configuration information for the MongoDB repository:
#
# If you are running a 64-bit system, use the following configuration:
#
# [mongodb]
# name=MongoDB Repository
# baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
# gpgcheck=0
# enabled=1

#using yum repository resource to create the .repo file.
#At first I was going to just create the file using the file resource but
#found this to more elegant
yum_repository 'mongodb-org-3.4' do
	description "Repository for latest stable release of MongoDB"
	baseurl "https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/"
	gpgcheck false	
	enabled true
end
# If you are running a 32-bit system, which is not recommended for production deployments, use the following configuration:
#
# [mongodb]
# name=MongoDB Repository
# baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/i686/
# gpgcheck=0
# enabled=1
#
# Install the MongoDB packages and associated tools.
#
# sudo yum install mongodb-org
#
#
# Start MongoDB.
#
# sudo service mongod start
#
# ensure that MongoDB will start following a system reboot by issuing the following command:
#
# sudo chkconfig mongod on#
