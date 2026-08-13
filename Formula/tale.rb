class Tale < Formula
  desc "Keyboard-first terminal application for Tailscale networks"
  homepage "https://github.com/ukashazia/tale"
  version "2.0.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ukashazia/tale/releases/download/v2.0.5/tale-aarch64-apple-darwin.tar.gz"
      sha256 "07e4b84f8b4d1d52aa49c6b7b5ba1e96be045decd8f4aff1bd827231ebc3aab5"
    end

    on_intel do
      url "https://github.com/ukashazia/tale/releases/download/v2.0.5/tale-x86_64-apple-darwin.tar.gz"
      sha256 "8bf985b31a91303eff96e3a4d204fe60576ee7cc05ece8dd42d60ec3f0ad26d1"
    end
  end

  def install
    target = Hardware::CPU.arm? ? "aarch64-apple-darwin" : "x86_64-apple-darwin"
    root = "tale-#{target}"

    bin.install "#{root}/tale"
    man1.install "#{root}/docs/cli/tale.1"
    bash_completion.install "#{root}/completions/tale.bash" => "tale"
    zsh_completion.install "#{root}/completions/_tale"
    fish_completion.install "#{root}/completions/tale.fish"
  end

  test do
    assert_match "tale", shell_output("#{bin}/tale --help")
  end
end
