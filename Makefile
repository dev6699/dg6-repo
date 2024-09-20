SIGN_KEY=dg6repo

.PHONY: gen-key
gen-key:
	gpg --expert --full-gen-key

.PHONY: exp-gpgkey
exp-gpgkey:
	gpg --armor --export ${SIGN_KEY} > gpgkey

.PHONY: gen-packages
gen-packages:
	cd apt-repo && dpkg-scanpackages --arch amd64 --multiversion pool/ > dists/stable/main/binary-amd64/Packages
	cat apt-repo/dists/stable/main/binary-amd64/Packages | gzip -9 > apt-repo/dists/stable/main/binary-amd64/Packages.gz

.PHONY: release
release: gen-release sign-release gen-inrelease

.PHONY: gen-release
gen-release:
	cd apt-repo/dists/stable && ../../../generate-release.sh > Release

.PHONY: sign-release
sign-release:
	cat apt-repo/dists/stable/Release | gpg --default-key ${SIGN_KEY} -abs > apt-repo/dists/stable/Release.gpg

.PHONY: gen-inrelease
gen-inrelease:
	cat apt-repo/dists/stable/Release | gpg --default-key ${SIGN_KEY} -abs --clearsign > apt-repo/dists/stable/InRelease