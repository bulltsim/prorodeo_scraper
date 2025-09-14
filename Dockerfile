# Use Playwright Python container as base
FROM mcr.microsoft.com/playwright/python:v1.47.0-jammy

WORKDIR /app
# Copy Python scripts and dependencies spec; adjust if using Poetry
COPY prorodeo_scraper.py metrics.py pyproject.toml poetry.lock* ./

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir pandas aiosqlite beautifulsoup4 playwright-stealth prometheus-client pyarrow boto3

# Install Playwright dependencies (Chromium)
RUN playwright install chromium

ENV PYTHONUNBUFFERED=1 \
    METRICS_PORT=8000

EXPOSE 8000

CMD ["python", "prorodeo_scraper.py", "--workers", "10", "--headless", "--resume", "--export"]
