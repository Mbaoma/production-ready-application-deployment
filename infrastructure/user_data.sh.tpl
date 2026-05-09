#!/bin/bash
set -euxo pipefail

apt-get update -y

apt-get install -y \
  docker.io \
  docker-compose-plugin \
  awscli \
  curl \
  unzip

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu || true

mkdir -p /opt/${project_name}
cd /opt/${project_name}

cat > docker-compose.yml <<EOF
services:
  api:
    image: ${ecr_repository_url}:latest
    container_name: fastapi-api
    restart: unless-stopped
    ports:
      - "80:8000"
    environment:
      - ENVIRONMENT=production
    logging:
      driver: awslogs
      options:
        awslogs-region: ${aws_region}
        awslogs-group: ${cloudwatch_log_group}
        awslogs-stream: fastapi-api
        awslogs-create-group: "false"

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    ports:
      - "9100:9100"

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
EOF

cat > prometheus.yml <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "fastapi"
    metrics_path: "/metrics"
    static_configs:
      - targets: ["api:8000"]

  - job_name: "node-exporter"
    static_configs:
      - targets: ["node-exporter:9100"]

  - job_name: "cadvisor"
    static_configs:
      - targets: ["cadvisor:8080"]
EOF

aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${ecr_repository_url}

docker compose pull || true
docker compose up -d || true