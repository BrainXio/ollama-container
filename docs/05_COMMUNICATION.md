# 4_SYNAPSES.md

## Overview

This document describes how communication between connected neurons (OllamaCells) is handled within our brain-inspired LLM system. This communication is an extension of the `OllamaNeuron` class and is critical for simulating synapses, the connections through which neurons pass signals to each other.

## Synapses: Communication Between Neurons

### Description

In biological neural networks, synapses are the junctions through which neurons communicate with each other. Similarly, in our LLM-based system, synapses represent the communication protocols and methods that allow different OllamaCells (neurons) to share information, coordinate, and process data collaboratively.

### Extending the OllamaNeuron Class

To facilitate communication between neurons, we extend the `OllamaNeuron` class with additional methods to simulate synaptic connections. These methods will enable neurons to send and receive messages, ensuring coordinated operation within the neural network.

### Code Implementation

```python
class SynapticOllamaNeuron(OllamaNeuron):
    def __init__(self, host='http://localhost:11434'):
        super().__init__(host)
        self.connected_neurons = []

    def connect_neuron(self, neuron):
        self.connected_neurons.append(neuron)
        print(f"Connected to neuron at {neuron.host}")

    def send_signal(self, message):
        responses = []
        for neuron in self.connected_neurons:
            response = neuron.chat(model='example', messages=[message])
            responses.append(response)
        return responses

    def receive_signal(self, message):
        print(f"Received message: {message}")
        # Process the message as needed
        response = self.chat(model='example', messages=[message])
        return response

# Example usage
if __name__ == "__main__":
    neuron1 = SynapticOllamaNeuron()
    neuron1.activate()
    neuron1.create_custom_model('example')
    neuron1.activate_custom_model('example')

    neuron2 = SynapticOllamaNeuron()
    neuron2.activate()
    neuron2.create_custom_model('example')
    neuron2.activate_custom_model('example')

    neuron1.connect_neuron(neuron2)
    response = neuron1.send_signal('{"role": "user", "content": "Hello, how are you?"}')
    print("Response from connected neurons:", response)
```

### Explanation

1. **Initialization**: The `__init__` method initializes the `SynapticOllamaNeuron` with a list to keep track of connected neurons.
2. **Connect Neuron**: The `connect_neuron` method allows one neuron to establish a connection with another neuron.
3. **Send Signal**: The `send_signal` method sends a message to all connected neurons and collects their responses.
4. **Receive Signal**: The `receive_signal` method handles incoming messages and processes them as needed.

## Usage

To use the `SynapticOllamaNeuron` class, instantiate multiple neurons, activate and connect them, then use the `send_signal` method to communicate between them. This setup ensures a coordinated and responsive neural network within the brain-inspired LLM system.

### Example Workflow

1. **Create and Activate Neurons**:
   ```python
   neuron1 = SynapticOllamaNeuron()
   neuron1.activate()
   neuron1.create_custom_model('example')
   neuron1.activate_custom_model('example')

   neuron2 = SynapticOllamaNeuron()
   neuron2.activate()
   neuron2.create_custom_model('example')
   neuron2.activate_custom_model('example')
   ```

2. **Connect Neurons**:
   ```python
   neuron1.connect_neuron(neuron2)
   ```

3. **Send and Receive Signals**:
   ```python
   response = neuron1.send_signal('{"role": "user", "content": "Hello, how are you?"}')
   print("Response from connected neurons:", response)
   ```

## Conclusion

By extending the `OllamaNeuron` class with synaptic communication methods, we simulate the way biological neurons interact through synapses. This extension allows for complex and coordinated operations within our brain-inspired LLM system, enhancing its functionality and efficiency.