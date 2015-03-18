class Rivulet < Formula
  homepage "http://rivulet.audio/"
  url "https://github.com/rivuletaudio/rivulet/archive/v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "cfb90d17ec17c495c7b1c0265bcdf213314949ade2c2b211918c54f6e3db9b56"

  # depends_on "cmake" => :build
  depends_on "python"
  depends_on "boost-python"
  depends_on "libtorrent-rasterbar" => "--with-python"
  depends_on "flac"
  depends_on "lame"
             
  def install

    # install python dependencies into brew installed python
    system "#{HOMEBREW_PREFIX}/bin/pip2", "install", "--install-option=--prefix=#{HOMEBREW_PREFIX}", "beautifulsoup4"
    system "#{HOMEBREW_PREFIX}/bin/pip2", "install", "--install-option=--prefix=#{HOMEBREW_PREFIX}", "mock"
    system "#{HOMEBREW_PREFIX}/bin/pip2", "install", "--install-option=--prefix=#{HOMEBREW_PREFIX}", "tornado>=4.1"
    system "#{HOMEBREW_PREFIX}/bin/pip2", "install", "--install-option=--prefix=#{HOMEBREW_PREFIX}", "lxml"
    system "#{HOMEBREW_PREFIX}/bin/pip2", "install", "--install-option=--prefix=#{HOMEBREW_PREFIX}", "pyyaml"
    
    File.write("./run-osx.sh", "#!/bin/sh\nexport PATH=#{HOMEBREW_PREFIX}/bin:$PATH\nexec #{HOMEBREW_PREFIX}/bin/python2 #{prefix}/server/webserver/webserver.py")
    File.new("./run-osx.sh").chmod(0777)
    
    FileUtils.cp_r "./", "#{prefix}"
    
    if File.exist?("#{HOMEBREW_PREFIX}/bin/rivulet")
      File.unlink("#{HOMEBREW_PREFIX}/bin/rivulet")
    end
    
    File.link("#{prefix}/run-osx.sh", "#{HOMEBREW_PREFIX}/bin/rivulet")

    if File.exist?("/Applications/Rivulet.app")
      FileUtils.rmdir("/Applications/Rivulet.app")
    end
    
    File.link("#{prefix}/osx-agent/Rivulet.app", "/Applications/Rivulet.app")
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import libtorrent; libtorrent.version"
    end
  end
end
