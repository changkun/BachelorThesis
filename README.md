# Designing Alternative Contact-free Control Modalities for Smart Watches

[![Build Status](https://travis-ci.com/changkun/BachelorThesis.svg?token=wRf5KPUizYFaNxwsZRsv&branch=master)](https://travis-ci.com/changkun/BachelorThesis)

English | [中文](./README-cn.md)

This repository contains my bachelor thesis: source code, thesis paper and other related files.

<a name="index"/>
## Contents
* [Setup](#setup)
* [Files](#files)
* [Demo](#demo)
* [External Projects](#external)
* [License](#license)

<a name="setup"/>
## Setup

It's refer to two parts of this project:

1. **Client Side**：iOS & WatchOS for data communication and interaction present；
  - Client side built method see: [Client README](./client/README.md)
2. **Server Side**：Data analysis and exchange, gesture recognize.
  - Server side built method see: [Server README](./server/README.md)

<a name="files"/>
## Files

* [client](./client) 
  - This folder contains the client software  of watch and phone side, implemented by Swift 2.2;
* [docs](./desktop) 
  - This folder contains related files in this project, include applying doc, architecture source file, advisor comments and etc.
* [experiment](./experiment) 
  - This folder contains the related user study file, such as questionnaire, analysis source code and etc.
* [paper](./paper) 
  - This folder contains the thesis paper and its LaTeX source file;
* [server](./server) 
  - This folder contains server side Leap-enabled software, implemented by NodeJS.

<a name="demo"/>
## Demo

* [YouTube](https://www.youtube.com/watch?v=ef2pKK6b0UA&list=PLwUqqMt5en7c2QaQ_DkuvZm9dGTz6RjRM):

[![ScreenShot](http://img.youtube.com/vi/ef2pKK6b0UA/0.jpg)](https://youtu.be/ef2pKK6b0UA)

<a name="external"/>
## External Projects


* [SWUNThesis](https://github.com/changkun/SWUNThesis): LaTeX Thesis Template for Southwest University for Nationalities
* [LeapDocCN](https://github.com/changkun/LeapDocCN): LeapMotion SDK Offical Documentation Chinese Translation

<a name="license"/>
## License

The work in this repository (except paper and code)is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

All code is licensed under a [GNU Public Licence v3](./LICENSE).

The [Thesis Paper CN](./paper/main-cn.pdf) and [Thesis Paper EN](./paper/main-en.pdf) contents (include [release contents](./paper/release/)) are Copyright © 2016 Ou, Changkun. All rights reserved.