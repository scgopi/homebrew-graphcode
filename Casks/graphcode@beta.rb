cask "graphcode@beta" do
  version "0.1.16-beta2"
  sha256 "83358ac237b80bb925e7bb91c091f0a5c45498c4289946f7c77e92fb92b486ff"

  # No `v` in the path: betas are tagged bare (0.1.9-beta1) while releases carry
  # the prefix (v0.1.9), which is also why `make tap-bump CHANNEL=beta` keeps a
  # per-channel tag prefix instead of hardcoding one.
  url "https://github.com/scgopi/GraphCode/releases/download/#{version}/graphcode-macos-arm64.dmg",
      verified: "github.com/scgopi/GraphCode/"
  name "GraphCode (beta)"
  desc "Graphs of live, steerable coding-agent sessions — pre-release channel"
  homepage "https://github.com/scgopi/GraphCode/"

  # `:github_latest` is what the stable cask uses and is exactly wrong here:
  # GitHub's "latest release" endpoint excludes pre-releases, so a beta cask on it
  # would never see a new beta. The block form is needed for the same reason — the
  # default `:github_releases` skips anything flagged pre-release, which is every
  # release this cask exists to track. Drafts are still skipped: they have no
  # downloadable asset.
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+[._-]beta\d*)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next unless match

        match[1]
      end
    end
  end

  # Both casks install graphcode.app and link the same `graphcode` binary, so they
  # cannot be installed side by side — the beta is a channel you switch to, not a
  # second copy you keep.
  conflicts_with cask: "scgopi/graphcode/graphcode"
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "graphcode.app"
  # The CLI the app would otherwise only place in ~/.graphcode/bin, which the README
  # asks people to add to their PATH. Linking it here means a brew install needs no
  # PATH edit; both copies come from the same build.
  binary "#{appdir}/graphcode.app/Contents/Resources/bin/graphcode"

  # graphcoded runs as a launchd agent the app writes on first launch, so uninstall has
  # to unload it and take the plist with it — Homebrew never saw either get created.
  uninstall launchctl: "dev.graphcode.graphcoded",
            quit:      "dev.graphcode.app",
            trash:     "~/Library/LaunchAgents/dev.graphcode.graphcoded.plist"

  # ~/.graphcode holds every project's graph, so it survives an uninstall and goes only
  # on an explicit zap.
  zap trash: [
    "~/.graphcode",
    "~/Library/Caches/dev.graphcode.app",
    "~/Library/HTTPStorages/dev.graphcode.app",
    "~/Library/Preferences/dev.graphcode.app.plist",
    "~/Library/Saved Application State/dev.graphcode.app.savedState",
  ]
end
