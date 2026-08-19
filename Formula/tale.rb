class Tale < Formula
  desc "Keyboard-first terminal application for Tailscale networks"
  homepage "https://github.com/ukashazia/tale"
  version "2.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ukashazia/tale/releases/download/v2.2.0/tale-aarch64-apple-darwin.tar.gz"
      sha256 "036f2c6cb4c0cb23f189b18bda5381d4a9b6dab01eab2b77efc087bca58b164b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ukashazia/tale/releases/download/v2.2.0/tale-x86_64-apple-darwin.tar.gz"
      sha256 "a89df336f0ca0ffc0d38a8b73982497034b80e30722c7935c69f84c929a8d6f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ukashazia/tale/releases/download/v2.2.0/tale-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fed5efb9ce33bad1e9c05befa03d3356ebe06cb0d7197a0025410a4405cc3738"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ukashazia/tale/releases/download/v2.2.0/tale-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5efe32a192f2ccc2fcd407f4bbae1e26103f47fa88bd0151652eab535da78f2f"
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
