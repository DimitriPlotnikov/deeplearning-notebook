# DeepLearning & PyTorch Training Repository

## Prerequisites
- Docker or Podman installed
- Git installed

## Quick Start

1. Clone repository and prepare Docker:
```
git clone https://github.com/DimitriPlotnikov/deeplearning-notebook.git
cd deeplearning-notebook/docker
docker build . -t deeplearning-lab
# Or with Podman:
podman build . -t deeplearning-lab
```

Known issues with WSL and Docker:
* If the mount is read-only try to run the following command in your wsl:
```
sudo chmod -R a+rw /path-to-your-repo/deeplearning-notebook
```

2. Run Jupyter Lab:

The `--userns=keep-id` flag with your host UID/GID ensures proper file permissions between the container and host system. This is particularly important for systems with SELinux enforcement, as it maintains consistent user identity mapping between host and container environments.

Alternative fixed UID/GID format (replace 1000/100 with your actual IDs):

```
cd /path-to-your-repo/deeplearning-notebook  # Return to repository root (deeplearning-notebook)
docker run --userns=keep-id:uid=$(id -u),gid=$(id -g) -it --rm -p 8888:8888 -v $(pwd):/home/jovyan/work deeplearning-lab
# Or with Podman:
podman run --userns=keep-id:uid=$(id -u),gid=$(id -g) -it --rm -p 8888:8888 -v $(pwd):/home/jovyan/work deeplearning-lab
```

3. Access Jupyter:
   a. Copy the URL with token from console output (looks like `http://localhost:8888/lab?token=xxxxxxxx`)
```
docker run -it --rm -p 8888:8888 -v ./:/home/jovyan/work deeplearning-lab
-------
Entered start.sh with args: start-notebook.py
Running hooks in: /usr/local/bin/start-notebook.d as uid: 1000 gid: 100
Done running hooks in: /usr/local/bin/start-notebook.d
Running hooks in: /usr/local/bin/before-notebook.d as uid: 1000 gid: 100
Sourcing shell script: /usr/local/bin/before-notebook.d/10activate-conda-env.sh
Done running hooks in: /usr/local/bin/before-notebook.d
Executing the command: start-notebook.py
Executing: jupyter lab
[I 2025-04-29 19:19:32.616 ServerApp] jupyter_lsp | extension was successfully linked.
[I 2025-04-29 19:19:32.618 ServerApp] jupyter_server_mathjax | extension was successfully linked.
[I 2025-04-29 19:19:32.621 ServerApp] jupyter_server_terminals | extension was successfully linked.
[I 2025-04-29 19:19:32.624 ServerApp] jupyterlab | extension was successfully linked.
[I 2025-04-29 19:19:32.624 ServerApp] jupyterlab_git | extension was successfully linked.
[I 2025-04-29 19:19:32.627 ServerApp] nbclassic | extension was successfully linked.
[I 2025-04-29 19:19:32.628 ServerApp] nbdime | extension was successfully linked.
[I 2025-04-29 19:19:32.630 ServerApp] notebook | extension was successfully linked.
[I 2025-04-29 19:19:32.632 ServerApp] Writing Jupyter server cookie secret to /home/jovyan/.local/share/jupyter/runtime/jupyter_cookie_secret
[I 2025-04-29 19:19:32.919 ServerApp] notebook_shim | extension was successfully linked.
[W 2025-04-29 19:19:32.943 ServerApp] WARNING: The Jupyter server is listening on all IP addresses and not using encryption. This is not recommended.
[I 2025-04-29 19:19:32.943 ServerApp] notebook_shim | extension was successfully loaded.
[I 2025-04-29 19:19:32.945 ServerApp] jupyter_lsp | extension was successfully loaded.
[I 2025-04-29 19:19:32.945 ServerApp] jupyter_server_mathjax | extension was successfully loaded.
[I 2025-04-29 19:19:32.946 ServerApp] jupyter_server_terminals | extension was successfully loaded.
[I 2025-04-29 19:19:32.954 LabApp] JupyterLab extension loaded from /opt/conda/lib/python3.12/site-packages/jupyterlab
[I 2025-04-29 19:19:32.954 LabApp] JupyterLab application directory is /opt/conda/share/jupyter/lab
[I 2025-04-29 19:19:32.954 LabApp] Extension Manager is 'pypi'.
[I 2025-04-29 19:19:33.030 ServerApp] jupyterlab | extension was successfully loaded.
[I 2025-04-29 19:19:33.033 ServerApp] jupyterlab_git | extension was successfully loaded.

  _   _          _      _
 | | | |_ __  __| |__ _| |_ ___
 | |_| | '_ \/ _` / _` |  _/ -_)
  \___/| .__/\__,_\__,_|\__\___|
       |_|

Read the migration plan to Notebook 7 to learn about the new features and the actions to take if you are using extensions.

https://jupyter-notebook.readthedocs.io/en/latest/migrate_to_notebook7.html

Please note that updating to Notebook 7 might break some of your extensions.

[I 2025-04-29 19:19:33.041 ServerApp] nbclassic | extension was successfully loaded.
[I 2025-04-29 19:19:33.120 ServerApp] nbdime | extension was successfully loaded.
[I 2025-04-29 19:19:33.122 ServerApp] notebook | extension was successfully loaded.
[I 2025-04-29 19:19:33.123 ServerApp] Serving notebooks from local directory: /home/jovyan
[I 2025-04-29 19:19:33.123 ServerApp] Jupyter Server 2.15.0 is running at:
[I 2025-04-29 19:19:33.123 ServerApp] http://localhost:8888/lab?token=f4ac32cafbc84f2289f385e96e870db0c98c626460c32aae
[I 2025-04-29 19:19:33.123 ServerApp]     http://127.0.0.1:8888/lab?token=f4ac32cafbc84f2289f385e96e870db0c98c626460c32aae
[I 2025-04-29 19:19:33.123 ServerApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 2025-04-29 19:19:33.125 ServerApp]

    To access the server, open this file in a browser:
        file:///home/jovyan/.local/share/jupyter/runtime/jpserver-7-open.html
    Or copy and paste one of these URLs:
        http://localhost:8888/lab?token=f4ac32cafbc84f2289f385e96e870db0c98c626460c32aae
        http://127.0.0.1:8888/lab?token=f4ac32cafbc84f2289f385e96e870db0c98c626460c32aae
```
   b. Paste into web browser
   c. Insert token when prompted

## Notes
- All work saves to `./` (repo root) via Docker volume
- Server runs Jupyter Lab with PyTorch environment
- Token changes every launch - _always check console for current token_
