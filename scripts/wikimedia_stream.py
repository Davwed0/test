#!/usr/bin/env python3
"""
Wikimedia Recent Changes Stream Consumer
Reads from Wikimedia's SSE stream and outputs JSON to stdout
"""

import sys
import json
import requests
import time

STREAM_URL = "https://stream.wikimedia.org/v2/stream/recentchange"

def consume_stream():
    """Consume the Wikimedia recent changes stream."""
    while True:
        try:
            response = requests.get(STREAM_URL, stream=True, timeout=60)
            response.raise_for_status()
            
            for line in response.iter_lines():
                if line:
                    line = line.decode('utf-8')
                    # SSE format: "data: {json}"
                    if line.startswith('data: '):
                        json_data = line[6:]  # Remove "data: " prefix
                        try:
                            # Parse and re-output to ensure valid JSON
                            data = json.loads(json_data)
                            print(json.dumps(data), flush=True)
                        except json.JSONDecodeError:
                            continue
                            
        except requests.exceptions.RequestException as e:
            print(f"Connection error: {e}", file=sys.stderr)
            time.sleep(5)  # Wait before reconnecting
            continue
        except KeyboardInterrupt:
            break

if __name__ == "__main__":
    consume_stream()
