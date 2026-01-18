# Understanding the Data Pipeline

## Architecture Overview

```
Wikimedia SSE Stream → Python Script → Logstash → Elasticsearch → Kibana
```

### Components

1. **Python Stream Consumer** (`scripts/wikimedia_stream.py`)
   - Connects to Wikimedia's Server-Sent Events (SSE) stream
   - Parses the streaming data
   - Outputs JSON to stdout (one event per line)

2. **Logstash**
   - Reads from the Python script via exec input
   - Applies filters and transformations
   - Sends processed data to Elasticsearch

3. **Elasticsearch**
   - Stores the data in time-based indices
   - Provides search and aggregation capabilities

4. **Kibana**
   - Visualizes the data
   - Provides a query interface

## How It Works

### Data Flow

1. **Stream Connection**: The Python script maintains a persistent connection to:
   ```
   https://stream.wikimedia.org/v2/stream/recentchange
   ```

2. **Event Processing**: Each Wikipedia edit/change generates an event like:
   ```json
   {
     "id": 123456789,
     "type": "edit",
     "namespace": 0,
     "title": "Example Page",
     "user": "Username",
     "bot": false,
     "minor": false,
     "patrolled": true,
     "length": {
       "old": 1234,
       "new": 1456
     },
     "revision": {
       "old": 987654,
       "new": 987655
     },
     "server_name": "en.wikipedia.org",
     "wiki": "enwiki",
     "timestamp": 1642521234
   }
   ```

3. **Logstash Processing**: Filters add:
   - Tags for categorization (bot_edit, minor_edit)
   - Computed fields (event_type, wiki_domain)
   - Timestamp parsing

4. **Elasticsearch Storage**: Data is indexed in daily indices:
   ```
   wikipedia-changes-2026.01.18
   wikipedia-changes-2026.01.19
   ...
   ```

5. **Kibana Access**: Query, visualize, and explore the indexed data

## Event Types

The stream includes various event types:

- **edit**: Modification to existing pages
- **new**: New page creation
- **log**: Administrative actions (delete, protect, etc.)
- **categorize**: Category changes
- **external**: External link additions

## Interesting Fields

### User Activity
- `user`: Username of the editor
- `bot`: Boolean indicating if it's a bot edit
- `anonymous`: Boolean for anonymous edits

### Change Metadata
- `minor`: Boolean for minor edits
- `patrolled`: Boolean for patrolled changes
- `length.old` & `length.new`: Page size before/after

### Location
- `wiki`: Wiki identifier (enwiki, dewiki, frwiki, etc.)
- `server_name`: Full domain (en.wikipedia.org)
- `namespace`: Namespace ID (0=article, 1=talk, etc.)

### Content
- `title`: Page title
- `comment`: Edit summary/comment
- `timestamp`: Unix timestamp of the change

## Customization Ideas

### Modify the Python Script

Add filtering before Logstash:
```python
# Only pass edits to main namespace (articles)
if data.get('namespace') == 0:
    print(json.dumps(data), flush=True)
```

Add enrichment:
```python
# Add language code
if 'wiki' in data:
    data['language'] = data['wiki'][:2]
```

### Modify Logstash Pipeline

The pipeline configuration is in `logstash/pipeline/wikimedia.conf`:

- **Filter section**: Transform and enrich data
- **Output section**: Control where data goes
- **Input section**: Configure how data is consumed

### Performance Tuning

If the stream is too fast:
```python
# In wikimedia_stream.py, add throttling
import time
time.sleep(0.1)  # After each event
```

If you want more data:
```python
# Connect to multiple streams
# Use threading to consume multiple wikis simultaneously
```

## Monitoring the Pipeline

### Check Data Flow

```bash
# Watch Logstash logs
docker compose logs -f logstash

# Count documents in Elasticsearch
curl http://localhost:9200/wikipedia-changes-*/_count

# See pipeline statistics
curl http://localhost:9600/_node/stats/pipelines?pretty
```

### Verify Stream Connection

```bash
# Test the Python script directly
python3 scripts/wikimedia_stream.py | head -10
```

## Troubleshooting

### No Data Appearing

1. Check Logstash logs: `docker compose logs logstash`
2. Verify Python script works: Test locally
3. Check network connectivity to Wikimedia
4. Ensure Elasticsearch is healthy: `curl http://localhost:9200/_cluster/health`

### High Resource Usage

1. Add filtering in Python script to reduce volume
2. Adjust Logstash memory: Edit `LS_JAVA_OPTS` in docker-compose.yml
3. Delete old indices to free disk space

### Stream Disconnects

The Python script automatically reconnects after errors. Check logs for connection issues.

## Learning Challenges

1. **Modify the stream consumer** to filter events before they reach Logstash
2. **Add a dead letter queue** for failed events
3. **Implement rate limiting** to control data volume
4. **Create multiple pipelines** for different event types
5. **Add alerting** for unusual patterns (e.g., vandalism detection)

## Advanced Topics

### Multi-Pipeline Setup

Create separate pipelines for different wikis:
- One for English Wikipedia
- One for all other languages
- Different indices for each

### Data Enrichment

Add external data:
- GeoIP for user locations (if IPs available)
- User contribution history
- Page category information
- Language detection for edit comments

### Machine Learning

- Anomaly detection for unusual edit patterns
- Classification of edit types
- Prediction of vandalism
- User behavior clustering

---

**Remember**: Understanding the data flow is key to mastering the ELK stack!
