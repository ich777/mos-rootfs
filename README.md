# MOS rootfs

MOS rootfs provides the **root filesystem image** used by MOS.

This repository contains the **build scripts, packaging logic, and configuration**
required to assemble a MOS root filesystem from prebuilt and packaged components.

---

## Overview

The root filesystem image bundles core system components, services, and tools
required for a functional MOS installation.

The resulting image includes software built and packaged by other MOS repositories
as well as third-party open-source software.

No functional changes to upstream software are intended.  
This repository focuses solely on **assembling and structuring the root filesystem**.

---

## Contents

The generated root filesystem may include, among others:

- Core system packages
- Container and virtualization components
- Storage and networking tools
- MOS services and utilities

Detailed information about third-party software and licenses can be found in
`THIRD_PARTY.md`.

---

## Third-Party Software

This repository builds and packages third-party open-source software.
Packaged components remain licensed under their original upstream licenses.

Refer to `THIRD_PARTY.md` for details.
