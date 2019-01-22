# Revamp

A simple script to easily allow you to change your Django project name.

## Requirements
- macOS or Linux
- Bash >= **3.2** (lower versions untested)
- Django == **2.0.2** (other versions untested)

## Installation
For **macOS**, you can install from the repo directly:
```bash
curl -s "https://api.github.com/repos/vedantpuri/script-stash/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | grep "revamp" | xargs curl -L -s -0 > revamp && mv revamp /usr/local/bin/ && chmod 700 /usr/local/bin/revamp && chmod +x /usr/local/bin/revamp
```

**Linux** users may prefer replacing `/usr/local/bin/` to `~/bin/` (requires `curl`, `sed`, `grep`, and `xargs`):
```bash
mkdir -p ~/bin && curl -s "https://api.github.com/repos/vedantpuri/script-stash/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | grep "revamp" | xargs curl -L -s -0 > revamp && mv revamp ~/bin/ && chmod 700 ~/bin/revamp && chmod +x ~/bin/revamp
```

## Usage
### Step 1
Navigate to your Django project.
```bash
cd path/to/project
```

### Step 2
```bash
revamp -c=CURRENT_PROJECT_NAME -n=NEW_PROJECT_NAME
```
**Note:** Run this from the directory where manage.py exists.

### Options
- #### Current project name (`-c=|--current-name=`)
  Specify the current name of your project
- #### New project name (`-n=|--new-name=`)
  Specify the new name of your project
- #### Version (`-v|--version`)
  Print script version
- #### Help (`-h|--help`)
  Print script usage

## License
 The script is available under the **MIT** License. Check out the [license ](https://github.com/vedantpuri/script-stash/blob/master/LICENSE.md) file for more information.
