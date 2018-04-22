# Copyright 2016 The Rust Project Developers. See the COPYRIGHT
# file at the top-level directory of this distribution and at
# http://rust-lang.org/COPYRIGHT.
#
# Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
# http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
# <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
# option. This file may not be copied, modified, or distributed
# except according to those terms.

ifdef VERBOSE
Q :=
BOOTSTRAP_ARGS := -v
else
Q := @
BOOTSTRAP_ARGS :=
endif

ifdef EXCLUDE_CARGO
AUX_ARGS :=
else
AUX_ARGS := src/tools/cargo src/tools/cargotest
endif

BOOTSTRAP := C:/msys32/mingw32/bin/python2.7.exe C:/msys32/work/rust/src/bootstrap/bootstrap.py

all:
	$(Q)$(BOOTSTRAP) build $(BOOTSTRAP_ARGS)
	$(Q)$(BOOTSTRAP) doc $(BOOTSTRAP_ARGS)

help:
	$(Q)echo 'Welcome to the rustbuild build system!'
	$(Q)echo
	$(Q)echo This makefile is a thin veneer over the ./x.py script located
	$(Q)echo in this directory. To get the full power of the build system
	$(Q)echo you can run x.py directly.
	$(Q)echo
	$(Q)echo To learn more run \`./x.py --help\`

clean:
	$(Q)$(BOOTSTRAP) clean $(BOOTSTRAP_ARGS)

rustc-stage1:
	$(Q)$(BOOTSTRAP) build --stage 1 src/libtest $(BOOTSTRAP_ARGS)
rustc-stage2:
	$(Q)$(BOOTSTRAP) build --stage 2 src/libtest $(BOOTSTRAP_ARGS)

docs: doc
doc:
	$(Q)$(BOOTSTRAP) doc $(BOOTSTRAP_ARGS)
nomicon:
	$(Q)$(BOOTSTRAP) doc src/doc/nomicon $(BOOTSTRAP_ARGS)
book:
	$(Q)$(BOOTSTRAP) doc src/doc/book $(BOOTSTRAP_ARGS)
standalone-docs:
	$(Q)$(BOOTSTRAP) doc src/doc $(BOOTSTRAP_ARGS)
check:
	$(Q)$(BOOTSTRAP) test $(BOOTSTRAP_ARGS)
check-aux:
	$(Q)$(BOOTSTRAP) test \
		src/test/pretty \
		src/test/run-pass/pretty \
		src/test/run-fail/pretty \
		src/test/run-pass-valgrind/pretty \
		src/test/run-pass-fulldeps/pretty \
		src/test/run-fail-fulldeps/pretty \
		$(AUX_ARGS) \
		$(BOOTSTRAP_ARGS)
check-bootstrap:
	$(Q)C:/msys32/mingw32/bin/python2.7.exe C:/msys32/work/rust/src/bootstrap/bootstrap_test.py
dist:
	$(Q)$(BOOTSTRAP) dist $(BOOTSTRAP_ARGS)
distcheck:
	$(Q)$(BOOTSTRAP) dist $(BOOTSTRAP_ARGS)
	$(Q)$(BOOTSTRAP) test distcheck $(BOOTSTRAP_ARGS)
install:
	$(Q)$(BOOTSTRAP) install $(BOOTSTRAP_ARGS)
tidy:
	$(Q)$(BOOTSTRAP) test src/tools/tidy $(BOOTSTRAP_ARGS)
prepare:
	$(Q)$(BOOTSTRAP) build nonexistent/path/to/trigger/cargo/metadata

check-stage2-T-arm-linux-androideabi-H-x86_64-unknown-linux-gnu:
	$(Q)$(BOOTSTRAP) test --target arm-linux-androideabi
check-stage2-T-x86_64-unknown-linux-musl-H-x86_64-unknown-linux-gnu:
	$(Q)$(BOOTSTRAP) test --target x86_64-unknown-linux-musl

TESTS_IN_2 := src/test/run-pass src/test/compile-fail src/test/run-pass-fulldeps

appveyor-subset-1:
	$(Q)$(BOOTSTRAP) test $(TESTS_IN_2:%=--exclude %)
appveyor-subset-2:
	$(Q)$(BOOTSTRAP) test $(TESTS_IN_2)


.PHONY: dist
