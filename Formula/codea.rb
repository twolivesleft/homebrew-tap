class Codea < Formula
  desc "CLI for working with Codea runtimes over MCP"
  homepage "https://github.com/twolivesleft/codea-cli"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.5/codea-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fdcdf8c455237f4a281eb8d92a4cf067cc1788259ff34ab34af79de70835c6c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.5/codea-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2c37240e68d670f0642056f35e4d3e57a3f55a3a193ca6ca4ac13f651f6642d7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/twolivesleft/codea-cli/releases/download/v0.1.5/codea-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "46b1847781b067e6adb79cf5bccbb55fd55d349eb30d10548d71fe83b200aea0"
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
