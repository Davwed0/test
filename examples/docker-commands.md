# Docker Commands Reference

Quick reference for managing your ELK stack.

**Note**: These examples use Docker Compose v2 syntax (`docker compose`). If you have Docker Compose v1, use `docker-compose` (with a hyphen) instead.

## Starting the Stack

```bash
# Start all services in detached mode
docker compose up -d

# Start and view logs
docker compose up

# Start specific service
docker compose up -d elasticsearch
```

## Stopping the Stack

```bash
# Stop all services
docker compose stop

# Stop and remove containers
docker compose down

# Stop, remove containers, and delete volumes (CAUTION: deletes all data!)
docker compose down -v
```

## Viewing Logs

```bash
# View all logs
docker compose logs

# Follow logs (real-time)
docker compose logs -f

# View logs for specific service
docker compose logs -f logstash

# View last 100 lines
docker compose logs --tail=100 logstash
```

## Checking Status

```bash
# List running containers
docker compose ps

# View resource usage
docker stats

# Check specific container
docker inspect elasticsearch
```

## Restarting Services

```bash
# Restart all services
docker compose restart

# Restart specific service
docker compose restart logstash

# Restart after configuration changes
docker compose restart logstash
```

## Executing Commands in Containers

```bash
# Open bash shell in container
docker compose exec elasticsearch bash

# Run single command
docker compose exec elasticsearch curl http://localhost:9200

# Check Logstash configuration
docker compose exec logstash bin/logstash --config.test_and_exit -f /usr/share/logstash/pipeline/wikimedia.conf
```

## Useful Checks

### Elasticsearch Health
```bash
# Cluster health
curl http://localhost:9200/_cluster/health?pretty

# List indices
curl http://localhost:9200/_cat/indices?v

# Count documents
curl http://localhost:9200/wikipedia-changes-*/_count

# View mapping
curl http://localhost:9200/wikipedia-changes-*/_mapping?pretty
```

### Logstash Status
```bash
# Check if Logstash is running
curl http://localhost:9600

# Get pipeline stats
curl http://localhost:9600/_node/stats/pipelines?pretty
```

### Kibana Status
```bash
# Check Kibana status
curl http://localhost:5601/api/status
```

## Troubleshooting

### Services Won't Start

```bash
# View detailed logs
docker compose logs

# Check if ports are already in use
netstat -tuln | grep -E '9200|9300|5601|5000|9600'

# Remove everything and start fresh
docker compose down -v
docker compose up -d
```

### Out of Memory Errors

Edit `docker-compose.yml` and increase heap size:
```yaml
environment:
  - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
```

### Configuration Changes Not Applied

```bash
# Restart the service
docker compose restart logstash

# Or rebuild and restart
docker compose up -d --force-recreate logstash
```

### No Data in Elasticsearch

```bash
# Check Logstash logs for errors
docker compose logs -f logstash

# Test the Wikimedia stream directly
curl https://stream.wikimedia.org/v2/stream/recentchange

# Verify Logstash can reach Elasticsearch
docker compose exec logstash curl http://elasticsearch:9200
```

### Disk Space Issues

```bash
# Check Docker disk usage
docker system df

# Clean up unused containers and images
docker system prune

# Remove old indices (be careful!)
curl -X DELETE http://localhost:9200/wikipedia-changes-2026.01.01
```

## Performance Tuning

### Increase Memory Limits

Edit `docker-compose.yml`:
```yaml
services:
  elasticsearch:
    environment:
      - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
    deploy:
      resources:
        limits:
          memory: 2g
```

### Reduce Data Volume

Edit `logstash/pipeline/wikimedia.conf`:
```
# Add filters to drop unwanted data
filter {
  if [bot] == true {
    drop { }
  }
}
```

### Adjust Polling Interval

In `logstash/pipeline/wikimedia.conf`:
```
schedule => { cron => "*/5 * * * * UTC"}  # Every 5 seconds instead of every second
```

## Data Management

### Export Data
```bash
# Export index to file
docker compose exec elasticsearch curl -X GET "http://localhost:9200/wikipedia-changes-*/_search?size=10000" > export.json
```

### Delete Old Data
```bash
# Delete indices older than 7 days
curl -X DELETE "http://localhost:9200/wikipedia-changes-2026.01.01"

# Or use Index Lifecycle Management in Kibana
```

### Backup Configuration
```bash
# Backup your configurations
tar -czf elk-backup.tar.gz logstash/ docker-compose.yml

# Restore
tar -xzf elk-backup.tar.gz
```

## Development Workflow

1. **Edit configuration files**
   ```bash
   vim logstash/pipeline/wikimedia.conf
   ```

2. **Restart affected service**
   ```bash
   docker compose restart logstash
   ```

3. **Check logs for errors**
   ```bash
   docker compose logs -f logstash
   ```

4. **Verify changes in Elasticsearch**
   ```bash
   curl http://localhost:9200/wikipedia-changes-*/_search?size=1&pretty
   ```

5. **View in Kibana**
   - Open http://localhost:5601
   - Go to Discover
   - Check new fields/changes

## Quick Reset

Complete reset (deletes all data):
```bash
docker compose down -v
docker compose up -d
# Wait 1-2 minutes for services to start
# Recreate index pattern in Kibana
```

## Monitoring

### Watch for New Documents
```bash
# Keep checking document count
watch -n 5 'curl -s http://localhost:9200/wikipedia-changes-*/_count | jq'
```

### Monitor Logstash Processing
```bash
# Watch pipeline stats
watch -n 10 'curl -s http://localhost:9600/_node/stats/pipelines?pretty'
```

## Best Practices

1. **Always check logs** when something doesn't work
2. **Wait for services** to fully start (30-60 seconds)
3. **Save your configurations** before experimenting
4. **Use volumes** for persistent data
5. **Monitor resources** - ELK stack is resource-intensive
6. **Clean up regularly** - delete old indices

## Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| Port already in use | Change port in docker-compose.yml or stop conflicting service |
| Container keeps restarting | Check logs with `docker compose logs` |
| Out of memory | Increase heap size in environment variables |
| No data appearing | Check Logstash logs, verify stream URL is accessible |
| Kibana can't connect | Ensure Elasticsearch is running and healthy |
| Slow performance | Reduce data volume or increase resources |

---

**Pro Tip**: Keep a terminal open with `docker compose logs -f` to monitor all services in real-time!
