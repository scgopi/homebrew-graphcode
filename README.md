# homebrew-graphcode

Homebrew tap for [GraphCode](https://github.com/scgopi/GraphCode) — graphs of live,
steerable Claude Code sessions on macOS.

```sh
brew install --cask scgopi/graphcode/graphcode
```

The long name adds this tap by itself; `brew tap scgopi/graphcode` first is equivalent and
makes later commands just `graphcode`.

That downloads the signed, notarized release DMG, puts **GraphCode** in `/Applications`,
and links the `graphcode` CLI onto your `PATH`. Launch the app once: it installs
`graphcoded` and `zmx` into `~/.graphcode/bin` and loads the launchd agent that keeps the
daemon running.

Homebrew 6 warns that a third-party tap is untrusted — a gate on taps in general, not a
finding about this one. `brew trust --tap scgopi/graphcode` settles it, and gets ahead of
the release that stops making it optional. (`brew trust` is Homebrew 6+; older versions
don't check at all.)

Requires **macOS 15+ on Apple Silicon**, with **Claude Code on your `PATH`** — GraphCode
launches it, it doesn't bundle it.

Already installed GraphCode by hand from the DMG? Homebrew won't overwrite an app it
didn't put there — add `--force` to adopt it, or drag the old copy to the Trash first.

## Upgrading

```sh
brew upgrade --cask graphcode
```

## Removing it

```sh
brew uninstall --cask graphcode        # app, CLI, daemon and its launchd agent
brew uninstall --zap --cask graphcode  # the above, plus every graph in ~/.graphcode
```

`--zap` deletes your project graphs. Plain `uninstall` leaves `~/.graphcode` alone.

## Why a tap and not homebrew-cask

The official cask repository takes only projects past its
[notability threshold](https://docs.brew.sh/Acceptable-Casks#rejected-casks)
(75 stars, or 30 forks/watchers). GraphCode isn't there yet; this tap is the
same cask, published directly. Nothing about the install differs apart from the
one-time `brew tap` — once the project clears the bar, `brew install --cask
graphcode` will work with no tap at all.

## License

The cask is [MIT](LICENSE), matching GraphCode itself.
