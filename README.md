# Wine Bar

A Wine prefix manager for Linux with explicit support for Apple silicon Macs (think Asahi Linux).

It should work on regular x86_64 Linux systems as well. Support for generic non-Apple
arm64 systems is currently missing, though it shouldn't be hard to add - PRs are welcome!

This project is mainly written in Dart / Flutter, with some C and C++ code for auxilliary tools.

The project was inspired by another project written in Flutter / Dart called [Wine Prefix Manager](https://github.com/CrownParkComputing/wine_prefix_manager), though it doesn't share any code with it.

Why have I created something from scratch rather than contribute to the above mentioned project? I had two goals:

1. To be able to run Windows software on my Linux-running Macbook Air M2, which is my daily driver. I didn't want to use Steam, yet I wanted a user-friendly solution.
2. To learn Dart / Flutter. Normally I am a C++ guy.

Creating something from scratch is a better way to achive the 2nd point.

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

## Building

First, install Flutter (which also installs Dart) by following the [official instructions](https://docs.flutter.dev/install).

This project cross-compiles some C++ code targeting Windows, so we need some additional dependencies to be able to do that:

On Debian-based distros:
```bash
sudo apt-get install mingw32
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

## About the Author

Checkout out my [blog](https://tulon.github.io/) if you are interested!
