<div align="center">
  <div align="center">
    <img src="data/icons/64.png" width="64">
  </div>
  <h1 align="center">Picker</h1>
  <div align="center">A simple color picker for elementary OS</div>
</div>

## Building and running
Download or clone the repo
```
git clone https://github.com/phoneybadger/picker.git
cd picker
```
You'll need the following dependencies
- valac
- meson
- libgtk-3-dev
- libgranite-dev

run `meson` to set up the build environment and then use `ninja` to build
```
meson build --prefix=/usr
ninja -C build
```
to install use `ninja install`, execute with 'com.github.phoneybadger.picker'
```
ninja install
com.github.phoneybadger.picker
```
