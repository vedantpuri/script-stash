# Scring
A simple script to generate the string version of entire script file. Preserves formatting including tabs and newlines as one would expect.

## Requirements
- macOS or Linux
- Bash >= **3.2** (lower versions untested)

## Installation
For **macOS**, you can install from the repo directly:
```bash
curl -s "https://api.github.com/repos/vedantpuri/script-stash/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | xargs curl -L -s -0 > scring && mv scring /usr/local/bin/ && chmod 700 /usr/local/bin/scring && chmod +x /usr/local/bin/scring
```

**Linux** users may prefer replacing `/usr/local/bin/` to `~/bin/` (requires `curl`, `sed`, `grep`, and `xargs`):
```bash
mkdir -p ~/bin && curl -s "https://api.github.com/repos/vedantpuri/script-stash/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | xargs curl -L -s -0 > scring && mv scring ~/bin/ && chmod 700 ~/bin/scring && chmod +x ~/bin/scring
```

## Usage
**Note:** Of all the options used, make sure that the one specifying the path is mentioned last.

E.g.
```bash
scring -a="path/to/target/script/script_name"
```
**OR**

```bash
cd /path/to/target/script
scring -r="script_name"
```

### Options
- #### Relative Path (`-r=|--relative=`)
  Provide relative path to script from `pwd`
- #### Absolute Path (`-a=|--absolute=`)
  Provide absolute path to script
- #### Test String (`-t|--test`)
  Preview the created string with proper formatting
- ####  Ignore Sub-String (`-i=|--ignore=`)
  Ignore lines containing a specific substring
- #### Version (`-v|--version`)
  Print script version
- #### Help (`-h|--help`)
  Print script usage

## License
 The script is available under the **MIT** License. Check out the [license ](https://github.com/vedantpuri/script-stash/blob/master/LICENSE.md) file for more information.
