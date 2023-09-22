# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog],
and this project adheres to [Semantic Versioning].

## [Unreleased]

- /

## [1.2.16-rc1] - 2023-09-22

### Changed

- Upgrade dependencies


## [1.2.15] - 2023-04-04

### Changed

- Improve Testing for file_utils, image_utils and config
- Rename errors folder to exceptions folder
- Move validExtensions to constants folder in settings file
- Change logic for isValidExtension function

## [1.2.14] - 2023-04-02

### Changed

- Improve the logic

## [1.2.13] - 2023-03-30

### Added

- GitHub Action to check if the version of from pubspec.yaml
- GitHub Action for PR's
- Tests

### Changed

- Caching for install deps
- Migrate the action from marvinpinto/action-automatic-releases@latest to ncipollo/release-action@v1 for deploy releases
- README details

### Removed

- Execution of tests on ci.yaml


## [1.1.5] - 2023-03-29

### Added

- GitHub Action to deploy
- Files for testing
- Tests
- Support files with jpeg extension
- New exception: ArchNotSupportedException
- Support for Linux (and shell script for run)

### Changed

- Upgrade pdfium_bindings to 2.0.1
- NullException now is NullOrEmptyException
- simplePrint and simpleErrorPrint now only support String objects
- Rename description on pubspec.yaml

## [1.0.0-rc1] - 2023-03-28

- Initial version.

<!-- Links -->
[keep a changelog]: https://keepachangelog.com/en/1.0.0/
[semantic versioning]: https://semver.org/spec/v2.0.0.html

<!-- Versions -->
[unreleased]: https://github.com/jsilverdev/dart_image_converter/compare/v1.2.16...HEAD
[1.2.16]: https://github.com/jsilverdev/dart_image_converter/compare/v1.2.15...v1.2.16
[1.2.15]: https://github.com/jsilverdev/dart_image_converter/compare/v1.2.14...v1.2.15
[1.2.14]: https://github.com/jsilverdev/dart_image_converter/compare/v1.2.13...v1.2.14
[1.2.13]: https://github.com/jsilverdev/dart_image_converter/compare/v1.1.1..v1.2.13
[1.1.1]: https://github.com/jsilverdev/dart_image_converter/compare/v1.0.0-rc1...v1.1.1
[1.0.0-rc1]: https://github.com/jsilverdev/dart_image_converter/releases/tag/v1.0.0-rc1