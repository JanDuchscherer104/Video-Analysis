# Video-Analysis

- [Resources](/RESOURCES.md): Overview of all considered approaches and resources like datasets, code, and papers.
- [Setup](/SETUP.md): Instructions for setting up the remote device.
- [Project Idea & Scope](/IDEAD.md): Project idea based on the CASPFormer architecture.
- [Questions](/QUESTIONS.md)

- [LM-Former Summary](/lm-former.md)
- [Ideas on SmolLM-Former](literature/smol-lm-former.md)

- [Jan's Notes (Google-Drive)](https://drive.google.com/drive/folders/1pCqvKy3jx0FrvmH9EIDcMBJo3a7-Q1kw?usp=share_link): handwritten notes and papers

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

#### Own Modules

```bash
cd src
pip install -e utils
```
