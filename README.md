# ublk_user_id

This repository serves as a packaging repository for `ublk_user_id`, a utility for managing user-space block device identifiers.  You can find pre-built packages at:
https://copr.fedorainfracloud.org/coprs/tasleson/ublk_user_id/

## Upstream Source

The actual source code for `ublk_user_id` is maintained in the upstream repository:

**https://github.com/ublk-org/libublk-rs/blob/main/utils/ublk_user_id_rs.rs**

## Purpose

This repository contains packaging files and build configurations to distribute `ublk_user_id` as an rpm, without needing to package the entire libublk-rs library.

## Building

Standard Rust build process:

```bash
make [rpm, srpm, mockbuild]
```

The compiled binary will be available at `target/release/ublk_user_id`.

## Installation

```bash
make rpm && sudo rpm -Uvh rpms/x86_64/ublk_user_id-0.1.0-0.1.0.x86_64.rpm
```

## License

See the upstream repository for license information.

## Contributing

For issues or contributions related to the core functionality of `ublk_user_id`, please submit them to the upstream repository. This repository is primarily for packaging-related changes.
