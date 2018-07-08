# Scring
A simple script to generate the string version of entire script file. Created for ease of conversion of script to string while making commands for one of my other projects NLU.Preserves formatting including tabs and newlines as one would expect.

## Installation
For **macOS**, you can install from the repo directly:
```bash
curl -L -s https://github.com/vedantpuri/script-stash/raw/master/Scring/scring.sh > scring && mv scring /usr/local/bin/ && chmod 700 /usr/local/bin/scring && chmod +x /usr/local/bin/scring
```

**Linux** users may prefer replacing `/usr/local/bin/` to `~/bin/`
```bash
mkdir -p ~/bin && curl -L -s https://github.com/vedantpuri/script-stash/raw/master/Scring/scring.sh > scring && mv scring ~/bin/ && chmod 700 ~/bin/scring && chmod +x ~/bin/scring
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
 The project is available under the **MIT** License. Check out the [license ](https://github.com/vedantpuri/script-stash/blob/master/LICENSE.md) file for more information.
