# ![pkg](https://github.com/leoafarias/pkg/blob/main/assets/pkg-logo.png?raw=true)

<!-- ![GitHub stars](https://img.shields.io/github/stars/leoafarias/pkg?style=social) -->

[![Pub Version](https://img.shields.io/pub/v/pkg?label=version&style=flat-square)](https://pub.dev/packages/pkg/changelog)
[![Health](https://img.shields.io/badge/dynamic/json?color=blue&label=health&query=pub_points&url=http://www.pubscore.gq/pub-points?package=pkg&style=flat-square&cacheSeconds=90000)](https://pub.dev/packages/pkg/score) ![Coverage](https://raw.githubusercontent.com/leoafarias/pkg/main/assets/coverage_badge.svg?sanitize=true) [![MIT Licence](https://img.shields.io/github/license/leoafarias/pkg?style=flat-square&longCache=true)](https://opensource.org/licenses/mit-license.php)

Enhanced pub package commands.

- Add latest resolvable package
- Remove dependency
- View package info
- Improved conflict resolution (soon)
- View unused dependencies (soon)

# Installation

```bash
pub activate global pkg
```

# Usage

## Add

Easily add packages to your pubspec. By default pkg will try to `resolve` to the latest `compatible` version of the package to add to your project.

```bash
pkg add <package>
```

## Remove

Will remove the package from your pubspec.

```bash
pkg remove <package>
```

## View

Display information about a package

```bash
pkg view <package>
```
