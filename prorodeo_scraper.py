#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Entry point for the ProRodeo scraper.

This is a placeholder script. Implement the actual scraping logic
according to your project requirements.
"""

from metrics import start_metrics_server

def main():
    # Start Prometheus metrics server on default port
    start_metrics_server(8000)
    print("ProRodeo scraper started. Implement scraping logic here.")

if __name__ == "__main__":
    main()
