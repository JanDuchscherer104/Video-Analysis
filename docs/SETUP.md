# 🧩 Setup SSH and Environment

## 1. 🔐 SSH Connection Setup

### Step 1: Connect to VPN

- Use **eduVPN** with **Split-Tunnel** mode (HM profile).
- Required to access the internal `10.x.x.x` network.

---

### Step 2: Test basic network access

```bash
ping 10.28.26.21
```

---

### Step 3: Create local alias for `goliath`

```bash
sudo sh -c 'echo "10.28.26.21 goliath" >> /etc/hosts'
ping goliath
```

---

### Step 4: Create or edit SSH config

Edit `~/.ssh/config`:

```ssh-config
Host goliath
    HostName 10.28.26.21
    User <username:{duchscherer|roess}>
    IdentityFile ~/.ssh/id_ed25519
    ForwardX11 yes
    ServerAliveInterval 60
    TCPKeepAlive yes
    IdentitiesOnly yes
```

Set correct permissions:

```bash
chmod 600 ~/.ssh/config
```

---

### Step 5: First login via password

Use the initial password provided (e.g. `bilder762`):

```bash
ssh goliath
```

After login, immediately change your password:

```bash
passwd
```

---

### Step 6: Upload SSH key to `goliath`

```bash
ssh-copy-id -i ~/.ssh/id_ed25519 <username>@goliath
```


## Python Env & Repo

After cloning the repo, update the submodules:

```bash
git submodule update --init --recursive
```

Install conda (if not installed)
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

```bash
conda create -n unitraj python=3.9
conda activate unitraj
```

Install cuda toolkit in the conda env
```bash
conda install -c "nvidia/label/cuda-12.4.1" cuda-toolkit
```

Check that the cuda toolkit has the right version (>=12.4)
```bash
nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2024 NVIDIA Corporation
Built on Thu_Mar_28_02:18:24_PDT_2024
Cuda compilation tools, release 12.4, V12.4.131
Build cuda_12.4.r12.4/compiler.34097967_0
```

You potentially need to add
```bash
export CUDA_HOME=$CONDA_PREFIX
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
```
to your `.bashrc`.

Install PyTorch, Scenarionet and UniTraj
```bash

pip3 install torch torchvision torchaudio
pip install -e src/external/scenarionet
cd src/external/UniTraj
pip install -r requirements.txt
python setup.py develop
```

Verify the installation of UniTraj via running the training script:

```bash
cd unitraj
python train.py method=autobot
```

(Not necessary, as the data should already be downloaded to ´/work/share/argoverse2/´)
Install s5cmd to download the AV2 dataset
```
conda install s5cmd -c conda-forge
```

```bash
# Choose which part of the dataset to download
export DATASET_NAME="motion-forecasting"  # Options: sensor, lidar, motion-forecasting, tbv
export TARGET_DIR="/work/share/argoverse2/$DATASET_NAME"

mkdir -p "$TARGET_DIR"

# Download dataset from public S3 bucket (no credentials needed)
s5cmd --no-sign-request cp "s3://argoverse/datasets/av2/$DATASET_NAME/*" "$TARGET_DIR/"
```

Install the AV2 devkit
```bash
pip install av2
```

Convert the AV2 dataset to ScenerioNet format
```bash
python -m scenarionet.convert_argoverse2 --database_path /work/share/argoverse2_scenarionet/av2_scenarionet --raw_data_path /work/share/argoverse2/motion-forecasting
```
