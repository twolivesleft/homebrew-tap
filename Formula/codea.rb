class Codea < Formula
  desc "CLI for working with Codea runtimes over MCP"
  homepage "https://github.com/twolivesleft/codea-cli"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.6/codea-cli-aarch64-apple-darwin.tar.xz"
      sha256 "db010dd9686a96dc70cf62f4ccf7f81d00ae17ae688d4d7ad05070ecaf4456be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.6/codea-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a55c9960904516108c8099425df4cb88db9f47a0a3e36442e62bf9715cae47d3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.6/codea-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7e1d9aefe8d4b68fcf17b6214d9f257606ec50b51e8fb35fb2e26cb3dadb2f48"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
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
