# Elasticsearch Query Examples

These are examples to help you get started with querying Wikipedia changes.

## Basic Queries

### Match All Documents
```json
GET wikipedia-changes-*/_search
{
  "query": {
    "match_all": {}
  },
  "size": 10
}
```

### Search for Specific Wiki
```json
GET wikipedia-changes-*/_search
{
  "query": {
    "match": {
      "wiki": "enwiki"
    }
  }
}
```

### Find Bot Edits
```json
GET wikipedia-changes-*/_search
{
  "query": {
    "term": {
      "bot": true
    }
  }
}
```

## Aggregations

### Count by Edit Type
```json
GET wikipedia-changes-*/_search
{
  "size": 0,
  "aggs": {
    "types": {
      "terms": {
        "field": "type.keyword"
      }
    }
  }
}
```

### Edits per Wiki
```json
GET wikipedia-changes-*/_search
{
  "size": 0,
  "aggs": {
    "wikis": {
      "terms": {
        "field": "wiki.keyword",
        "size": 20
      }
    }
  }
}
```

### Time-based Histogram
```json
GET wikipedia-changes-*/_search
{
  "size": 0,
  "aggs": {
    "edits_over_time": {
      "date_histogram": {
        "field": "@timestamp",
        "fixed_interval": "1m"
      }
    }
  }
}
```

## Advanced Queries

### Bool Query - Multiple Conditions
```json
GET wikipedia-changes-*/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "bot": false } }
      ],
      "must_not": [
        { "term": { "minor": true } }
      ],
      "filter": [
        { "range": { "length.new": { "gte": 1000 } } }
      ]
    }
  }
}
```

### Nested Aggregations
```json
GET wikipedia-changes-*/_search
{
  "size": 0,
  "aggs": {
    "by_wiki": {
      "terms": {
        "field": "wiki.keyword"
      },
      "aggs": {
        "by_type": {
          "terms": {
            "field": "type.keyword"
          }
        }
      }
    }
  }
}
```

## Challenge Queries

Try to write queries for these:
1. Find the top 10 most active users
2. Calculate average change size per wiki
3. Find edits that created new pages
4. Identify patterns in minor vs major edits
5. Create a metric showing bot activity percentage

## Tips

- Use `"size": 0` to get only aggregations without documents
- The `.keyword` suffix accesses the non-analyzed version of text fields
- Range queries work with numeric and date fields
- Bool queries can combine multiple conditions with `must`, `should`, `must_not`, and `filter`
