# 🧩 Remote Access Quick‑Start (`goliath` – CVPR Lab)

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

## 🗂 Recommended Project Structure

On `goliath`:

```bash
mkdir -p ~/re
mkdir -p /work/<username>/data
mkdir -p /scratch/<username>/tmp
```

- Use `/home/...` for code
- Use `/work/` for larger or persistent data
- Use `/scratch/` for temporary, non-backed-up data

---
