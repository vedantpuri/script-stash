# Reformulate
A simple script to automatically update the `url`, `version` and `sha256` of your HomeBrew tap formula file to keep it consistent with your latest package release.

## Requirements
- macOS or Linux
- Bash >= **3.2** (lower versions untested)
- git >= **2.18**

## Assumptions
- There exists a **public** GitHub repository for your package
- There exists a **public** GitHub repository for your homebrew-tap

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
