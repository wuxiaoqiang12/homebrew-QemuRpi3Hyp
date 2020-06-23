# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class QemuRpi3Hyp < Formula
  desc "This is patched qemu for booting rpi3 all cpu core to hyp mode"
  homepage "http://www.qemu.org"
  url "https://download.qemu.org/qemu-5.0.0.tar.xz"
  sha256 "2f13a92a0fa5c8b69ff0796b59b86b080bbb92ebad5d301a7724dd06b5e78cb6"
  revision 2
  head "https://git.qemu.org/git/qemu.git"

  bottle do
    sha256 "d502a1077e1adf1653a5f6a704a902885bf1db2b2dc8f8f26610d48ca6b1ba16" => :catalina
    sha256 "880d9ad2657c4db9f12871591028604a106fce0138093ec9d1cbb96038e73da6" => :mojave
    sha256 "7660efa3ec8a21441ac781229728aa364d3c63160fabd0c147a31c2b9667e448" => :high_sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "snappy"
  depends_on "vde"

  # Apply fix for qemu for booting all rpi3 cpu-core into hyp mode.
  patch do
    url "https://github.com/wuxiaoqiang12/qemu/commit/1b3e7db2e6.diff?full_index=1"
    sha256 "f126102385819524a71f5d097a8d37d97b3fe1e8941ac6705ba2f2668d20117f"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
      --enable-curses
      --enable-libssh
      --enable-vde
      --extra-cflags=-DNCURSES_WIDECHAR=1
      --enable-cocoa
      --disable-sdl
      --disable-gtk
    ]
    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test qemu-rpi3-hyp`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
