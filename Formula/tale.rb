class Tale < Formula
  desc "Keyboard-first terminal application for Tailscale networks"
  homepage "https://github.com/ukashazia/tale"
  version "2.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ukashazia/tale/releases/download/v2.3.1/tale-aarch64-apple-darwin.tar.gz"
      sha256 "f9b8500cd95a342a2a7ecb2f9765f74208d6f843f9184beb0b0202145c4b5bd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ukashazia/tale/releases/download/v2.3.1/tale-x86_64-apple-darwin.tar.gz"
      sha256 "06b5254d8a1c2a509d16ce068467e61263f9038285c95154c051b4c84e288523"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ukashazia/tale/releases/download/v2.3.1/tale-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d4c152a574dd22dcd7d499b3b9e718eeeea575c3785054f8523b530ec5cdde34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ukashazia/tale/releases/download/v2.3.1/tale-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c256b50fdcab38927a57309e1e915516e4ad22a03a16e7aa9bd898e2519ccdea"
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

    bash_completion.install "completions/tale.bash" => "tale"
    zsh_completion.install "completions/_tale"
    fish_completion.install "completions/tale.fish"

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    package_manager_files = ["completions"]
    leftover_contents = Dir["*"] - doc_files - package_manager_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
