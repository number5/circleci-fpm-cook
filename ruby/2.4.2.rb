class Ruby242 < FPM::Cookery::Recipe
  description 'The Ruby virtual machine'

  name 'ruby'
  version '1:2.4.2'
  revision 0
  homepage 'http://www.ruby-lang.org/'
  source 'https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz'
  sha256 '93b9e75e00b262bc4def6b26b7ae8717efc252c47154abb7392e54357e6c8c9c'

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
