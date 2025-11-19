# Name of the resulting spec file. Adjust if rust2rpm uses a different name.
PACKAGE_NAME := ublk_user_id
SPECFILE := $(PACKAGE_NAME).spec
REPOSPECFILE := $(PWD)/package/$(PACKAGE_NAME).spec

CRATENAME := $(shell awk -F' *= *' '/^name *=/{gsub(/"/,""); print $$2; exit}' Cargo.toml)
CRATEVER  := $(shell awk -F' *= *' '/^version *=/{gsub(/"/,""); print $$2; exit}' Cargo.toml)
CRATEFILE := $(CRATENAME)-$(CRATEVER).crate


# Mock config (you can override on the command line: `make mockbuild MOCK_CONFIG=fedora-41-x86_64`)
MOCK_CONFIG ?= fedora-rawhide-x86_64

.PHONY: all rpm srpm mockbuild crate clean

all: rpm

# Build the crate file
$(CRATEFILE):
	cargo package --allow-dirty
	@mv target/package/$(CRATENAME)-$(CRATEVER).crate .

crate: $(CRATEFILE)

# At the moment I'm not sure how to get rust2rpm to create a useable spec file, so
# we run the tool to get the vendored file and then use a spec file under source control.
$(SPECFILE): $(CRATEFILE) $(REPOSPECFILE)
	rust2rpm -t fedora -s -V auto --path .
	@cp $(REPOSPECFILE) $@

spec: $(SPECFILE)
	@echo "Spec is up to date"

# Build binary RPM(s)
rpm: spec
	rpmbuild -ba ublk_user_id.spec \
		--define "_sourcedir $(PWD)" \
		--define "_specdir  $(PWD)" \
		--define "_builddir $(PWD)/build" \
		--define "_srcrpmdir $(PWD)/srpms" \
		--define "_rpmdir   $(PWD)/rpms"

# Build SRPM only
srpm: spec
	rpmbuild -bs ublk_user_id.spec \
		--define "_sourcedir $(PWD)" \
		--define "_specdir  $(PWD)" \
		--define "_srcrpmdir $(PWD)/srpms"

# Build in mock from the most recent SRPM
mockbuild: srpm
	mock -r $(MOCK_CONFIG) --rebuild $$(ls -1 srpms/*.src.rpm | tail -n 1)

# Clean up generated files
clean:
	rm -rf build srpms rpms
	rm -rf *.xz
	rm -f *.crate
	rm -rf vendor
	rm -f ublk_user_id.spec
