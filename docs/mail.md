Subject: Inquiry Regarding CASPFormer Code and Clarifications for Graduate Research Project

Dear Dr. Yadav, Dr. Schäfer, Dr. Zhao, and Dr. Meisen,

We are a team of two CS master’s students at Munich University of Applied Sciences. For our seminar project in video analysis, we are focusing on multimodal trajectory and behavior prediction for autonomous driving.

In particular, we have been interested in your CASPFormer and CASPNet(++) research.

While our project goals are not strictly defined yet, we are considering building upon the CASPFormer architecture.

Possible directions include:

- Predicting additional targets (e.g. maneuvers / behaviors, future velocities, etc.) to see whether this might help the model to learn better representations and hence yield better trajectory predictions.
- Trying out hybrid approaches - e.g. using a GNN based encoder for the vectorized objects (instead of or together with your BEV based encoder / backbone) and actors to get scene representations that might encode the interactions between objects and actors in a more holistic manner.
- Trying out different loss functions - eg. entropy-based losses to improve mode diversity.
- Experimenting with different (positional) encoding schemes.
- Retraining on ArgoverseV2 or testing the performance of the model trained on nuScenes on ArgoverseV2.
- Possible integration into the UniTraj ecosystem.
- Doing further ablation studies to simplify your approach like
  - Removing the RNN modules in the encoder.

We would be more than grateful if you had some suggestions on which directions you could recommend us to pursue.

integrating a graph-based semantic context (e.g., similar to SemanticFormer from the nuScenes Knowledge Graph framework from Bosch Research) with CASPFormer’s approach.
Given our limited time and compute resources, we are interested in using and extending an existing implementation rather than starting (and training) from scratch.

With this in mind, I kindly request whether you would be willing to share the source code and related documentation (e.g., configuration files, training logs, or pretrained weights) for CASPFormer (and, if available, CASPNet/CASPNet++). We assure you that our use is strictly for academic research within our graduate project, and any contributions would remain within our module’s scope (with potential for publication only if there are truly noteworthy advances).

In addition, we would greatly appreciate clarification on a couple of technical points

- Could you please confirm whether the mode probabilities (π(k)) are directly predicted via a softmax over learned logits, or are they derived indirectly from the Laplacian regression parameters?
- In the CASPFormer paper, the classification loss is a function of the mode probabilities (π(k)) - are
- Could you clarify whether the loss formulation uses a soft weighting across all modes based on the final timestep likelihood, or if a hard selection (best mode) is applied?

Thank you very much for your time and for your inspiring work. We are excited about the possibility of building upon your research and would be happy to share our findings with you as our work progresses.

Best regards
Jan Duchscherer
