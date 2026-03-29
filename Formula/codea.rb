class Codea < Formula
  desc "CLI for working with Codea runtimes over MCP"
  homepage "https://github.com/twolivesleft/codea-cli"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.2/codea-cli-aarch64-apple-darwin.tar.xz"
      sha256 "cfb5b1e836b83569c1ec5c0e655755465490ce814ddcb987b2f90f2939227c34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.2/codea-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fbb25329d1571c07b0e3783f0a1cb4b8ec41ec109321ed6365cb1038133f4135"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.2/codea-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "dafcd90c1f8afd53928b1a26628ffcbb1b4aac60d99f1d4326d847951a13dc85"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "codea" if OS.mac? && Hardware::CPU.arm?
    bin.install "codea" if OS.mac? && Hardware::CPU.intel?
    bin.install "codea" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
