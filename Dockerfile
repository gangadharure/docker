# Use the official Prometheus base image
FROM prom/prometheus:latest

# Copy Prometheus configuration file
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Install required dependencies and tools, including cAdvisor and Node Exporter
RUN apt-get update && \
    apt-get install -y wget curl ca-certificates && \
    wget https://github.com/google/cadvisor/releases/latest/download/cadvisor -O /usr/local/bin/cadvisor && \
    chmod +x /usr/local/bin/cadvisor && \
    wget https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-1.6.1.linux-amd64.tar.gz -O /tmp/node_exporter.tar.gz && \
    tar -xvf /tmp/node_exporter.tar.gz --strip-components=1 -C /usr/local/bin node_exporter-1.6.1.linux-amd64/node_exporter && \
    chmod +x /usr/local/bin/node_exporter && \
    rm -rf /tmp/node_exporter.tar.gz

# Expose ports for Prometheus (9090), Node Exporter (9100), and cAdvisor (8080)
EXPOSE 9090 9100 8080

# Start Prometheus, cAdvisor, and Node Exporter
CMD [ "/bin/sh", "-c", "node_exporter & cadvisor & /bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus" ]
