################################################################
#Recipe:middleman.rb
#Author:Jason Layn
#Date:11/15/2017
#Purpose: Install middleman
#################################################################

#Update apt-get
apt_update 'daily apt update'	do
	frequency	86400
	action 		:periodic
end

# Build Ruby
#%w acts like a for-do loop in shell scripting
package %w(build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs libsqlite3-dev sqlite3) do
end
