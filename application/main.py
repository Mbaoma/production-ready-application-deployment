from fastapi import FastAPI

app = FastAPI(
    title="FastAPI DevOps Assessment",
    version="1.0.0",
    description="A simple FastAPI service deployed with Docker, Terraform, GitHub Actions, and AWS EC2."
)


@app.get("/")
async def root():
    return {
        "message": "Hello from the FastAPI DevOps Assessment API",
        "service": "fastapi-devops-assessment",
        "version": "1.0.0"
    }


@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "fastapi-devops-assessment",
        "version": "1.0.0"
    }


@app.get("/ready")
async def readiness_check():
    return {
        "status": "ready",
        "service": "fastapi-devops-assessment",
        "version": "1.0.0"
    }