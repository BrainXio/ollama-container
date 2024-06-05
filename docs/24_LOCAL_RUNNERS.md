# 24_LOCAL_RUNNERS.md

## Overview

This document provides guidelines for setting up and using local CI/CD runners with platforms like GitHub Actions, GitLab CI/CD, and Jenkins. Local runners enable you to run CI/CD jobs on your own infrastructure, providing more control over resources, security, and configurations.

## Importance of Local Runners

### Description

Local runners offer several benefits, including:
1. **Resource Control**: Use your own hardware resources, avoiding limitations of hosted solutions.
2. **Security**: Keep your CI/CD processes and sensitive data within your own network.
3. **Customization**: Customize the CI/CD environment to suit your specific needs.

## Setting Up Local Runners

### GitHub Actions

GitHub Actions allows you to set up self-hosted runners to execute workflows on your own machines.

#### Steps to Set Up a GitHub Actions Self-Hosted Runner

1. **Create a Runner**: Go to your repository on GitHub, navigate to **Settings > Actions > Runners**, and click **Add runner**.

2. **Download and Configure**: Follow the instructions to download the runner application and configure it on your machine.

3. **Install and Run the Runner**: Use the provided commands to install and start the runner.

```sh
# Example commands for Linux
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.278.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.278.0.tar.gz
./config.sh --url https://github.com/yourusername/your-repo --token YOUR_TOKEN
./svc.sh install
./svc.sh start
```

4. **Update Workflow File**: Update your workflow YAML file to use the self-hosted runner.

```yaml
name: CI

on: [push]

jobs:
  build:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v2
      - name: Run a one-line script
        run: echo Hello, world!
```

### GitLab CI/CD

GitLab CI/CD allows you to register and use self-hosted runners for running pipelines.

#### Steps to Set Up a GitLab Runner

1. **Install GitLab Runner**: Follow the installation instructions for your operating system from the [GitLab Runner documentation](https://docs.gitlab.com/runner/install/).

```sh
# Example for Ubuntu
curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
chmod +x /usr/local/bin/gitlab-runner
gitlab-runner install
gitlab-runner start
```

2. **Register the Runner**: Use the `gitlab-runner register` command to register your runner with your GitLab instance.

```sh
sudo gitlab-runner register
```

During registration, you will be prompted for the GitLab URL and a registration token, which you can find in your project under **Settings > CI/CD > Runners**.

3. **Configure the Runner**: Update the `.gitlab-ci.yml` file to use the registered runner.

```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - echo "Compiling the code..."
  tags:
    - my-runner
```

### Jenkins

Jenkins allows you to set up agents (also known as nodes) to run jobs on different machines.

#### Steps to Set Up a Jenkins Agent

1. **Install Jenkins**: Follow the installation instructions for Jenkins on your server.

2. **Configure Nodes**: In Jenkins, navigate to **Manage Jenkins > Manage Nodes and Clouds > New Node**, and configure the node details.

3. **Launch Agent**: On the agent machine, download the agent.jar file from your Jenkins server and run it.

```sh
# Example command to launch Jenkins agent
java -jar agent.jar -jnlpUrl http://your-jenkins-server/computer/your-agent/slave-agent.jnlp -secret your-agent-secret -workDir "/path/to/agent/workdir"
```

4. **Update Jenkinsfile**: Configure your Jenkins pipeline to use the agent.

```groovy
pipeline {
    agent {
        label 'your-agent'
    }
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
    }
}
```

## Best Practices for Using Local Runners

### Description

Following best practices ensures that local runners are efficient, secure, and maintainable.

### Guidelines

1. **Resource Management**: Monitor resource usage and scale your runners according to demand.
2. **Security**: Ensure that runners are secured and access is restricted to authorized users only.
3. **Updates**: Regularly update the runner software to the latest version.
4. **Logging and Monitoring**: Implement logging and monitoring to track runner performance and detect issues.
5. **Maintenance**: Schedule regular maintenance for your runners to ensure they remain in good working condition.

### Example: Monitoring Runner Performance

Use monitoring tools like Prometheus and Grafana to track the performance and health of your runners.

```yaml
# Example Prometheus configuration for monitoring GitHub Actions runner
scrape_configs:
  - job_name: 'github_actions_runner'
    static_configs:
      - targets: ['localhost:9100']
```

## Conclusion

Setting up local runners for CI/CD platforms like GitHub Actions, GitLab CI/CD, and Jenkins provides greater control over the CI/CD environment. By following the steps outlined and adhering to best practices, you can ensure that your CI/CD processes are efficient, secure, and tailored to your specific needs.