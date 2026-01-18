# Quick Start Guide

Get up and running with the ELK stack in 5 minutes!

## Prerequisites

- Docker installed (version 20.10 or higher)
- Docker Compose v2 (or v1)
- At least 4GB of RAM available for Docker
- Internet connection

## Step 1: Start the Stack

```bash
# Clone or navigate to the repository
cd /path/to/elk-learning-lab

# Start all services
docker compose up -d

# Watch the logs (optional)
docker compose logs -f
```

**Wait 2-3 minutes** for services to fully initialize.

## Step 2: Verify Services are Running

```bash
# Check container status
docker compose ps

# Test Elasticsearch
curl http://localhost:9200

# Test Kibana (should return HTML)
curl http://localhost:5601
```

Expected output for Elasticsearch:
```json
{
  "name" : "elasticsearch",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "...",
  "version" : { ... },
  "tagline" : "You Know, for Search"
}
```

## Step 3: Wait for Data

Data collection starts automatically. Check if data is flowing:

```bash
# Wait a minute, then check for indices
curl http://localhost:9200/_cat/indices?v

# Count documents
curl http://localhost:9200/wikipedia-changes-*/_count
```

You should see indices like `wikipedia-changes-2026.01.18`.

## Step 4: Open Kibana

1. Open your browser: http://localhost:5601
2. Wait for Kibana to finish loading
3. Click on the menu (☰) in the top-left

## Step 5: Create Index Pattern

1. Go to: **Stack Management** → **Index Patterns**
2. Click **Create index pattern**
3. Enter: `wikipedia-changes-*`
4. Click **Next step**
5. Select **@timestamp** as the time field
6. Click **Create index pattern**

## Step 6: Explore Your Data

1. Click the menu (☰)
2. Go to **Discover**
3. You should see real-time Wikipedia changes!

## What You Should See

In the Discover tab, you'll see documents with fields like:
- `title`: Page that was edited
- `user`: Who made the edit
- `bot`: Whether it was a bot
- `wiki`: Which wiki (enwiki, dewiki, etc.)
- `type`: edit, new, log, etc.
- `length.new` and `length.old`: Size changes

## Quick Visualizations

Try creating these simple visualizations:

### 1. Edits Over Time (Line Chart)
- Go to **Visualize** → **Create visualization**
- Choose **Line**
- Select your index pattern
- Y-axis: Count
- X-axis: Date Histogram on @timestamp
- Click **Update**

### 2. Bot vs Human (Pie Chart)
- Create visualization → **Pie**
- Slice by: Terms aggregation on `bot` field
- Click **Update**

### 3. Top Wikis (Data Table)
- Create visualization → **Data Table**
- Rows: Terms aggregation on `wiki.keyword`
- Metric: Count
- Size: 10

## Explore the Examples

Check out the `examples/` directory for:
- **elasticsearch-queries.md**: Sample queries to try
- **kibana-guide.md**: Detailed Kibana walkthrough
- **logstash-modifications.md**: Ideas for customizing the pipeline
- **docker-commands.md**: Docker management reference
- **data-pipeline.md**: Understanding the architecture

## Troubleshooting

### No data appearing?

```bash
# Check Logstash logs
docker compose logs logstash

# Verify services are healthy
docker compose ps
```

### Services won't start?

```bash
# Check ports aren't in use
netstat -tuln | grep -E '9200|5601|9600'

# View error logs
docker compose logs
```

### Out of memory?

Edit `docker-compose.yml` and reduce memory settings:
```yaml
environment:
  - "ES_JAVA_OPTS=-Xms256m -Xmx256m"  # Reduce from 512m
```

### Need to start over?

```bash
# Complete reset (deletes all data!)
docker compose down -v
docker compose up -d
```

## Next Steps

Now that you have data flowing:

1. ✅ **Explore the data** - What patterns can you find?
2. ✅ **Try the example queries** - See `examples/elasticsearch-queries.md`
3. ✅ **Build a dashboard** - Combine multiple visualizations
4. ✅ **Modify the pipeline** - Customize `logstash/pipeline/wikimedia.conf`
5. ✅ **Create alerts** - Set up notifications for interesting patterns

## Learning Challenges

### Beginner
- [ ] Find the most active Wikipedia language
- [ ] Count bot edits vs human edits
- [ ] Identify the most edited page

### Intermediate
- [ ] Calculate average edit size per wiki
- [ ] Find pages with the most frequent changes
- [ ] Create a dashboard with 5 visualizations

### Advanced
- [ ] Detect unusual edit patterns
- [ ] Build a real-time monitoring dashboard
- [ ] Implement custom data enrichment in Logstash

## Resources

- Main README: `README.md`
- Example queries: `examples/elasticsearch-queries.md`
- Kibana guide: `examples/kibana-guide.md`
- Docker commands: `examples/docker-commands.md`
- Pipeline explanation: `examples/data-pipeline.md`

## Getting Help

If you're stuck:
1. Check the logs: `docker compose logs [service-name]`
2. Review the examples directory
3. Search for error messages online
4. Experiment - you can't break anything!

---

**Ready to dive in?** Start exploring and have fun learning the ELK stack!
