# Creating and Hosting Your Own DEB Packages and APT Repository

This guide will walk you through the steps to create your own DEB packages and host them in a custom APT repository. This allows you to easily distribute software to Debian-based systems (like Ubuntu) in a manageable way.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Creating a DEB Package](#creating-a-deb-package)
- [Setting Up an APT Repository](#setting-up-an-apt-repository)
- [Adding Your Repository to APT Sources](#adding-your-repository-to-apt-sources)
- [Installing Packages from Your Repository](#installing-packages-from-your-repository)

## Prerequisites
- A Debian-based operating system (Ubuntu, Debian, etc.)
- `gcc`, `dpkg-dev`, `gpg` package installed:
    ```bash
    sudo apt-get install -y gcc dpkg-dev gpg
    ```

## Creating a DEB Package
- Sample app can be found in [app](app)
- To build `deb` package:
    ```bash
    cd app
    make build
    ```
    This will crete a file name `hello-world_<version>-1_amd64.deb` 

## Setting Up an APT Repository
- Initial setup:
    1. Generate GPG signing key:
        ```bash
        make gen-key
        ```

        ```
        gpg (GnuPG) 2.2.27; Copyright (C) 2021 Free Software Foundation, Inc.
        This is free software: you are free to change and redistribute it.
        There is NO WARRANTY, to the extent permitted by law.

        Please select what kind of key you want:
        (1) RSA and RSA (default)
        (2) DSA and Elgamal
        (3) DSA (sign only)
        (4) RSA (sign only)
        (7) DSA (set your own capabilities)
        (8) RSA (set your own capabilities)
        (9) ECC and ECC
        (10) ECC (sign only)
        (11) ECC (set your own capabilities)
        (13) Existing key
        (14) Existing key from card
        Your selection? 9
        Please select which elliptic curve you want:
        (1) Curve 25519
        (3) NIST P-256
        (4) NIST P-384
        (5) NIST P-521
        (6) Brainpool P-256
        (7) Brainpool P-384
        (8) Brainpool P-512
        (9) secp256k1
        Your selection? 1
        Please specify how long the key should be valid.
                0 = key does not expire
            <n>  = key expires in n days
            <n>w = key expires in n weeks
            <n>m = key expires in n months
            <n>y = key expires in n years
        Key is valid for? (0) 
        Key does not expire at all
        Is this correct? (y/N) y

        GnuPG needs to construct a user ID to identify your key.

        Real name: dg6repo
        Email address: kweijack.dev@gmail.com
        Comment: 
        You selected this USER-ID:
            "dg6repo <kweijack.dev@gmail.com>"

        Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
        ```

    2. Export gpg public key:
        ```bash
        make exp-gpgkey
        ```

- Release package:
    1. Move your `.deb` file into [apt-repo/pool/main](apt-repo/pool/main)
    2. Update repo Packages:
        ```bash
        make gen-packages
        ```
    3. Update repo Release:
        ```bash
        make release
        ```
    4. Upload the repository [apt-repo](apt-repo) and [gpgkey](gpgkey) to your server.

## Adding Your Repository to APT Sources
1. Configure Source List:
    ```bash
    # Add GPG key
    curl -fsSL https://raw.githubusercontent.com/dev6699/dg6-repo/refs/heads/master/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/dg6-repo-keyring.gpg

    # Add repo
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/dg6-repo-keyring.gpg] https://raw.githubusercontent.com/dev6699/dg6-repo/refs/heads/master/apt-repo stable main" | sudo tee /etc/apt/sources.list.d/dg6-repo.list
    ```
    *NOTE: replace `https://raw.githubusercontent.com/dev6699/dg6-repo/refs/heads/master/` with your own host*

2. Update APT:
    ```bash
    sudo apt-get update
    ```

## Installing Packages from Your Repository
```bash
sudo apt-get install hello-world
```