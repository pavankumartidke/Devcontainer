# Dev Container Setup

## Prerequisites

### Download and Install VsCode

- [Download](https://code.visualstudio.com/download) VsCode and install by double clicking on installer
- Open vscode and Install following extensions:
  - `WSL`
  - `Docker`
  - `Dev Container`
  - `Remote Development`

### Install WSL

1. Press 🪟 (Windows) and type `cmd` or `powershell` according to your prefference and make sure that it should `Run as administrator` .

2. Type below command
   ```
   $ wsl --install
   ```
3. While installation process it will ask for UNIX `username` and `password` so keep an eye on screen.

4. Make sure that your WSL distro version is set to 2 using this :

   ```
   $ wsl --set-default-version 2
   ```

5. After successfully installation, you can check WSL installation by typing

   ```
   $ wsl -v

   // you will see something like this
   WSL version: 2.1.5.0
   Kernel version: 5.15.146.1-2
   WSLg version: 1.0.60
   MSRDC version: 1.2.5105
   Direct3D version: 1.611.1-81528511
   DXCore version: 10.0.25131.1002-220531-1700.rs-onecore-base2-hyp
   Windows version: 10.0.22631.3737
   ```

6. Restart your WSL once
   ```
   $ wsl --shutdown
   ```

### **WSL** Now, close the current window and open new WSL terminal.

- By pressing 🪟 and typing `Terminal` and open `Terminal App` .
- Click on dropdown from the top bar and select `Ubuntu` terminal.
- Now, run the following commands...

### Install Docker Inside WSL

1. Make sure to update the packages by running the following command and remove any old conflicts
   ```
   $ sudo apt update
   $ sudo apt remove docker docker-engine docker.io containerd runc
   ```
2. Install Docker dependencies:
   ```
   $ sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
   ```
3. Add Docker’s official GPG key:
   ```
   $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   ```
4. Set up the stable repository:
   ```
   $ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```
5. Install Docker:
   ```
   $ sudo apt update
   $ sudo apt install docker-ce docker-ce-cli containerd.io -y
   ```
6. **Docker user permissions**:
   ```
   $ sudo usermod -aG docker $USER
   ```

### Update Docker Compose

1. In case of docker compse is outdated or corrupted, update it (Basically in any case, update it).

   ```
   $ sudo curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

   $ sudo chmod +x /usr/local/bin/docker-compose

   ```

2. **Reset Docker Context** : Sometimes, the Docker context can get misconfigured. Reset it to the default.
   ```
   $ docker context use default
   ```
3. **Verify docker installation** :

   ```
   $ docker -v
   $ docker-compose -v
   $ sudo systemctl status docker.service
   ```

4. Restart your WSL once again
   ```
   $ wsl --shutdown
   ```

## Let's deep dive in DevContainer setup

### Run exiisting project with devcontainer

1. Clone project in desired location and open folder in vscode
   ```
   [/mnt/{drive}/path/to/project]$ code .
   ```
   e.g. `/mnt/c/My_Projects/project-1`
2. After opening vscode, go ahead and press `f1` or `ctrl + shift + P` to open vscode's command palette.

3. Now, type `Dev Container: Rebuild amd Reopen in container` in that command palette and hit `enter`

4. Now, devcontainer building process is begin, it may ask for WSL password, so keep an eye on the logs. (To see logs, below notification area click on `(show logs)`)

5. Wait for some time until you see the starting the terminal of `backend` or `frontend` depending on what you have started.

## Customizations in devcontainer

- If you want to add vscode extensions or your preffered settings, then you can modify it according to you :

  - Open `.devcontainer` folder, (Located in project's root dir)
  - Edit `devcontainer.json` file

    ```
    "customizations": {
       "vscode": {
          "extensions": [
             ...
          ],
          "settings": {
             ...,

             "files.watcherExclude": {
                ...
             }
          }
       }
    }
    ```

  * Here, you can add or remove extensions and settings according to project environment
