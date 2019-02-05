# CI scripts for GAP packages

This repository contains scripts which GAP package can use to implement
continuous integration test with e.g. Travis CI.

These scripts are normally placed in subdirectory `scripts` or `etc` in
the package. Examples for suitable `.travis.yml` and `.codecov.yml` files
can be found in the `examples` branch of this repository.


## Initial setup

TODO: explain how to use the code into the repository;
and then how to setup Travis (this probably should also cover how to enable
Travis CI integration on their website for packages which are not hosted
in the `gap-packages` github organization)


## Upgrading to a newer version

TODO: decide how to do this: use subtree merges? Or perhaps we should remove those
`scripts` dirs, and instead each `.travis.yml` should start with

    git clone https://github.com/gap-system/pkg-ci-scripts.git scripts


## FAQ

### Q: How can I ensure other required GAP packages get compiled?

A: Set the `GAP_PKGS_TO_BUILD` environment variable before running
`build_gap.sh` to a string listing the (start of the) directory names of
the packages you need compiled. Make sure to always include `io` and
`profiling` in this list, as these are needed for generating code
coverage.

Example: If you need the `cvec` package, you can add this in a
suitable place in your `.travis.yml`:

    GAP_PKGS_TO_BUILD="io profiling cvec"

Then this will compile all packages whose package directory name starts with
"io", "profiling" or "cvec". This "starts with" rule is intended to support
packages where the directory name contains the version.


### Q: How can I enable (or disable) code coverage reporting?

TODO: mention `.codecov.yml` (perhaps also Coveralls); also `NO_COVERAGE`


## Contact

Please submit bug reports, suggestions for improvements and patches via
the [issue tracker](https://github.com/pkg-ci-scripts/ReleaseTools/issues).


## Copyright and license

Copyright (C) 2017-2019 Max Horn
Copyright (C) 2017-2019 The GAP Team

This code is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

For details see the file COPYING.
