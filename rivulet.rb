class Rivulet < Formula
  homepage "http://rivulet.audio/"
  url "https://github.com/rivuletaudio/rivulet/archive/v0.2.0.tar.gz"
  version "0.2.0"
  sha256 "a8f6e97991825a13ab1457ba17bcaf1d8522445f46717a7e30b534429a47a167"

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
    
    if File.exist?("#{HOMEBREW_PREFIX}/bin/rivulet")
      File.unlink("#{HOMEBREW_PREFIX}/bin/rivulet")
    end
 
    if File.exist?("/Applications/Rivulet.app")
      FileUtils.rm_r("/Applications/Rivulet.app")
    end

    FileUtils.cp_r "./", "#{prefix}"
    
    File.link("#{prefix}/run-osx.sh", "#{HOMEBREW_PREFIX}/bin/rivulet")
    FileUtils.cp_r("#{prefix}/osx-agent/Rivulet.app", "/Applications/Rivulet.app")
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import libtorrent; libtorrent.version"
    end
  end
end
