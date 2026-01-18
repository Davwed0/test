# ELK Stack Learning Lab

Welcome to the ELK Stack hands-on learning environment! This setup uses real-time data from Wikipedia to help you learn Elasticsearch, Logstash, and Kibana.

> **🚀 New here?** Check out the [Quick Start Guide](QUICKSTART.md) to get up and running in 5 minutes!

## What's Inside?

This environment contains:
- **Elasticsearch**: A search and analytics engine
- **Logstash**: A data processing pipeline
- **Kibana**: A data visualization platform
- **Live Data Source**: Real-time Wikipedia changes

## Getting Started

```bash
# Using Docker Compose v2 (recommended)
docker compose up -d

# Or using Docker Compose v1
docker-compose up -d
```

**Note**: First startup may take 2-3 minutes as services initialize and start collecting data.

## Access Points

- Elasticsearch: http://localhost:9200
- Kibana: http://localhost:5601
- Logstash: http://localhost:9600

## Your Mission

You're receiving live data from Wikipedia's recent changes stream. Your job is to explore, analyze, and visualize this data.

### Challenges to Explore

1. **Data Discovery**
   - What kind of data is being collected?
   - How many fields does each document have?
   - What does the data structure look like?

2. **Search Queries**
   - Can you find all edits made by bots?
   - What about minor edits vs major edits?
   - Which wikis (languages) are most active?

3. **Aggregations**
   - What's the distribution of edit types?
   - How many changes per minute are happening?
   - Which users are most active?

4. **Visualizations**
   - Create a timeline of edits
   - Build a pie chart of bot vs human edits
   - Map edits by wiki domain

5. **Advanced Patterns**
   - Can you detect vandalism patterns?
   - What's the average size of changes?
   - Are there any interesting time-based patterns?

## Hints

<details>
<summary>Click to reveal hints (try figuring it out first!)</summary>

### Checking if Elasticsearch is Running
```bash
curl http://localhost:9200
```

### Viewing Available Indices
```bash
curl http://localhost:9200/_cat/indices?v
```

### Sample Query in Kibana Dev Tools
```json
GET wikipedia-changes-*/_search
{
  "query": {
    "match_all": {}
  }
}
```

### Creating an Index Pattern in Kibana
1. Go to Stack Management → Index Patterns
2. Create a pattern matching your indices
3. Use `@timestamp` as the time field

### Useful Logstash Commands
```bash
# View logs
docker compose logs -f logstash

# Restart a service
docker compose restart logstash
```

</details>

## Data Source

The data comes from: https://stream.wikimedia.org/v2/stream/recentchange

This is a real-time stream of all changes happening across Wikipedia projects worldwide.

## Experiments to Try

### Experiment 1: Modify the Pipeline
- Edit `logstash/pipeline/wikimedia.conf`
- Add new filters or transformations
- Restart Logstash to apply changes

### Experiment 2: Custom Index Names
- Change the index naming pattern
- See how it affects Kibana queries

### Experiment 3: Field Analysis
- Add calculated fields
- Enrich the data with additional information
- Create custom tags

## Troubleshooting

If something isn't working:
1. Check container logs: `docker compose logs [service-name]`
2. Verify containers are running: `docker compose ps`
3. Restart everything: `docker compose restart`
4. Nuclear option: `docker compose down -v && docker compose up -d`

## Resources

- [Elasticsearch Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html)
- [Logstash Configuration](https://www.elastic.co/guide/en/logstash/current/configuration.html)
- [Kibana User Guide](https://www.elastic.co/guide/en/kibana/current/index.html)

## Clean Up

When you're done:
```bash
docker compose down
# To also remove volumes and data:
docker compose down -v
```

---

**Remember**: The best way to learn is by doing. Don't just read - experiment, break things, and figure out how to fix them!