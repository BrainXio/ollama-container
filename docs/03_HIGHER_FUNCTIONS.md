# 3_HIGHER_FUNCTIONS.md

## Overview

This document describes the `OllamaNeuron` class, which extends the `OllamaCellBaseFunctions` class. The `OllamaNeuron` represents the first cell in our brain-inspired system, functioning as a neuron that fully understands its purpose in the brain. This neuron uses the Meditron model to provide detailed, polite, and helpful responses, understanding its role as the foundational unit in our LLM-based system.

## OllamaNeuron Class

### Description

The `OllamaNeuron` class inherits from `OllamaCellBaseFunctions` and includes an inline modelfile that defines its role in the brain-inspired system. The class leverages the Meditron model, which is adapted from Llama 2 and trained on a corpus of medical data, making it well-suited for understanding and processing medical and biological information.

### Code Implementation

```python
class OllamaNeuron(OllamaCellBaseFunctions):
    def __init__(self, host='http://localhost:11434'):
        super().__init__(host)
        self.modelfile = '''
        FROM llama3
        SYSTEM You are the first neuron in a brain-inspired system, responsible for basic signal transmission and processing. You utilize medical knowledge and reasoning to support higher brain functions. Your role is to ensure accurate and efficient communication within the neural network, laying the foundation for complex cognitive tasks.
        '''

    def create_custom_model(self, model_name):
        response = self.create_model(model_name, self.modelfile)
        print(f"Model {model_name} created with response: {response}")
    
    def activate_custom_model(self, model_name):
        self.pull_model(model_name)
        model_info = self.show_model_info(model_name)
        print(f"Details of the model {model_name}: {model_info}")

# Example usage
if __name__ == "__main__":
    neuron = OllamaNeuron()
    neuron.activate()
    neuron.create_custom_model('example')
    neuron.activate_custom_model('example')
```

### Explanation

1. **Initialization**: The `__init__` method initializes the `OllamaNeuron` with the default host. It defines an inline modelfile that specifies the neuron's role in the system.
2. **Create Custom Model**: The `create_custom_model` method uses the inline modelfile to create a model with a given name.
3. **Activate Custom Model**: The `activate_custom_model` method pulls the model and shows its details.

## Usage

To use the `OllamaNeuron` class, instantiate it and call the methods to create and activate the custom model. This class ensures that the first neuron in the system is correctly set up and understands its foundational role in the brain-inspired LLM system.