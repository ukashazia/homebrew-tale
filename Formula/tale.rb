class Tale < Formula
  desc "Keyboard-first terminal application for Tailscale networks"
  homepage "https://github.com/ukashazia/tale"
  version "2.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ukashazia/tale/releases/download/v2.3.2/tale-aarch64-apple-darwin.tar.gz"
      sha256 "161bd02fdea15fd443b6a2710886fd49f8f9904d2eb7de7df6b13b6a48187609"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ukashazia/tale/releases/download/v2.3.2/tale-x86_64-apple-darwin.tar.gz"
      sha256 "af3df58f1b91a56cea30b89e444fcb4c008142d5f4b8e50a59e36b2c8bceba40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ukashazia/tale/releases/download/v2.3.2/tale-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "48432a71c7737295fcdd3294660fced618337379d5c0efa418958a97b8a22db3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ukashazia/tale/releases/download/v2.3.2/tale-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "90bb6e02632a551480b72def0167d717d48e110ab7c254af4b9377c154615036"
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
