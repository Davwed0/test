# Kibana Exploration Guide

Kibana is your window into the data. Here's how to start exploring.

## First Steps

1. **Wait for Data**: After starting the stack, wait 1-2 minutes for data to flow
2. **Check Elasticsearch**: `curl http://localhost:9200/_cat/indices?v`
3. **Open Kibana**: Navigate to http://localhost:5601

## Creating Your First Index Pattern

1. Click on the menu (☰) → Stack Management → Index Patterns
2. Click "Create index pattern"
3. Enter pattern: `wikipedia-changes-*`
4. Click "Next step"
5. Select Time field: `@timestamp`
6. Click "Create index pattern"

## Discover

The Discover tab is where you explore raw data.

### Things to Try:
- View recent documents
- Add/remove columns (click the + next to field names)
- Create searches and save them
- Filter by clicking on field values
- Look at the document structure (expand documents)

### Useful Filters:
- `bot: true` - Only bot edits
- `minor: false` - Only major edits  
- `type: "edit"` - Only page edits
- `wiki: "enwiki"` - Only English Wikipedia

## Visualizations

Create visualizations to understand patterns.

### Visualization Ideas:

1. **Line Chart**: Edits over time
   - Aggregation: Date Histogram on @timestamp
   - Metric: Count

2. **Pie Chart**: Bot vs Human edits
   - Slice by: Terms on `bot` field
   - Metric: Count

3. **Data Table**: Top Wikis
   - Rows: Terms on `wiki.keyword`
   - Metric: Count
   - Sort by count descending

4. **Vertical Bar**: Edit Types
   - X-axis: Terms on `type.keyword`
   - Y-axis: Count

5. **Metric**: Total edits count
   - Just use Count aggregation

6. **Tag Cloud**: Most edited pages
   - Tags: Terms on `title.keyword`
   - Size: Count

## Building Dashboards

Dashboards combine multiple visualizations.

### Dashboard Challenge:
Create a dashboard with:
- Total edit count (Metric)
- Edits timeline (Line chart)
- Bot vs Human ratio (Pie chart)
- Top 10 active wikis (Bar chart)
- Recent changes table (Saved search)

### Tips:
- Save each visualization first
- Create new dashboard
- Add visualizations from library
- Arrange and resize as needed
- Set auto-refresh (top right)

## Dev Tools / Console

The Console lets you run Elasticsearch queries directly.

Access: Menu → Dev Tools

Try these queries:
```
GET _cat/indices?v

GET wikipedia-changes-*/_count

GET wikipedia-changes-*/_mapping

GET wikipedia-changes-*/_search
{
  "size": 5,
  "query": {
    "match_all": {}
  }
}
```

## Advanced Features to Explore

### 1. Canvas
Create pixel-perfect reports and infographics

### 2. Maps
If you add geo data, visualize it geographically

### 3. Machine Learning
Detect anomalies in edit patterns (requires license)

### 4. Alerts
Set up notifications for specific conditions

### 5. Lens
Drag-and-drop visualization builder

## Challenges

### Beginner:
1. Find how many edits happened in the last hour
2. Identify the most active wiki
3. Create a simple dashboard with 3 visualizations

### Intermediate:
1. Build a comparison between bot and human edit patterns
2. Find edits that added more than 1000 characters
3. Create a time-series showing edit velocity

### Advanced:
1. Detect unusual spikes in edit activity
2. Build a dashboard showing edit quality indicators
3. Create a multi-level drill-down visualization
4. Set up saved searches for monitoring

## Troubleshooting

### No Data Showing?
- Check if indices exist: `curl http://localhost:9200/_cat/indices?v`
- Verify Logstash is running: `docker compose ps`
- Check Logstash logs: `docker compose logs logstash`
- Adjust time range in Kibana (top right)

### Visualization Not Working?
- Verify index pattern is correct
- Check if field exists in your data
- Try refreshing field list in index pattern settings

### Performance Issues?
- Limit time range
- Reduce number of documents loaded
- Use aggregations instead of raw documents

## Quick Reference

### Kibana Query Language (KQL)
```
bot: true
wiki: "enwiki" or wiki: "dewiki"
type: "edit" and not minor: true
length.new > 1000
```

### Lucene Query Syntax
```
bot:true
wiki:(enwiki OR dewiki)
type:edit AND -minor:true
length.new:[1000 TO *]
```

## Best Practices

1. **Start Simple**: Build basic visualizations first
2. **Use Time Ranges**: Don't load all data at once
3. **Save Your Work**: Save searches and visualizations
4. **Organize**: Use naming conventions for your assets
5. **Experiment**: Try different visualization types
6. **Refresh**: Use auto-refresh for live monitoring

---

Remember: Kibana is powerful but intuitive. Click around, try things, and learn by doing!
