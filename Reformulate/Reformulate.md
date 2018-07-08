# Reformulate
A simple script to automatically update the `url`, `version` and `sha256` of your HomeBrew tap formula file to keep it consistent with your latest package release.

## Requirements
- macOS or Linux
- Bash >= **3.2** (lower versions untested)
- git >= **2.18**

## Assumptions
- There exists a **public** GitHub repository for your package
- There exists a **public** GitHub repository for your homebrew-tap

## Installation
For **macOS**, you can install from the repo directly:
```bash
curl -L -s https://github.com/vedantpuri/script-stash/raw/master/Reformulate/reformulate.sh > reformulate && mv reformulate /usr/local/bin/ && chmod 700 /usr/local/bin/reformulate && chmod +x /usr/local/bin/reformulate
```

**Linux** users may prefer replacing `/usr/local/bin/` to `~/bin/`
```bash
mkdir -p ~/bin && curl -L -s https://github.com/vedantpuri/script-stash/raw/master/Reformulate/reformulate.sh > reformulate && mv reformulate ~/bin/ && chmod 700 ~/bin/reformulate && chmod +x ~/bin/reformulate
```

## Usage
### Step 1
Navigate to your project.
```bash
cd ~/path/to/project
```

### Step 2
To update formula to latest release
```bash
reformulate -ff=~/path/to/formula/file
```
**Note:** Currently only absolute paths are supported

### Step 3
Commit these changes made to your homebrew-repo(tap)

### Options
- #### Formula (`-ff=|--formula-file=`)
  Specify **absolute** path to formula.rb file
- #### Version (`-v|--version`)
  Print script version
- #### Help (`-h|--help`)
  Print script usage

## License
 The project is available under the **MIT** License. Check out the [license ](https://github.com/vedantpuri/script-stash/blob/master/LICENSE.md) file for more information.
