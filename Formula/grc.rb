require 'formula'

class Grc < Formula
  homepage 'http://github.com/sabril/homebrew-grc'
  url 'http://fossies.org/linux/privat/grc_1.5.tar.gz'
  sha1 'bcbe45992d2c4cb1d33e76aac6aa79b448124ce2'

  depends_on :python

  def install
    #TODO we should deprefixify since it's python and thus possible
    inreplace ['grc', 'grc.1'], '/etc', etc
    inreplace ['grcat', 'grcat.1'], '/usr/local', prefix
    inreplace ['grc', 'grcat'], '#! /usr/bin/python', '#!/usr/bin/env python'

    etc.install 'grc.conf'
    bin.install %w[grc grcat]
    (share+'grc').install Dir['conf.*']
    man1.install %w[grc.1 grcat.1]

    (prefix+'etc/grc.bashrc').write rc_script
  end

  def rc_script; <<-EOS.undent
    GRC=`which grc`
    if [ "$TERM" != dumb ] && [ -n "$GRC" ]
    then
        alias colourify="$GRC -es --colour=auto"
        alias configure='colourify ./configure'
        alias diff='colourify diff'
        alias make='colourify make'
        alias gcc='colourify gcc'
        alias g++='colourify g++'
        alias as='colourify as'
        alias gas='colourify gas'
        alias ld='colourify ld'
        alias netstat='colourify netstat'
        alias ping='colourify ping'
        alias traceroute='colourify /usr/sbin/traceroute'
    fi
    EOS
  end

  def caveats; <<-EOS.undent
    New shell sessions will start using GRC after you add this to your profile:
      source "`brew --prefix`/etc/grc.bashrc"
    EOS
  end
end