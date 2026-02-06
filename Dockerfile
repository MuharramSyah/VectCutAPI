FROM python:3.10-slim

# Avoid Python buffering issues
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies (ffmpeg + basic libs)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (better layer caching)
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# If you plan to use MCP features, uncomment this:
# COPY requirements-mcp.txt requirements-mcp.txt
# RUN pip install --no-cache-dir -r requirements-mcp.txt

# Copy the rest of the application
COPY . .
COPY config.json.example config.json
# Expose API port (default is 9001)
EXPOSE 9001

# Start the API server
CMD ["python", "capcut_server.py"]
