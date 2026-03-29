class Codea < Formula
  desc "CLI for working with Codea runtimes over MCP"
  homepage "https://github.com/twolivesleft/codea-cli"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.3/codea-cli-aarch64-apple-darwin.tar.xz"
      sha256 "22433131c60eaac85dfd00d50148d43ff10871c0f0dbe54dbc7bb180344363ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.3/codea-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c8a90677525e38ae79dd7610994bd4e67c058742ee1d826dbd43f3b8bb96b007"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.3/codea-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a46d8572a80f8dfa4c251825e7dccf19e7f3dbc5ad2eaf1806ca27778f563309"
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
