SHELL := /usr/bin/env bash

all:
	@echo >&2 "Only 'make check' allowed"

include syntax.mk

SHELL_SCRIPTS = \
	build.sh \
	clean.sh \
	generate.sh \
	tag.sh \
	test-lib-openshift.sh \
	test-lib.sh \
	test.sh \
	update-generated.sh

TESTED_IMAGES = \
	postgresql-container \
	s2i-python-container

.PHONY: check test all check-failures


TEST_LIB_TESTS = \
	path_foreach \
	random_string

$(TEST_LIB_TESTS):
	@echo "  RUN TEST '$@'" ; \
	$(SHELL) tests/test-lib/$@ || $(SHELL) -x tests/lib/$@

test-lib-foreach:

check-test-lib: $(TEST_LIB_TESTS)

test: check

check-failures: check-test-lib
	cd tests/failures/check && make tag && ! make check && make clean

check: check-failures
	TESTED_IMAGES="$(TESTED_IMAGES)" tests/remote-containers.sh
