# NX Software Center 
![](https://raw.githubusercontent.com/Nitrux/luv-icon-theme/master/Luv/apps/64/nx-software-center.svg)

[![Nitrux Software Center AppImage](https://github.com/Nitrux/nx-software-center/actions/workflows/build-appimage-amd64.yml/badge.svg)](https://github.com/Nitrux/nx-software-center/actions/workflows/build-appimage-amd64.yml) [![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0) [![Awesome](https://awesome.re/badge.svg)](https://awesome.re) [![Generic badge](https://img.shields.io/badge/OS-Linux-blue.svg)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/Release-1.0.0-blue.svg)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/Framework-MauiKit-green.svg)](https://shields.io/)


_A graphical front end to manage [AppImage](https://appimage.org/) applications built using [MauiKit](https://mauikit.org/)._

The AppImages displayed are fetched from:
* https://www.appimagehub.com/

# Screenshots

![Screenshot_20210922_003304](https://user-images.githubusercontent.com/3053525/134288548-a8cdb968-51ca-4b75-a192-72f1be9158be.png)

 # Download

 The NX Software Center is available as an AppImage. Click the button below to download it or head over to the _Releases_ tab.

 [![appimage-button](https://github.com/UriHerrera/appimage-buttons/blob/main/buttons/appimage-btn-dark.svg)](https://github.com/Nitrux/nx-software-center/releases)

# Build

### Requirements

#### Debian/Ubuntu

```
libkf5config-dev
libkf5coreaddons-dev
libkf5i18n-dev
libkf5kio-dev
libkf5notifications-dev
libkf5service-dev
libqt5svg5-dev
libqt5webview5-dev
libqt5xmlpatterns5-dev
libfuse-dev
libappimage-dev
mauikit
mauikit-accounts
mauikit-filebrowsing
qtbase5-dev
qtdeclarative5-dev
qtquickcontrols2-5-dev
qtwebengine5-dev
```

### Compile source
 1. `git clone https://github.com/Nitrux/nx-software-center.git` 
 2. `mkdir build`
 3. `cd build`
 4. `cmake ../nx-software-center -DCMAKE_BUILD_PREFIX=Release -DCMAKE_INSTALL_PREFIX=/usr`
 5. `make`

 ### Install
 1. `make install`

# Issues
If you find problems with the contents of this repository please create an issue.

©2021 Nitrux Latinoamericana S.C.
