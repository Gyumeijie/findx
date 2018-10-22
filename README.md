# findx [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
The `findx` is a **wrapper** of the `find` command, and extents the `find` some way for easy use.

# Install
```bash
$ npm install -g findx
```
or      

```bash
 git clone https://github.com/Gyumeijie/findx.git
 cd findx
 ./install
```

# Usage

Currently, `findx` extents the `-exec` of `find`.

```bash 
findx /path/to/find -exec 'cmd1, cmd2, cmd3;' -exec 'cmd4, cmd5;'
```
command can reference each matched file by `$1`. Use `,` to separate command, and `;` or `\;` to terminate(`;` is recommended.).
> Caveat: please use `' '` to enclose commands instead of `" "`. :exclamation::exclamation::exclamation:

For example, give `/tmp/test/find` has the following structure:

```
.
├── example10.jpg
├── example1.jpg
├── example2.jpg
├── example3.jpg
├── example4.jpg
├── example5.jpg
├── example6.jpg
├── example7.jpg
├── example8.jpg
└── example9.jpg
```
Now we want to change the suffix of these files to png, with **findx** we can do this:

```
findx /tmp/test/find -name "*.jpg" -exec 'name=${1%.*}, mv $1 ${name}.png;'
```

```
.
├── example10.png
├── example1.png
├── example2.png
├── example3.png
├── example4.png
├── example5.png
├── example6.png
├── example7.png
├── example8.png
└── example9.png
```
# Guide

Theoretically, we can use any valid shell commands inside `-exec`, but we don't recommand writing a string of commands in this way, the preferred way is to use a shell script file which includes these commands.
