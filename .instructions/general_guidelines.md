# Coding Guidelines & Pipeline Overview

## 1. Project Structure & Philosophy

- **Modular Pipeline**: Design your codebase as a sequence of independent, replaceable stages.
- **Configuration-Driven**: Use configuration objects for all setup and validation; runtime objects should only handle execution logic.
- **Separation of Concerns**: Keep configuration, validation, and runtime logic clearly separated.

---

## 2. Core Design Patterns

### Config-as-Factory Pattern

- Use strongly-typed Pydantic (or similar) config objects as factories for runtime components.
- Each config class should provide a `setup_target()` method that instantiates and validates the runtime object.
- Prefer dependency injection via config objects over hardcoded dependencies.

**Example:**

```python
from pydantic import BaseModel, Field

class MyComponentConfig(BaseModel):
    param: int = 42

    def setup_target(self) -> "MyComponent":
        return MyComponent(self)

class MyComponent:
    def __init__(self, config: MyComponentConfig):
        self.param = config.param
```

### Singleton Configuration

- Use a singleton pattern for global resources (e.g., paths, environment variables).
- Provide methods for consistent access to shared resources.

**Example:**

```python
class PathConfig:
    _instance = None
    root: Path = Path(__file__).parent

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
```

### Model Selection via Nested Configs

- Select models or algorithms by passing a config object (not an enum or string).
- Use union types for fields that accept multiple config types.

**Example:**

```python
from typing import Union

class StepConfig(BaseModel):
    model_config: Union[ModelAConfig, ModelBConfig]
```

### Validators

- Use field and model validators for all config and data classes.
- Validate paths, file existence, and parameter ranges at config time.

---

## 3. Implementation Requirements

- **Type Annotations**: All functions and methods must have explicit type annotations.
- **Validation**: Use Pydantic or similar for all config/data validation.
- **Logging**: Use a centralized logger for all warnings, errors, and info messages.
- **Runtime Instantiation**: Always instantiate runtime objects via their config's `setup_target()` method.
- **No Hardcoding**: Avoid hardcoded parameters; use config objects and validators.
- **Error Handling**: Use proper error handling and log all fallbacks or unexpected states.

---

## 4. Docstring Style Guide

All public functions, methods, and classes must include doc-strings using the conventions as per the following example:

```python
    """
    Forward pass for Transformer.

    Args:
        src_seq (Tensor['B num_pieces num_features_out', float32]): The sequence of puzzle piece features.
        tgt_seq (Tensor['B num_pieces num_features_out', float32]): The target sequence of position embeddings.
        memory (Tensor['B num_pieces num_features_out', float32]): Encoder memory tensor.

    Returns:
        Tuple[Tensor, Tensor] containing:
            - Decoder output tensor (Tensor['B num_pieces num_features_out', float32])
            - Encoder memory tensor (Tensor['B num_pieces num_features_out', float32])
    """
```

**Additional Guidelines:**

- Use the `Tensor[...]` or `np.ndarray[...]` notation for all array/tensor arguments and return values, specifying shape and dtype where possible.
- For keyword arguments (`**kwargs`), document them explicitly if they are expected/used.
- For classes, include a summary and document all public attributes and methods.
- Keep descriptions concise but informative.
- Use Google-style or NumPy-style doc-strings for more complex cases, but always include type and shape for tensors/arrays.

---

## 5. Implementation Checklist

**Required**:

- ✓ Explicit type annotations on all methods and functions
- ✓ Config classes inherit from a base config (e.g., `BaseConfig`)
- ✓ All step classes and models instantiated via `setup_target()`
- ✓ Model selection via nested config (`model_config: Union[...]`)
- ✓ Centralized logging
- ✓ Separate setup and execution logic
- ✓ Rich I/O type modeling via Pydantic or similar
- ✓ Clear stage interfaces with well-defined input/output types and docstrings
- ✓ Interface-driven modularization
- ✓ Parallel stages supported if needed
- ✓ Proper error handling and fallback logging
- ✓ Prefer functional approaches over loops/comprehensions when appropriate

**Avoid**:

- ✗ Embedding validation logic in runtime classes (targets)
- ✗ Enum-based model switching (prefer config nesting)
- ✗ Tight coupling between stages (stages should be independently replaceable)
- ✗ Implicit type usage or untyped interfaces
- ✗ Logic leakage across config/runtime boundaries
- ✗ Hardcoded parameters or skipped validations

By following these guidelines, you ensure a modular, scalable, and production-ready pipeline framework with clarity, flexibility, and robustness.
