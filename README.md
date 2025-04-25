# DeepLearning & PyTorch Training Repository

## Prerequisites
- Docker installed
- Git installed

## Quick Start

1. Clone repository and prepare Docker:
```
git clone git@github.com:DimitriPlotnikov/deeplearning-notebook.git
cd deeplearning-notebook/docker
docker build . -t deeplearning-lab
```

2. Run Jupyter Lab:
```
cd deeplearning-notebook  # Return to repository root
docker run -it --rm -p 8888:8888 -v ./:/home/jovyan/work deeplearning-lab
```

3. Access Jupyter:
   a. Copy the URL with token from console output (looks like `http://localhost:8888/lab?token=xxxxxxxx`)
   b. Paste into web browser
   c. Insert token when prompted

## Notes
- All work saves to `./` (repo root) via Docker volume
- Server runs Jupyter Lab with PyTorch environment
- Token changes every launch - _always check console for current token_
