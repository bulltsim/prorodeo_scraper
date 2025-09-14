from prometheus_client import Counter, Gauge, start_http_server

PAGES_SCRAPED = Counter("pages_scraped_total", "Total index pages scraped")
STOCKS_PROCESSED = Counter("stocks_processed_total", "Total stock profiles processed")
SCRAPER_ERRORS = Counter("scraper_errors_total", "Total errors during scrape")
QUEUE_REMAINING = Gauge("queue_remaining", "URLs remaining in queue")


def start_metrics_server(port: int = 8000):
    """Starts a Prometheus metrics HTTP server on the given port."""
    start_http_server(port)
