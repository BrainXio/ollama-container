# 9_MONITORING.md

## Overview

This document details the monitoring and logging strategies for the deployed neural network using containerized solutions. It covers setting up monitoring tools such as Prometheus and Grafana in Docker, creating dashboards, and defining alerts for different metrics to ensure the system’s performance and health are maintained.

## Monitoring and Logging

### Description

Monitoring and logging are essential for maintaining the health and performance of the neural network. By tracking various metrics and logging system events, you can quickly identify and address issues, optimize performance, and ensure the system runs smoothly.

### Setting Up Monitoring Tools in Docker

1. **Prometheus**: An open-source systems monitoring and alerting toolkit.
2. **Grafana**: An open-source platform for monitoring and observability, which integrates well with Prometheus.
3. **Docker Logs**: Built-in Docker functionality to capture logs from containers.

### Running Prometheus in Docker

#### Step 1: Create Prometheus Configuration File

Create a `prometheus.yml` configuration file:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'docker'
    static_configs:
      - targets: ['neuron1:11434', 'neuron2:11434']
```

#### Step 2: Create a Docker Compose File

Create a `docker-compose.yml` file to define Prometheus and Grafana services:

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana-storage:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin

  neuron1:
    build: .
    container_name: neuron1
    environment:
      - MODEL_NAME=example
    ports:
      - "11434:11434"
    volumes:
      - ./data:/mnt/c/data

  neuron2:
    build: .
    container_name: neuron2
    environment:
      - MODEL_NAME=example
    ports:
      - "11435:11434"
    volumes:
      - ./data:/mnt/c/data

volumes:
  grafana-storage:
```

#### Step 3: Run Docker Compose

Start Prometheus, Grafana, and the neural network containers using Docker Compose:

```sh
docker-compose up -d
```

### Grafana Setup

1. Open Grafana in a web browser: `http://localhost:3000`.
2. Add Prometheus as a data source:
   - Navigate to **Configuration > Data Sources**.
   - Click **Add data source** and select **Prometheus**.
   - Set the URL to `http://prometheus:9090` and save.

3. Create dashboards to visualize metrics such as CPU usage, memory usage, disk I/O, etc.

### Defining Alerts

Set up alerts to notify you of any issues with the system.

#### Prometheus Alerting

1. **Configure Alertmanager**: Set up Alertmanager to handle alerts from Prometheus.
2. **Define Alert Rules**: Add alerting rules to the Prometheus configuration file.

```yaml
groups:
  - name: example
    rules:
      - alert: HighCPUUsage
        expr: process_cpu_seconds_total > 0.2
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: "High CPU Usage Detected"
          description: "CPU usage is above 20% for more than 1 minute."
```

3. **Start Alertmanager**:

```sh
docker run -d --name=alertmanager -p 9093:9093 prom/alertmanager
```

### Viewing Logs

Use Docker’s built-in logging functionality to view logs from your containers.

```sh
# View logs for neuron1
docker logs neuron1

# View logs for neuron2
docker logs neuron2
```

## Conclusion

By setting up comprehensive monitoring and logging systems within Docker, you can ensure the neural network’s health and performance are continuously tracked and maintained. Tools like Prometheus and Grafana provide robust solutions for real-time monitoring and visualization, while Docker logs offer straightforward log management for containers. This setup allows for proactive management and quick resolution of any issues that arise.