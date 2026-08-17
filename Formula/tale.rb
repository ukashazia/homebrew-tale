class Tale < Formula
  desc "Keyboard-first terminal application for Tailscale networks"
  homepage "https://github.com/ukashazia/tale"
  version "2.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ukashazia/tale/releases/download/v2.1.0/tale-aarch64-apple-darwin.tar.gz"
      sha256 "1e8ce219789e10ac5e1e56d1af6a5c87d068a182cbaf4affed354446715d7eb0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ukashazia/tale/releases/download/v2.1.0/tale-x86_64-apple-darwin.tar.gz"
      sha256 "916aa32a90040a1f947db8c8d45ea6e520d00cd45ac89751f268e8b8ab4eadf5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ukashazia/tale/releases/download/v2.1.0/tale-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ab715094500e9f944c01aaf3e1e515148c3436e0f3340343d72cad165dc3fdd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ukashazia/tale/releases/download/v2.1.0/tale-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5c68259e4c171ce4f08cd99cd526a53785e36756e553b0f1729be7cfbf23a97e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "tale"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tale"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tale"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tale"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
