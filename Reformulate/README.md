![Header](../.resources/reformulate_hero.png)

A simple script to fetch your latest HomeBrew package release and automatically update the `url`, `version` and `sha256` of your HomeBrew formula file.

## Requirements
- macOS or Linux
- Bash >= **3.2** (lower versions untested)
- git >= **2.18**

## Assumptions
- There exists a **public** GitHub repository for your package
- The url used in your formula is of the type `https://github.com/*username*/*repo-name*/archive/*tag-name*.tar.gz`

## Installation
For **macOS**, you can install from the repo directly:
```bash
curl -s "https://api.github.com/repos/vedantpuri/script-stash/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | xargs curl -L -s -0 > reformulate && mv reformulate /usr/local/bin/ && chmod 700 /usr/local/bin/reformulate && chmod +x /usr/local/bin/reformulate
```

**Linux** users may prefer replacing `/usr/local/bin/` to `~/bin/` (requires `curl`, `sed`, `grep`, and `xargs`):
```bash
mkdir -p ~/bin && curl -s "https://api.github.com/repos/vedantpuri/script-stash/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | xargs curl -L -s -0 > reformulate && mv reformulate ~/bin/ && chmod 700 ~/bin/reformulate && chmod +x ~/bin/reformulate
```

## Usage
### Step 1
Navigate to the root of your homebrew-tap repo(where your formula exists).
```bash
cd ~/path/to/tap
```

### Step 2
To update formula to latest release
```bash
reformulate -ff=/path/to/formula/file
```

**Note:** Run this from the root of the repo. Relative path supported.

### Step 3
Commit these changes made to your homebrew-tap repo.

### Options
- #### Formula (`-ff=|--formula-file=`)
  Specify path to formula.rb file
- #### Commit (`-c|--commit`)
  Automatically commit the changes to master branch
- #### Version (`-v|--version`)
  Print script version
- #### Help (`-h|--help`)
  Print script usage

One could also setup this script as a [**launchd**](http://www.launchd.info) or a [**cron**](https://en.wikipedia.org/wiki/Cron) job to perform a periodic check and update.

## License
 The script is available under the **MIT** License. Check out the [license ](https://github.com/vedantpuri/script-stash/blob/master/LICENSE.md) file for more information.
