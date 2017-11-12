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

#used remote_file resource to grab the file. Set action create if missing so
# will download when missing
 
remote_file '/tmp/apache-tomcat-8.5.23.tar.gz' do
	source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz'
	action :create_if_missing
end

#Extract the Tomcat Binary
#$ sudo mkdir /opt/tomcat

#create directory using directory resource

directory '/opt/tomcat' 

#$ sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1

#used execute resource to extract the file. Saw there was some development of 
#a tar recipe at one point. Guard uses Ruby class(?) File in the conditional to
#check if the catalina.jar file exists. I noticed execute can be useful but also
#a crutch.  

execute 'extract java tarball' do
	command 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
	cwd '/tmp'
	not_if { File.exists?("/opt/tomcat/lib/catalina.jar")}
end

#Update the Permissions
#
#$ sudo chgrp -R tomcat /opt/tomcat
#$ sudo chmod -R g+r conf
#$ sudo chmod g+x conf
#$ sudo chown -R tomcat webapps/ work/ temp/ logs/

#used the execute resource instead of the directory resource since it will not recusively do permissions. In a strict environment, I can see using directory and explicitly writing out the permissions.Guard checks to make sure tomcat is group owner. 
execute 'update permissions' do
	command 'chgrp -R tomcat /opt/tomcat;chmod -R g+r conf;chmod g+x conf;chown -R tomcat webapps/ work/ temp/ logs/;'
	cwd '/opt/tomcat'
	not_if 'ls -l /opt/tomcat |grep tomcat', :group => 'tomcat'
end 

#Install the Systemd Unit File
#
#$ sudo vi /etc/systemd/system/tomcat.service

file '/etc/systemd/system/tomcat.service' do
	content '# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment=\'CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC\'
Environment=\'JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom\'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target'
end
