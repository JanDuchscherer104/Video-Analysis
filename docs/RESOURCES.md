## 🧠 Core Architectures & Models

### 1. Context Aware Scene Prediction Family

#### $\ominus$ **No Code**

### 1.1 **CASPFormer** (2024)

**Goal**: Multi-agent trajectory prediction from BEV using deformable attention
**Backbone**: CASPNet
**Decoder**: Recurrent deformable cross-attention + learnable queries
**Loss**: Laplacian NLL + soft cross-entropy over final positions
**Links**:

- 📄 [Paper (arXiv:2409.17790)](https://arxiv.org/abs/2409.17790)

### 1.2 **CASPNet** (2022) - Context-Aware Scene Prediction

**Goal**: Joint scene prediction (grid-based); static + dynamic context modeling
**Backbone**: CNN + ConvLSTM (multi-scale FPN); Attention blocks (dilated convs)
**Output**: Grid maps per timestep (heatmaps of occupancy)
**Links**:

- 📄 [Paper](https://arxiv.org/abs/2201.06933)

### 1.3 **CASPNet++: Joint Multi-Agent Motion Prediction** (2024)

**Goals**:

- **Enhanced Interaction Modeling:** Improves scene understanding by effectively modeling interactions among multiple agents.​
- **Flexible Environmental Context Integration:** Capable of incorporating diverse environmental inputs such as HD maps, radar detections, and LiDAR segmentations.​
- 📄 [Paper](https://arxiv.org/abs/2308.07751)

### 1.4 **LMFormer (2025)**

**Goal**: Enhanced lane-graph aware trajectory prediction with iterative refinement
**Backbone**: Transformer-based lane-graph encoder with agent-lane cross-attention
**Decoder**: Iterative cross-attention with learnable motion queries and refinement layers
**Loss**: Mixture model WTA regression, classification, and intermediate refinement losses
**Links**:

- 📄 [Paper](https://arxiv.org/abs/2504.10275)
- 📄 [Detailed Summary](/docs/literature/lm-former.md)
- [Local LaTeX Source](/literature/lm-former-arXiv-2504.10275/)

---

### 2. **SemanticFormer + nuScenes Knowledge Graph (nSKG)**

#### $\ominus$ **No Code available for SemanticFormer!!**

**Goal**: Use semantic graphs (ontology) for context-rich trajectory prediction
**Graph**: Nodes = actors, map elements; Edges = semantic relations
**Use case**: Incorporating symbolic relations (e.g., pedestrian approaching crosswalk)
**Links**:

- 📄 [Paper (nuScenesKnowledgeGraph)](https://arxiv.org/pdf/2312.09676)
- 📄  [SemanticFormer: Holistic and Semantic Traffic Scene Representation for Trajectory Prediction using Knowledge Graphs](https://arxiv.org/abs/2404.19379)
- 💻 [GitHub (Bosch Research)](https://github.com/boschresearch/nuScenes_Knowledge_Graph)

---

### 3. **UniTraj (Framework)**

**Goal**: Unified framework for training and evaluating motion prediction models
**Includes**: MTP, CVAE, Occupancy-based heads
**Tools**: Preprocessing, eval metrics, pipelines for nuScenes/Argoverse
**Links**:

- 📄 [Paper](https://arxiv.org/pdf/2403.15098)
- [Local LaTeX Source](/literature/untraj-arXiv-2403.15098/)
- 💻 [GitHub](https://github.com/vita-epfl/UniTraj)
- [Website](https://vita-epfl.github.io/UniTraj/)
- 🎥 [Presentation Video](https://www.youtube.com/watch?v=2IzuUtiNA_4)
**Models:**
- AutoBot (2021) is a recent transformer-based model with competitive results on multiple existing datasets. It is based on equivariant feature learning to learn the joint distribution of trajectories with multi-head attention blocks.
  - 📄 [Paper: Latent Variable Sequential Set Transformers For Joint Multi-Agent Motion Prediction](https://arxiv.org/abs/2104.00563)
- MTR (2021) ranked first on the WOMD Challenge in 2022. It operates by integrating global intention priors with local movement refinement. It uses a limited number of adaptable motion query pairs, allowing precise trajectory prediction and improvement for different motion types.
  - 📄 [Paper: MultiPath++ - Efficient Information Fusion and Trajectory Aggregation for Behavior Prediction](https://arxiv.org/abs/2111.14973)
- Wayformer (2022) is a transformer-based model, featuring a multi-axis encoder. It employs latent queries that facilitate the combination of multi-dimensional inputs. We re-implement the model, as the original code has not been released.
  - 📄[Paper: Wayformer - Motion Forecasting via Simple & Efficient Attention Networks](https://arxiv.org/abs/2207.05844)
- There must be more!

---

### 4. **Diffusion-Based Forecasting** (2024)

**Goal**: Generate diverse, plausible futures using stochastic sampling
**Use case**: Multi-agent interaction-aware trajectory prediction
**Links**:

- 📄 [Paper (arXiv:2403.11643)](https://arxiv.org/abs/2403.11643)
- 💻 [GitHub](https://github.com/tl-qz/trajdiffuse)


---
---

### 5. Query-Centric Trajectory Prediction

- [Paper](https://openaccess.thecvf.com/content/CVPR2023/papers/Zhou_Query-Centric_Trajectory_Prediction_CVPR_2023_paper.pdf)
- [GitHub](https://github.com/ZikangZhou/QCNet?tab=readme-ov-file)

### 6. QCNeXt
- [Paper](https://arxiv.org/abs/2306.10508)
- [Local LaTeX Source](/literature/qcnext-arXiv-2306.10508v1/)

## 🗺️ Datasets

| Dataset     | Agents           | Features                                                  | Link |
|-------------|------------------|-----------------------------------------------------------|------|
| **nuScenes**     | 🚗🚶‍♂️🚲              | HD maps, rich dynamics, 6s prediction, 2s history         | [🔗](https://www.nuscenes.org/prediction) |
| Argoverse 1/2 | 🚗🚶‍♂️               | Lane topologies, city scenes                             | [Website](https://www.argoverse.org/), [GitHub](https://github.com/argoverse/argoverse-api)|
| Waymo OMD     | 🚗                 | High-scale highway + urban scenarios                      | [🔗](https://waymo.com/open/data/motion/) |
| INTERACTION   | 🚗🚶‍♂️               | Focus on nuanced interaction behavior (e.g., merging)     | [🔗](https://interaction-dataset.com/) |
| JAAD          | 🚶‍♂️+ driver        | Joint attention (driver–pedestrian crossing behavior)     | [🔗](https://paperswithcode.com/dataset/jaad) |
| SDD / ETH / UCY | 🚶‍♂️            | Drone/campus scenes, pedestrian flow                     | [🔗](https://github.com/StanfordASL/Trajectron-plus-plus) |
| NGSIM         | 🚗                 | Dense highway scenarios, lane changes                     | [🔗](https://ops.fhwa.dot.gov/trafficanalysistools/ngsim.htm) |

### Considerations

**nuScenes-devkit** is built for Python 3.6..7. I did not easily get it running. **Argoverse** might be a better choice.

#### argoverse-api

- [Argoverse2 User Guide](https://argoverse.github.io/user-guide/)
- [Argoverse2 API](https://github.com/argoverse/av2-api)
- [Getting Started (Argoverse2::Docs)](https://argoverse.github.io/user-guide/getting_started.html)
- [Jupyter Demos](https://github.com/argoverse/argoverse-api/tree/master/demo_usage)

#### nuScenes-devkit

- [nuScenes-devkit Tutorial (html notebook)](https://www.nuscenes.org/tutorials/nuscenes_tutorial.html)
- [nuScenes-devkit Tutorial (GitHub)](https://github.com/nutonomy/nuscenes-devkit/tree/master/python-sdk/tutorials)

---
---

## Further Papers

### 1. **Deformable DETR + Forecasting**

**Goal**: Extension of Detection Transformers with **deformable** (**sparse**) attention to reduce computational complexity of Transformers.
Necessary foundation to understand CASPFormer
**Links**:

- 📄 [Original Paper (Deformable DETR)](https://arxiv.org/abs/2010.04159)
- 🎥 [Video Explanation](https://youtu.be/9UG4amweIjk?si=cX14SiUtZ_CSucfv)
