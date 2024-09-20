VERSION=0.0.1
DIR=hello-world_$(VERSION)-1_amd64
CONTROl_FILE = $(DIR)/DEBIAN/control

.PHONY: build
build:
	mkdir -p $(DIR)/DEBIAN
	mkdir -p $(DIR)/usr/bin
	echo "Package: hello-world" > $(CONTROl_FILE); \
	echo "Version: $(VERSION)" >> $(CONTROl_FILE); \
	echo "Maintainer: dev6699 <kweijack.dev@gmail.com>" >> $(CONTROl_FILE); \
	echo "Depends: libc6" >> $(CONTROl_FILE); \
	echo "Architecture: amd64" >> $(CONTROl_FILE); \
	echo "Homepage: https://github.com/dev6699" >> $(CONTROl_FILE); \
	echo "Description: A program that prints hello" >> $(CONTROl_FILE)
	gcc -o $(DIR)/usr/bin/hello-world hello.c
	dpkg --build hello-world_$(VERSION)-1_amd64
	rm -r hello-world_$(VERSION)-1_amd64