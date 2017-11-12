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

#Download the Tomcat Binary
#$ cd /tmp
#$ wget http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.20/bin/apache-tomcat-8.5.20.tar.gz

#used remote_file resource to grab the file. Set action create if missing so will download when
#missing 
remote_file '/tmp/apache-tomcat-8.5.23.tar.gz' do
	source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz'
	action :create_if_missing
end

#Extract the Tomcat Binary
#$ sudo mkdir /opt/tomcat

directory '/opt/tomcat' 

#$ sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1

execute 'extract java tarball' do
	command 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
	cwd '/tmp'
	not_if { File.exists?("/opt/tomcat/lib/catalina.jar")}
end
