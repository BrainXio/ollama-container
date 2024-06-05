# Ollama-Container

<div style="display: flex; align-items: center;">
    <div style="flex-shrink: 0; margin-right: 20px; text-align: center;">
        <img src="https://avatars.githubusercontent.com/u/168876326?s=200&v=4" alt="Ollama Logo" width="75" height="75">
    </div>
    <div>
        "A NVIDIA CUDA container for the Ollama application, completely rebuilt with a different level of logic to optimize performance and streamline operations. This Docker container is structured to deploy the Ollama software, leveraging NVIDIA CUDA for enhanced GPU support. The Dockerfile employs a multi-stage build to minimize the final image size while incorporating all necessary dependencies."
    </div>
</div>

## Status

[![Check Ollama Tag](https://github.com/BrainXio/ollama-container/actions/workflows/check-ollama-tag.yml/badge.svg)](https://github.com/BrainXio/ollama-container/actions/workflows/check-ollama-tag.yml) [![Docker-CICD](https://github.com/BrainXio/ollama-container/actions/workflows/docker-cicd.yml/badge.svg)](https://github.com/BrainXio/ollama-container/actions/workflows/docker-cicd.yml)

## Features

- **CUDA Support**: Built on `nvidia/cuda:12.4.1-base-ubuntu22.04` to ensure compatibility with NVIDIA GPUs.
- **Security**: Runs as a non-root user to enhance security.
- **Optimized Storage**: Multi-stage build process to reduce overall image size.

## Prerequisites

To use this Docker container, you will need:
- Docker installed on your machine.
- NVIDIA GPU with CUDA support.

## Directory Structure

- **/mnt/c/agents**: Directory for storing agent-related files and configurations.
- **/mnt/c/data**: Directory for application data storage.
- **/var/logs**: Directory for logging application events and activities.
- **/mnt/c/src**: Directory for source code and related files.
- **/mnt/c/bus**: Directory for message bus configuration and data.
- **/mnt/c/models**: Directory for storing models used by the Ollama application.

## Installation

1. Clone this repository or download the Dockerfile directly.
2. Build the Docker image using the following command:
   ```
   docker build -t ollama_container .
   ```
3. Run the container with:
   ```
   docker run -d --name my_ollama_container ollama_container
   ```

## CI/CD Workflow

Our project uses a CI/CD pipeline powered by GitHub Actions to automate the testing, building, and deployment of the Docker container:

- **Versioning**: Automatically detects version changes based on commit messages and tags.
- **Builds**:
  - **Development Builds** (on push to `feature/*`, `hotfix/*`, `bugfix/*` branches): Builds the Docker image and runs preliminary tests.
  - **Production Builds** (on push to `main` and tags starting with `v`): Final production-ready builds, with extensive testing and security scans.
- **Pull Request Checks**: Runs automated tests, linting, and static code analysis on pull requests to ensure code quality.
- **Releases**:
  - **Development Release**: Deploys to a development environment and updates changelog.
  - **Production Release**: Deploys to production with full logs and detailed release documentation.

## Usage

Once the Docker container is running, it will start the Ollama application and serve requests. You can interact with it using your preferred methods to send requests to the exposed API.

## Configuration

Environment variables are set within the Dockerfile to configure paths for models, agents, and other components. These can be adjusted by modifying the Dockerfile before building if different paths are required.

## Credits

This Docker container was developed using the Ollama software provided by the Ollama team. For more information or to contribute, visit [Ollama.ai](https://ollama.ai) or their GitHub repository at [github.com/ollama](https://github.com/ollama).

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file.

## Changelog

For detailed changes and release notes, please refer to the [CHANGELOG.md](CHANGELOG.md) file.

---

For more detailed instructions or if you encounter issues, please refer to the [Ollama documentation](https://ollama.io/docs) or file an issue on the GitHub repository.
