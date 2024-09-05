# Use the official Prometheus base image
FROM prom/prometheus:latest

# Copy Prometheus configuration file
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Install cAdvisor and Node Exporter
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/google/cadvisor/releases/latest/download/cadvisor && \
    chmod +x cadvisor && \
    mv cadvisor /usr/local/bin/ && \
    wget https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-*.linux-amd64.tar.gz && \
    tar xvfz node_exporter-*.linux-amd64.tar.gz && \
    mv node_exporter-*/node_exporter /usr/local/bin/ && \
    rm -rf node_exporter-*.linux-amd64*

# Expose ports for Prometheus, cAdvisor, and Node Exporter
EXPOSE 9090 9100 8080

# Start Prometheus, cAdvisor, and Node Exporter
CMD [ "/bin/sh", "-c", "node_exporter & cadvisor & /bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus" ]
