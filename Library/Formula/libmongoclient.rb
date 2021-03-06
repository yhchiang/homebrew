require 'formula'

class Libmongoclient < Formula
  homepage 'http://www.mongodb.org'
  url 'https://github.com/mongodb/mongo-cxx-driver/archive/legacy-0.0-26compat-2.6.1.tar.gz'
  sha1 'a45e66d5182ede6b3a0f5bd5e020ebeb48dbddbe'

  head 'https://github.com/mongodb/mongo-cxx-driver.git', :branch => "26compat"

  bottle do
    sha1 "794336b0ae7cc2b867954e690ac640e299d063fd" => :mavericks
    sha1 "6301b5f949e5b17b3e8d620bf17a9981cf5a6add" => :mountain_lion
    sha1 "ba48eff313704008c2bb581174b1cb7dffe866d4" => :lion
  end

  option :cxx11

  depends_on 'scons' => :build

  if build.cxx11?
    depends_on 'boost' => 'c++11'
  else
    depends_on 'boost'
  end

  def install
    ENV.cxx11 if build.cxx11?

    boost = Formula["boost"].opt_prefix

    args = [
      "--prefix=#{prefix}",
      "-j#{ENV.make_jobs}",
      "--cc=#{ENV.cc}",
      "--cxx=#{ENV.cxx}",
      "--extrapath=#{boost}",
      "--full",
      "--use-system-all",
      "--sharedclient",
      # --osx-version-min is required to override --osx-version-min=10.6 added
      # by SConstruct which causes "invalid deployment target for -stdlib=libc++"
      # when using libc++
      "--osx-version-min=#{MacOS.version}",
    ]

    args << "--libc++" if MacOS.version >= :mavericks

    scons *args
  end
end
