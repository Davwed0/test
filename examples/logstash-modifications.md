# Logstash Configuration Examples

Learn by modifying the Logstash pipeline! Here are some ideas to experiment with.

## Current Pipeline Location

`logstash/pipeline/wikimedia.conf`

## Understanding the Pipeline

Every Logstash configuration has three sections:
- **input**: Where data comes from
- **filter**: How to transform/enrich the data
- **output**: Where to send the processed data

## Modification Ideas

### 1. Add Debug Output

Uncomment the stdout section in the output to see data in logs:

```
output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "wikipedia-changes-%{+YYYY.MM.dd}"
  }
  
  stdout {
    codec => rubydebug
  }
}
```

Then check logs: `docker-compose logs -f logstash`

### 2. Add More Tags

Add conditional tags for large changes:

```
if [length][new] and [length][old] {
  ruby {
    code => "
      new_len = event.get('[length][new]').to_i
      old_len = event.get('[length][old]').to_i
      diff = (new_len - old_len).abs
      event.set('change_size', diff)
    "
  }
  
  if [change_size] > 5000 {
    mutate {
      add_tag => ["large_change"]
    }
  }
}
```

### 3. Create Custom Fields

Extract language from wiki field:

```
if [wiki] {
  grok {
    match => { "wiki" => "^(?<language>[a-z]+)wiki$" }
  }
}
```

### 4. Filter Out Unwanted Data

Only keep human edits:

```
if [bot] == true {
  drop { }
}
```

### 5. Enrich with Metadata

Add processing timestamp:

```
mutate {
  add_field => {
    "processed_at" => "%{@timestamp}"
  }
}
```

### 6. Multiple Outputs

Send different types to different indices:

```
output {
  if "bot_edit" in [tags] {
    elasticsearch {
      hosts => ["http://elasticsearch:9200"]
      index => "wikipedia-bots-%{+YYYY.MM.dd}"
    }
  } else {
    elasticsearch {
      hosts => ["http://elasticsearch:9200"]
      index => "wikipedia-humans-%{+YYYY.MM.dd}"
    }
  }
}
```

## Challenge Tasks

1. Create a field that categorizes wikis by language family
2. Add a tag for "new_page" when type is "new"
3. Calculate and store the change velocity (size/time)
4. Add geographic information based on server_name
5. Create a sentiment indicator based on comment text

## Testing Your Changes

1. Edit the configuration file
2. Restart Logstash: `docker-compose restart logstash`
3. Check logs for errors: `docker-compose logs logstash`
4. Query Elasticsearch to verify your changes worked

## Logstash Filter Plugins Reference

- `mutate`: Modify fields (add, remove, rename, replace)
- `grok`: Parse unstructured text with patterns
- `date`: Parse timestamps
- `ruby`: Execute Ruby code for complex transformations
- `json`: Parse JSON strings
- `drop`: Discard events
- `clone`: Duplicate events

## Common Patterns

### Safe Field Access
```
if [field][subfield] {
  # Only runs if field.subfield exists
}
```

### Multiple Conditions
```
if [bot] == false and [minor] == false {
  # Both conditions must be true
}
```

### Field Data Types
```
mutate {
  convert => {
    "field_name" => "integer"
    "another_field" => "boolean"
  }
}
```

Remember: After changing the pipeline, always restart Logstash!
