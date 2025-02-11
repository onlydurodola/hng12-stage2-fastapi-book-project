# Builder
FROM python:3.12-slim as builder

WORKDIR /app
COPY requirements.txt .

# Install dependencies
RUN pip install --user --no-cache-dir -r requirements.txt

# Runtime
FROM python:3.12-slim

# Create non-root user
RUN adduser --disabled-password --gecos "" appuser

WORKDIR /app
COPY --from=builder /root/.local /home/appuser/.local  
COPY . .

# Set ownership and permissions
RUN chown -R appuser:appuser /app
USER appuser

# Environment configuration
ENV PATH="/home/appuser/.local/bin:$PATH" \
    PYTHONPATH=/app \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
