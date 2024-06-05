# 2_BASE_FUNCTIONS.md

## Overview

This document describes the base functions provided by the `OllamaCellBaseFunctions` class, which serves as the foundation for creating various OllamaCells in our brain-inspired LLM system. These base functions facilitate interaction with the models, managing their lifecycle, and performing basic operations.

## OllamaCellBaseFunctions Class

### Description

The `OllamaCellBaseFunctions` class provides core functionalities needed to manage and interact with models within an OllamaCell. It includes methods for checking the service status, listing models, generating responses, and more.

### Code Implementation

```python
import ollama
import time
import requests

class OllamaCellBaseFunctions:
    def __init__(self, host='http://localhost:11434'):
        self.host = host
        self.client = ollama.Client(host=self.host)

    def is_service_running(self):
        try:
            response = requests.get(self.host)
            return response.status_code == 200
        except requests.ConnectionError:
            return False

    def list_models(self):
        models_response = self.client.list()
        models = models_response.get('models', [])
        return models

    def show_model_info(self, model_name):
        model_info = self.client.show(model_name)
        return model_info

    def chat(self, model, messages, stream=False):
        if stream:
            return self.client.chat(model=model, messages=messages, stream=True)
        else:
            return self.client.chat(model=model, messages=messages)

    def generate(self, model, prompt):
        return self.client.generate(model=model, prompt=prompt)

    def create_model(self, model_name, modelfile):
        return self.client.create(model=model_name, modelfile=modelfile)

    def copy_model(self, source_model, target_model):
        return self.client.copy(source_model, target_model)

    def delete_model(self, model_name):
        return self.client.delete(model_name)

    def pull_model(self, model_name):
        return self.client.pull(model_name)

    def push_model(self, model_name):
        return self.client.push(model_name)

    def embeddings(self, model, prompt):
        return self.client.embeddings(model=model, prompt=prompt)

    def activate(self):
        # Wait a bit for the service to start
        time.sleep(5)

        # Check if Ollama service is running
        if self.is_service_running():
            print("Ollama service is running.")

            # List available models
            models = self.list_models()
            print("Available models:", models)

            # Show details about a specific model if available
            if models:
                model_info = self.show_model_info(models[0])
                print(f"Details of the model {models[0]}:", model_info)
            else:
                print("No models available.")
        else:
            print("Ollama service is not running.")
```

## Usage

To use the `OllamaCellBaseFunctions` class, instantiate it and call the desired methods. The `activate` method initializes the cell and performs basic checks and operations. This foundational class will be extended in subsequent documents to create more specialized cells within the system.