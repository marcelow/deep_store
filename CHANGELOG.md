# CHANGELOG

## [Unreleased] unreleased
### Fixed
- Use binmode for internal streams

### Changed
- Update README

## [0.2.0] 2016-10-24
### Added
- DAO specs
- Model#finalize method to manually clean model streams
- Model#unlink to manually delete temporary files

### Fixed
- ObjectSpace model finalizer
- Capture `Aws::S3::Errors::NotFound`

### Changed
- Moved attribute methods to DeepStore::Model::Attributes

## [0.1.1] 2016-10-14
### Fixed
- Gem packaging

## [0.1.0] 2016-10-14
### Added
- Basic Model
