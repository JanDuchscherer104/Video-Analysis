# Video-Analysis

- [Resources](/RESOURCES.md)
- [Jan's Notes](https://drive.google.com/drive/folders/1pCqvKy3jx0FrvmH9EIDcMBJo3a7-Q1kw?usp=share_link)

## Getting Started

### Dependencies

<!-- #### nuScenes-devkit

```bash
conda create -n nuscenes python=3.9
conda activate nuscenes

# Tested on python<=3.7
pip install nuscenes-devkit
``` -->
#### Argoverse V2

##### Argoverse2 API

Instructions can be found [here](https://argoverse.github.io/user-guide/getting_started.html).

```bash
cd external
git submodule add git@github.com:argoverse/av2-api.git

cd av2-api
bash conda/install.sh && conda activate av2
```

##### Downloading the Data

```bash
conda install s5cmd -c conda-forge
```
