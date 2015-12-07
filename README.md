# atomic-toolbox

An experiment based on the CoreOS toolbox script.

Differently than CoreOS, make the host rootfs accessible at '/',
instead of '/host'.

Poorly tested, it may break.

The idea is that given a rpm-ostree configuration file as:

emacs.json:
```json
{
    "ref": "fedora-atomic/f22/x86_64/emacs",
    "repos": ["fedora-22"],
    "container": true,
    "packages": ["emacs"]
}
```

it is possible to run:

```
atomic-toolbox.sh --install fedora-atomic fedora-atomic/f22/x86_64/emacs
```

and

```
atomic-toolbox.sh fedora-atomic/f23/x86_64/emacs emacs a_file_in_the_current_directory.c
```

to be able to access a file in the local directory on the host through Emacs.
