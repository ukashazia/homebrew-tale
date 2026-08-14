class Tale < Formula
  desc "Keyboard-first terminal application for Tailscale networks"
  homepage "https://github.com/ukashazia/tale"
  version "2.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ukashazia/tale/releases/download/v2.0.8/tale-aarch64-apple-darwin.tar.gz"
      sha256 "91984fac59dcedc174cf82e9cadaae9cabd001f74333a47d91526ccb523a8ebd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ukashazia/tale/releases/download/v2.0.8/tale-x86_64-apple-darwin.tar.gz"
      sha256 "85bf250efa0a99172e4c0b09d4e7c9ebdc3c8ca27bdadf21ecc00e3874bb7ab3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ukashazia/tale/releases/download/v2.0.8/tale-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e2561d4728d63cd0675e88787179f6f4574a2fa2efea6fbb4ac6b8c8f43069f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ukashazia/tale/releases/download/v2.0.8/tale-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2962517c40e50753bbb5fceb3a150fe7f1a2ab7cde86a514ea6f185b0daad253"
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
