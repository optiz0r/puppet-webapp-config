
define webapp_config ($action='install', $vhost, $base='/', $app, $version, $depends, $installdir=undef) {

    $_installdir = $installdir ? {
        undef   => "/var/www/${vhost}",
        default => $installdir,
    }
        
    case $action {
        "install":  { $cmd    = "webapp-config -I -h $vhost -d $base $app $version"
                      $unless = "test -f ${_installdir}/htdocs$base.webapp-$app-$version"
                    }
        "remove" :  { $cmd    = "webapp-config -C -h $vhost -d $base $app $version"
                      $unless = "$(! test -f ${_installdir}/htdocs$base.webapp-$app-$version)"
                    }
        default:    { alert( "webapp-config: Action '$action' is invalid" ) } 
    }
       
    exec { "webapp-${action}-${app}-${vhost}${base}":
        command => $cmd,
        path    => [ "/usr/bin", "/usr/sbin" ],
        unless  => $unless,
        require => $depends,
    }
}
                        
