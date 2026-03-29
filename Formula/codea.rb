class Codea < Formula
  desc "CLI for working with Codea runtimes over MCP"
  homepage "https://github.com/twolivesleft/codea-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.0/codea-cli-aarch64-apple-darwin.tar.xz"
      sha256 "cda2615b00dda7006172a3af7072eda9820917bcd8afbb14dd2d6b90dbf211f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.0/codea-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a2a2cc8c8dcfc45a59e04e499974ebebb0e39a31ebb705918b4bd29e663d7af2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.0/codea-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "132978002c184680f3205ed9464338b8f3e8923c2b07e945005f1c711e568420"
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
