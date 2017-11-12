####################################################################
#Cookbook Name:: tomcat
#Recipe:: install_tomcat
#Author::Jason Layn
#Date::11/11/2017
#Purpose::Install and configure tomcat on RHEL7 based target system
####################################################################

#Install OpenJDK 7 JDK using yum, run this command:
#$ sudo yum install java-1.7.0-openjdk-devel

#installed the package using package resource. Package was part of the default 
#yum repository of my centOS disto. Maybe add conditional if not found or add
#step above with yum_repos step above.

package 'java-1.7.0-openjdk-devel'

#Create a user for tomcat
#$ sudo groupadd tomcat
#$ sudo useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

#used group resource default action to create. I added append since I think
#I'm going to need it for when I add the tomcat user.

group 'tomcat' do
	append true
end

#used user resource default action to create. 
user 'tomcat' do
	home '/opt/tomcat' # defines the home dir but not create; same as -d /opt/tomcat 
	manage_home false  # do not create the home directory; same as -M
	group 'tomcat'	   # puts in tomcat group; same as -g
	shell '/bin/nologin' # sets shell to no login; same as -s
end
