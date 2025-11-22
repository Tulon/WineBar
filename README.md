# Wine Bar

A Wine prefix manager for Linux with explicit support for Apple silicon Macs (think Asahi Linux).

It should work on regular x86_64 Linux systems as well. Support for generic non-Apple
arm64 systems is currently missing, though it shouldn't be hard to add - PRs are welcome!

This project is mainly written in Dart / Flutter, with some C and C++ code for auxilliary tools.

The project was inspired by another project written in Flutter / Dart called [Wine Prefix Manager](https://github.com/CrownParkComputing/wine_prefix_manager), though Wine Bar doesn't share any code with it.

Why have I created something from scratch rather than contribute to the above mentioned project? I had two goals:

1. To be able to run Windows software on my Linux-running Macbook Air M2, which is my daily driver. I didn't want to use Steam, yet I wanted a user-friendly solution.
2. To learn Dart / Flutter. Normally I am a C++ guy.

I concluded that creating something from scratch was a better way to achive the 2nd goal.

## Limitations

The only serious limitation of Wine Bar is how it handles running multiple apps simultaneously in the same Wine prefix. Perhaps I shouldn't have allowed that in the first place, but for those rare cases where you really need that, I made that possible. When you launch more than one executable in the same prefix, you'll notice some or all of the following symptoms:

1. Wine Bar will think your executable is still running when it has actually exited.
2. Force-stopping a running executable may do nothing or it may terminate all executables running in a prefix, not just the one you want to stop.

On Apple silicon Macs, these symptoms appear even when running executables in different Wine prefixes simultaneously.

The complexity here comes from the fact that the `wine` process starts the windows executable it was asked to run and then exits immediately without waiting for that windows executable to finish. That's not terribly hard to workaround with a single windows executable running, but very hard for more than one executable. Currently, I don't have plans to tackle this limitation.

## Running

On regular x86_64 Linux systems, you are good to go!

On Apple hardware, you need to install a few dependencies first:

On Debian-based distros:
```bash
sudo apt install muvm fex-emu
```

On Fedora-based distros:

```bash
sudo dnf install muvm fex-emu
```

### Running an AppImage

While AppImages can be run just by making them executable and double clicking them, pinning them to a taskbar doesn't work right in most (all?) desktop environments. The suggested solution is to use an app called [Gear Lever](https://mijorus.it/projects/gearlever/) to open and run AppImages. Install `Gear Level`, then right click an `.AppImage` file and select `Open with Gear Level`. An `.AppImage` started from `Gear Level` can be pinned to a taskbar just fine.

## Building

First, install Flutter (which also installs Dart) by following the [official instructions](https://docs.flutter.dev/install).

This project cross-compiles some C++ code targeting Windows, so we need some additional dependencies to be able to do that:

On Debian-based distros:
```bash
sudo apt-get install mingw-w64-i686-dev g++-mingw-w64-i686 binutils-mingw-w64-i686
```

On Fedora-based distros:
```bash
sudo dnf install mingw32-gcc-c++ mingw32-binutils
```

Now, we are ready to build Wine Bar itself:

```bash
cd <project_folder>
flutter pub get
flutter build linux --release
```

And we are done!

### Building an AppImage

```bash
cd <project_folder>
./packaging/scripts/build_appimage.sh <x64|arm64>
```

### Regenerating the Generated Files

```bash
cd <project_folder>
dart pub global activate rps
dart pub global activate dbus
rps generate
```

## About the Author

Checkout out my [blog](https://tulon.github.io/) if you are interested!
