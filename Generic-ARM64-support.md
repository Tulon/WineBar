#### Does WineBar support non-Apple ARM64 hardware?

The short answer is no, even though siginficant effort was put to make that happen. For the long answer, keep reading below.

#### How does it work on Apple ARM64 hardware?

On Apple ARM64 hardware, we run `muvm`, which is a lightweight virtual machine. Its main purpose is to run a 4K-page kernel in a virtualized environment, but among other things, it also registers FEX-EMU as a binfmt_misc handler, which is something that otherwise would require root permissions.

Registring FEX-EMU as a binfmt_misc handler allows us to run a mixture of ARM64 and X86 / X86_64 processes. For instance, we can run an ARM64 process that in turn executes an X86_64 one (think the wine executable).

#### Can we do exactly the same thing on non-Apple ARM64 hardware?

In theory we could. I don't know if `muvm` is tied to Apple hardware or Asahi Linux environment in any way, but let's assume it's not. The next problem is that `muvm` requires access to `/dev/kvm`, which is usually missing on ARM64 devices, because distros tend not to enable that option in the kernel config.

Will it work if `/dev/kvm` is available? I don't know - you tell me. The Snap version of WineBar will try to use `muvm` on ARM64 hardware where `/dev/kvm` is available.

#### Can we run FEX-EMU without muvm?

In a Snap confined environment, we can't. There is a long list of obstacles preventing that. Some of them can be worked around, others can't. Here are the major ones:

1. In a Snap confined environment, it's impossible to register FEX-EMU as a binfmt_misc handler.
2. FEX-EMU makes use of the `openat2()` system call, which doesn't work in a Snap confined environment.
3. It's not possible to do unprivileged mounts in a Snap confined environment.

#### What about the AppImage version of WineBar?

That one may work, if FEX-EMU is provided by the system (including its rootfs) and if it's installed systemwide as a binfmt_misc handler.

#### What about the FEX-enabled ARM64 builds of Wine?

These should work in theory, though WineBar doesn't support them currently. The main reason is that no one seems to have bothered to provide such builds in a way that would be easy for WineBar or other launchers to consume.