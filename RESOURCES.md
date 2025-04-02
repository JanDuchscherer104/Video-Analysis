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

---

### 2. **SemanticFormer + nuScenes Knowledge Graph (nSKG)**

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

## 🗺️ Datasets

| Dataset     | Agents           | Features                                                  | Link |
|-------------|------------------|-----------------------------------------------------------|------|
| **nuScenes**     | 🚗🚶‍♂️🚲              | HD maps, rich dynamics, 6s prediction, 2s history         | [🔗](https://www.nuscenes.org/prediction) |
| Argoverse 1/2 | 🚗🚶‍♂️               | Lane topologies, city scenes                             | [🔗](https://www.argoverse.org/) |
| Waymo OMD     | 🚗                 | High-scale highway + urban scenarios                      | [🔗](https://waymo.com/open/data/motion/) |
| INTERACTION   | 🚗🚶‍♂️               | Focus on nuanced interaction behavior (e.g., merging)     | [🔗](https://interaction-dataset.com/) |
| JAAD          | 🚶‍♂️+ driver        | Joint attention (driver–pedestrian crossing behavior)     | [🔗](https://paperswithcode.com/dataset/jaad) |
| SDD / ETH / UCY | 🚶‍♂️            | Drone/campus scenes, pedestrian flow                     | [🔗](https://github.com/StanfordASL/Trajectron-plus-plus) |
| NGSIM         | 🚗                 | Dense highway scenarios, lane changes                     | [🔗](https://ops.fhwa.dot.gov/trafficanalysistools/ngsim.htm) |

---
---

## Further Papers

### 1. **Deformable DETR + Forecasting**

**Goal**: Extension of Detection Transformers with **deformable** (**sparse**) attention to reduce computational complexity of Transformers.
Necessary foundation to understand CASPFormer
**Links**:

- 📄 [Original Paper (Deformable DETR)](https://arxiv.org/abs/2010.04159)
- 🎥 [Video Explanation](https://youtu.be/9UG4amweIjk?si=cX14SiUtZ_CSucfv)
