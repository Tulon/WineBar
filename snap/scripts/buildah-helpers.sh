# Running podman / buildah from inside `snapcraft pack` is possible
# but requires messing with AppArmor:
#
# For podman:
#
#     aa-exec -p unconfined podman build --security-opt apparmor=unconfined ...
#
# For buildah:
#
#     aa-exec -p unconfined buildah from --security-opt apparmor=unconfined ...
#
# However, on host systems that don't use AppArmor (like my laptop running
# Asahi Linux Fedora Remix), trying to set an AppArmor profile makes the whole
# command fail. Therefore, below we detect if the host system uses AppArmor
# and if so, adds the necessary logic to set the `unconfined` profile.

_aa_exec=()
_security_opt=()
if [[ -d /sys/kernel/security/apparmor ]]; then
    _aa_exec=(aa-exec -p unconfined)
    _security_opt=(--security-opt apparmor=unconfined)
fi

buildah_from() {
    "${_aa_exec[@]}" buildah from "${_security_opt[@]}"  "$@"
}
