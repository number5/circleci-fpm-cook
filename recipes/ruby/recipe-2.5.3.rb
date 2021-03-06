class Ruby253 < FPM::Cookery::Recipe
  description 'The Ruby virtual machine'

  name 'ruby'
  version '1:2.5.3'
  revision 0
  homepage 'http://www.ruby-lang.org/'
  source 'https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.3.tar.gz'
  sha256 '9828d03852c37c20fa333a0264f2490f07338576734d910ee3fd538c9520846c'

  section 'interpreters'

  build_depends 'autoconf', 'libreadline6-dev', 'bison', 'zlib1g-dev',
                'libssl-dev', 'libyaml-dev'

  depends 'libffi6', 'libncurses5', 'libreadline6', 'libssl1.0.0',
          'libtinfo5', 'libyaml-0-2', 'zlib1g'

  def build
    configure :prefix => prefix, 'disable-install-doc' => true
    make
  end

  def install
    make :install, 'DESTDIR' => destdir
  end
end
