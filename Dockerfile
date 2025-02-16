FROM python:3.12-slim-bookworm

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates tesseract-ocr libtesseract-dev

# Install Pillow and pytesseract
RUN pip install Pillow pytesseract

# Install uv (moved before app copy)
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Install FastAPI and Uvicorn
RUN pip install fastapi uvicorn python-dotenv sentence-transformers

# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin:$PATH"

# Set up the application directory
WORKDIR /app

# Copy all application files (including updated app directory structure)
COPY . /app

# Set the entrypoint to start the FastAPI application
CMD ["uv", "run", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]