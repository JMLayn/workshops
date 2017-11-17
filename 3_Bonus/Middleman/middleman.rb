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

# used File class with expand_path. looked for "return users home directory in ruby" google which led me to stackoverflow page and then me rubydoc on Method File.expand_path

ruby_home = File.expand_path("~/ruby")
directory ruby_home

#appended the ruby_home variable with file name. 
remote_file ruby_home + '/ruby-2.1.3.tar.gz' do
	source 'http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz'
	action :create
end

execute 'extract ruby tarball' do
	command 'tar -xzf ruby-2.1.3.tar.gz'
	cwd ruby_home
	not_if { File.exists?(ruby_home + "/ruby-2.1.3/configure" ) }
end
	

