class nodecellar {

  package { 'wget':
    ensure  => present,
  }

  exec { 'nodecellar_source':
    path    => "/usr/bin",
    command => "wget https://github.com/cloudify-cosmo/nodecellar/archive/master.tar.gz -O /tmp/master.tar.gz",
    unless  => "test -f /tmp/master.tar.gz",
    notify  => Exec['extract_nodecellar'],
  }

  exec { 'extract_nodecellar':
    path        => "/usr/bin",
    command     => "tar xzvf /tmp/master.tar.gz",
    unless      => "test -d /tmp/nodecellar-master",
    cwd         => "/tmp",
    notify      => Exec['install_nodecellar'],
  }

  exec { 'install_nodecellar':
    path        => "/usr/bin",
    command     => "npm install",
    cwd         => "/tmp/nodecellar-master",
    notify      => Exec['run_nodecellar'],
  }

  exec { 'run_nodecellar':
    path        => "/usr/bin",
    environment => ["MONGO_PORT=27017","MONGO_HOST=mongodb_host","NODECELLAR_PORT=8080"]
    command     => "/usr/bin/nohup /usr/bin/node server.js &",
    cwd         => "/tmp/nodecellar-master",
  }

}
