---
route: "/"
---

# Mobx.dart

[MobX](https://github.com/mobxjs/mobx) for the Dart language.

> Supercharge the state-management in your Dart apps with Transparent Functional Reactive Programming (TFRP)

[![pub package](https://img.shields.io/pub/v/mobx.svg)](https://pub.dartlang.org/packages/mobx)
[![Build Status](https://travis-ci.com/mobxjs/mobx.dart.svg?branch=master)](https://travis-ci.com/mobxjs/mobx.dart)
[![Coverage Status](https://img.shields.io/codecov/c/github/mobxjs/mobx.dart/master.svg)](https://codecov.io/gh/mobxjs/mobx.dart)

[![Join the chat at https://gitter.im/mobxjs/mobx.dart](https://badges.gitter.im/mobxjs/mobx.dart.svg)](https://gitter.im/mobxjs/mobx.dart?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

<a href="https://github.com/mobxjs/mobx.dart">
    <img src="https://simpleicons.org/icons/github.svg" height="32"/>
</a>

## Introduction

MobX is a state-management library that makes it simple to connect the
reactive data of your application with the UI. This wiring is completely automatic
and feels very natural. As the application-developer, you focus purely on what reactive-data
needs to be consumed in the UI (and elsewhere) without worrying about keeping the two
in sync.

It's not really magic but it does have some smarts around what is being consumed (**observables**)
and where (**reactions**), and automatically tracks it for you. When the _observables_
change, all _reactions_ are re-run. What's interesting is that these reactions can be anything from a simple
console log, a network call to re-rendering the UI.

> MobX has been a very effective library for the JavaScript
> apps and this port to the Dart language aims to bring the same levels of productivity.

## Go deep

For a deeper coverage of MobX, do check out [MobX Quick Start Guide](https://www.packtpub.com/web-development/mobx-quick-start-guide). Although the book uses the JavaScript version of MobX, the concepts are **100% applicable** to Dart and Flutter.

[![](https://github.com/mobxjs/mobx.dart/raw/master/website/src/images/book.png)](https://www.packtpub.com/web-development/mobx-quick-start-guide)
