notice("Set server ip to: $theserverip")
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# setup apt module
class { 'apt':
  always_apt_update    => false,
  disable_keys         => undef,
  proxy_host           => false,
  proxy_port           => '8080',
  purge_sources_list   => false,
  purge_sources_list_d => false,
  purge_preferences_d  => false
}

exec { "apt-get-update":
  command => "apt-get update",
  provider => shell,
}

package { 'git':
        ensure => installed,
}

vcsrepo { "/usr/src/mibserver":
  provider => git,
  source => 'https://github.com/vkoop/mib-server.git',
  revision => 'master',
  ensure => latest,
  require => Package['git'],
}


$qrdeps = [ "build-essential", "pkg-config", "libcairo2-dev", "imagemagick", "nodejs"]

apt::ppa { "ppa:chris-lea/node.js": }
->
package { $qrdeps: ensure => "installed",
  require => Exec['apt-get-update']
}
->
exec { "install npm deps": 
  command => "cd /usr/src/mibserver; npm install;",
  provider => shell,
  require => Vcsrepo['/usr/src/mibserver'],
}

file{"/etc/init/mibserver.conf":
  ensure => "present",
  owner => "root",
  group => "root",
  mode  => 770,
  content => template("/tmp/vagrant-puppet/templates/mibserver.upstart.conf.erb"),
  replace => true,
}

file{"/etc/profile.d/envsetup.sh":
  content => "
export SERVER_IP=${theserverip}
",
  replace => true
}


exec { "install coffeescript":
  command => "npm -g install coffee-script;",
  provider => shell,
  require => Exec['install npm deps']
}
->
service { 'mibserver':
  ensure => running,
  enable => true,
  subscribe => [
    File["/etc/init/mibserver.conf"],
  ]
}
