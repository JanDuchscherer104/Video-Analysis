
# 🧠 LMFormer: Complete Implementation & Feasibility Report

## 1. Overview

**LMFormer** is a layered trajectory prediction transformer for autonomous driving. It introduces:

- **Layer-wise trajectory refinement** over learnable motion queries
- **Cross-modal attention** to capture temporal, social, and lane contexts
- A **decoupled WTA loss** for robust multi-modal prediction
- A modular transformer backbone, scalable and interpretable

---

## 2. Architecture Summary

### Modules & Design

| Module             | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| **Fourier Embedding** | Sinusoidal projection for lane lengths, angles, motion vectors             |
| **Map Encoder**     | Lane-wise self-attention with relative positional encodings                 |
| **Agent Encoder**   | Stacked layers of:                                                          |
|                    | • Temporal Self-Attention (per-agent)                                       |
|                    | • Agent2Agent Cross-Attention (per timestep)                                |
|                    | • Agent2Lane Cross-Attention (global lane context)                          |
| **Decoder (N layers)** | Repeated layers with:                                                      |
|                    | • Mode-to-Temporal Cross-Attention                                          |
|                    | • Mode-to-Agent Cross-Attention                                             |
|                    | • Mode-to-Lane Cross-Attention                                              |
| **Output**          | For each agent: $M$ predicted trajectories, variances, and logits           |

### Design Notes

- **Mode Queries**: Learnable, per-agent-per-mode
- **No weight sharing** across decoder layers
- **MLP heads are shared** across layers
- **Intermediate outputs** supervised with regression loss at each layer
- **No deformable attention**, standard multi-head attention is used

---

## 3. Training Configuration from Paper

| Aspect                        | Value / Description                                               |
|-------------------------------|-------------------------------------------------------------------|
| **GPU**                       | 1× NVIDIA A100                                                    |
| **Optimizer**                 | AdamW                                                             |
| **Sampling Rate**             | 2 Hz (past 2s → 4 frames, future 6s → 12 frames)                  |
| **Modes ($M$)**               | 5                                                                 |
| **Decoder Layers ($N$)**      | 3                                                                 |
| **Input Area**                | 150 m × 100 m, ego-aligned                                        |
| **Lane Segment Length**       | 3 m (empirically optimal)                                        |
| **Augmentation**              | Horizontal flip along ego-heading (p=0.5)                         |
| **Loss Function**             | Laplace NLL (WTA-regression + classification)                    |
| **Datasets Used**            | nuScenes, DeepScenario, Argoverse 2                               |
| **Evaluation Metrics**        | minADE5, MR5, minFDE5, OffRoadRate                               |

> ⚠️ **Missing from the paper**: learning rate, batch size, epoch count, warm-up/clipping strategies — must be tuned independently.

---

## 4. Ablation Study Findings

| Ablation                  | Effect (minADE5 ↑ is worse) |
|---------------------------|------------------------------|
| Full LMFormer             | **1.13**                     |
| – Intermediate Refinement | 1.16                         |
| – Lane Self-Attention     | 1.15                         |

> → **Intermediate decoder loss** and **lane topology modeling** are both **crucial**.

---

## 5. Reimplementation Feasibility (RTX 4090)

### ✅ Hardware Capability

| Component              | Estimate (D=128, M=5, N_a=16, N_L=256) |
|------------------------|-----------------------------------------|
| Model Params           | ~50–70M                                 |
| Max Batch Size (fp16)  | 64–128                                  |
| Peak VRAM              | ~16–20 GB with mixed precision          |
| Attention Cost         | Manageable if MHA is optimized (e.g., xformers) |

### 🔧 Optimization Tips

- **Use torch.cuda.amp** (mixed precision)
- **Use gradient accumulation** for batch scaling
- **Profile attention layers**: consider `xformers` if needed
- **Use Argoverse v2 mini** or a curated subset for debugging

---

## 6. Dataset & Preprocessing Guidance

| Feature                  | Description                                                   |
|--------------------------|---------------------------------------------------------------|
| **Dynamic Input**        | Agent trajectories (x, y, angle) over past 2s @ 2Hz           |
| **Static Input**         | Lane graph: centerline vectors, topology, orientation         |
| **Coordinate Frame**     | Ego-centric, aligned to heading                               |
| **Augmentations**        | Flip along ego axis (p=0.5), maybe rotation noise             |
| **Lane Length**          | 3 m segmentation (shorter segments boost curvature modeling)  |

---

## 7. Reimplementation Roadmap

| Phase | Objective                                  | Duration | Tools |
|-------|--------------------------------------------|----------|-------|
| 1     | Setup data loading & local BEV frame       | 1–2 days | PyTorch, Argoverse SDK |
| 2     | Implement MapEncoder + AgentEncoder        | 2–3 days | Torch, FourierEmbed, MHA |
| 3     | Build decoder block with mode queries      | 2 days   | Modular MHA decoder |
| 4     | Implement Laplace WTA loss                 | 1 day    | Custom loss module |
| 5     | Train on mini split (sanity check)         | 2–3 days | AMP, TensorBoard |
| 6     | Scale up to full Argoverse + tuning        | 5–7 days | AdamW + cosine LR |
| 7     | Visualize predictions & attention          | 1–2 days | matplotlib, seaborn |
| 8     | Reproduce ablations                        | optional | scriptable configs |

> ⚠️ Begin with **D=64**, **N=2**, **M=3**, and batch size = 32 → profile and scale.

---

## 8. Libraries & Utilities

| Purpose            | Recommended Tools                                      |
|--------------------|--------------------------------------------------------|
| Model & Training   | PyTorch, PyTorch Lightning (optional)                  |
| Logging            | TensorBoard, Weights & Biases                          |
| Attention Scaling  | [xformers](https://facebookresearch.github.io/xformers/) |
| Config Management  | Hydra or Pydantic                                      |
| Data               | Argoverse SDK, DeepScenario loaders                    |
| Metrics            | Custom minADE5, MR5, OffroadRate                       |

---

## 9. Summary

✅ **You can re-implement and train LMFormer on a single RTX 4090**, with:

- Mixed precision & careful batching
- Modular transformer setup with mode queries and cross-attention
- Proper supervision at each decoder layer
- Optimization of dataset size, model width, and sampling strategy

> LMFormer is a **well-structured, interpretable**, and **reproducible** architecture. Its layered decoding and explicit agent-map modeling offer a clear path toward SOTA multi-agent forecasting—without requiring massive compute.
