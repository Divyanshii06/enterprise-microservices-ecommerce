#!/usr/bin/env python3
"""
Concurrent load generator to hit the order processing endpoint.
Requirements: pip install requests
"""
import os
import time
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed

TARGET = os.environ.get('TARGET_URL', 'http://localhost:8081/api/orders/process')
AUTH = os.environ.get('AUTH_TOKEN')
CONCURRENCY = int(os.environ.get('CONCURRENCY', '200'))
TOTAL_REQUESTS = int(os.environ.get('TOTAL_REQUESTS', '1600'))  # 1,600 by default

def make_request(i):
    headers = {}
    if AUTH:
        headers['Authorization'] = f'Bearer {AUTH}'
    try:
        start = time.time()
        r = requests.post(TARGET, params={'userId': i % 1000}, headers=headers, timeout=10)
        latency = time.time() - start
        return (r.status_code, latency)
    except Exception as e:
        return (0, None)

def main():
    print(f"Target: {TARGET}")
    print(f"Concurrent workers: {CONCURRENCY}, total requests: {TOTAL_REQUESTS}")
    successes = 0
    latencies = []
    with ThreadPoolExecutor(max_workers=CONCURRENCY) as ex:
        futures = [ex.submit(make_request, i) for i in range(TOTAL_REQUESTS)]
        for f in as_completed(futures):
            status, lat = f.result()
            if status and 200 <= status < 300:
                successes += 1
                latencies.append(lat)

    print(f"Completed. Successes: {successes}/{TOTAL_REQUESTS}")
    if latencies:
        print(f"Avg latency: {sum(latencies)/len(latencies):.3f}s")

if __name__ == '__main__':
    main()
