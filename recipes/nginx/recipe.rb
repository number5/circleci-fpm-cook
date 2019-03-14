class Nginx < FPM::Cookery::Recipe
  description 'a high performance web server and a reverse proxy server'

  name     'nginx'
  version  '1.14.2'
  revision 1
  homepage 'http://nginx.org/'
  source   "http://nginx.org/download/nginx-#{version}.tar.gz"
  sha256   '305f379da1d5fb5aefa79e45c829852ca6983c7cd2a79328f8e084a324cf0416'

  section 'httpd'

  build_depends 'libpcre3-dev', 'zlib1g-dev', 'libssl-dev'
  depends       'libpcre3', 'zlib1g', 'libssl1.0.0'

  provides  'nginx-full', 'nginx-common'
  replaces  'nginx-full', 'nginx-common'
  conflicts 'nginx-full', 'nginx-common'

  config_files '/etc/nginx/nginx.conf', '/etc/nginx/mime.types',
               '/var/www/nginx-default/index.html'

  def build
    # get source for headers-more module
    safesystem "wget https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz"
    safesystem "tar xzvf v0.33.tar.gz"
    configure \
      '--with-http_stub_status_module',
      '--with-http_ssl_module',
      '--with-http_gzip_static_module',
      '--with-pcre-jit',
      '--with-debug',
      '--with-http_realip_module',
      '--with-http_addition_module',
      '--with-http_gzip_static_module',
      '--with-http_v2_module',

      :prefix => prefix,

      :user => 'www-data',
      :group => 'www-data',

      :pid_path => '/var/run/nginx.pid',
      :lock_path => '/var/lock/nginx.lock',
      :conf_path => '/etc/nginx/nginx.conf',
      :http_log_path => '/var/log/nginx/access.log',
      :error_log_path => '/var/log/nginx/error.log',
      :http_proxy_temp_path => '/var/lib/nginx/proxy',
      :http_fastcgi_temp_path => '/var/lib/nginx/fastcgi',
      :http_client_body_temp_path => '/var/lib/nginx/body',
      :http_uwsgi_temp_path => '/var/lib/nginx/uwsgi',
      :http_scgi_temp_path => '/var/lib/nginx/scgi'

    make
  end

  def install
    # startup script
    (etc/'init.d').install_p(workdir/'nginx.init.d', 'nginx')

    # config files
    (etc/'nginx').install Dir['conf/*']
    (etc/'nginx').install_p(workdir/'nginx.conf')

    # default site
    (var/'www/nginx-default').install Dir['html/*']

    # server
    sbin.install Dir['objs/nginx']

    # man page
    man8.install Dir['objs/nginx.8']
    gzip_path = `which gzip`
    safesystem gzip_path.strip, man8/'nginx.8'

    # sites
    %w( sites-available sites-enabled ).map do |dir|
      (etc/'nginx'/dir).mkpath
    end 
    # support dirs
    %w( run lock log/nginx lib/nginx ).map do |dir|
      (var/dir).mkpath
    end
  end
end
