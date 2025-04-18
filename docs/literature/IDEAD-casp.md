## 🔍 **1. Project Idea & Scope**

**Goal**: Multimodal trajectory and behavior prediction
**Input**:

- Rasterized BEV (multi-camera, known poses)
- Static map (e.g., centerlines, boundaries)
- Dynamic context (agent states over past frames)
**Output**:
- Multimodal **vectorized trajectories**
- Optional: behavior class, maneuver type, textual descriptions
- Uncertainty modeling (e.g., Laplace)

---

## 🧠 **2. Core Architecture: CASPFormer (+CASPNet Backbone)**

### 📥 Input Representation

- **Static Context**: Rasterized HD map (centerlines, crossings, etc.)
  - Shape: `(H, W, 3)`, e.g., `152 × 96 × 3`
- **Dynamic Context**: Rasterized history over `T_i = 3` time steps
  - Shape: `(T_i, H, W, C)`, e.g., `3 × 152 × 96 × 7`
  - Channels: One-hot actor type, offset `(δ_u, δ_v)`, velocity components `(v_u, v_v)`

---

### 🧱 Backbone (CASPNet)

**Purpose**: Encode static + dynamic scene into **multi-scale scene encodings**

```mermaid
graph TD
A[Static Map Raster (1x RGB image)] --> B[Map Encoder: Gabor Conv + CNN]
C[Dynamic Raster Series (Ti x 7)] --> D[Trajectory Encoder: Shared CNN]
D --> E[ConvLSTM (per-pixel temporal fusion)]
B --> F[Multi-Scale Feature Pyramid]
E --> F
F --> G[Scene Encodings (multi-resolution, multi-channel)]
```

#### Key components

- **CNN Blocks**: Per-frame extraction (shared weights across Ti)
- **ConvLSTM**: Aggregates temporal info across input frames
- **Attention Block**: Applies per-pixel dilation-aware filtering (e.g., slow pedestrians vs. fast cars)
- **Skip Connections**: Enable multi-scale fusion of map and trajectory encodings

📦 **Output**: Multi-scale scene features
e.g., `F₁: 76×48×64`, `F₂: 38×24×128`, ...

---

### 🔄 Recurrent Decoder (CASPFormer)

- Uses **deformable attention** on scene encodings
- Learns:
  - **Temporal Queries** (capture trajectory time correlation)
  - **Mode Queries** (ensure diverse trajectory modes)
- Uses a **recurrent loop**:
  - Updates reference points → refines predictions iteratively
- Each mode: Predicts a sequence of `T_o = 12` steps (6s at 2 Hz)

---

## ⚙️ **3. Training Details & Losses**

### 🎯 Classification Loss (Cross Entropy)

- For mode selection `π(k)`
- Softmax over all modes
- Encourages accurate selection of best mode
- Not hard argmax; uses soft distribution based on final point distance

### 📉 Regression Loss (Laplace-based NLL)

- Predicts `(μ_{k,t}, b_{k,t})` for each mode/time
- Loss computed for **best matching mode** only
- Encourages accurate trajectory shape + uncertainty modeling

### 🧠 Entropy Loss (optional extension)

- Could regularize diversity between modes (prevent collapse)

---

## 🧪 **4. Implementation & Compute**

- **Resolution**: `152m × 96m @ 1m grid`
- **Modes**: `M = 5` trajectories per agent
- **Training**: AdamW, A100 GPU
- **Augmentation**: Rotation ±60°, Translation ±3m
- **Compute Cost**: Decoder very expensive (~60% of training)

---

## 📚 **5. Datasets Overview**

| Dataset        | Focus                    | Notes |
|----------------|---------------------------|-------|
| **nuScenes**   | Urban, HD maps, rich sensors | 1000 scenes, 6s future, full 360° |
| Argoverse 1/2  | Rich map & 3D agents         | Good for interaction modeling |
| Waymo OMD      | Large-scale, 3D trajectories | Good quality but heavy |
| Lyft Level 5   | Multimodal, behavior labels | Prototype level use |
| INTERACTION    | Complex intersection behavior | Good for challenging multi-agent scenarios |
| ETH/UCY        | Pedestrian campus scenes    | Good for social prediction |
| SDD            | Aerial crowded scenes       | Good for group interaction |
| JAAD           | Joint attention cues        | Older, not SoTA |

---

## 🧩 **6. Extensions & Considerations**

- **Replace RNN**: Consider pure attention or temporal convolutions
- **Incorporate behavior**: Add maneuver classification or behavior prediction
- **Use vectorized objects**: With GNNs (e.g., PyTorch Geometric)
- **Knowledge Graphs**: Integrate nuScenes Knowledge Graph (e.g., SemanticFormer)
- **Diffusion Models**: Consider probabilistic decoders (e.g., DiffTraj)
- **Crowd Flow**: Extend to multi-view or high-level flow estimation
- **Simulation-based RL**: Use predictions in environments like Duckietown for agent control

---

## ❌ Limitations

| Type | Limitation |
|------|------------|
| **Temporal** | Only 1s history, no long-term modeling |
| **Representation** | Rasterization loses precision; vector or hybrid better |
| **Decoder** | Very compute-heavy |
| **Static Map** | Limited to road/lane info; lacks traffic light/sign modeling |
| **Trajectory Extraction** | Requires complex post-processing (e.g., NMS, interpolation) |
