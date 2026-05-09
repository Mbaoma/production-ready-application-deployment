from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


def test_read_root():
    response = client.get("/")

    assert response.status_code == 200
    assert response.json() == {
        "message": "Hello from the FastAPI DevOps Assessment API",
        "service": "fastapi-devops-assessment",
        "version": "1.0.0"
    }


def test_health_check():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {
        "status": "healthy",
        "service": "fastapi-devops-assessment",
        "version": "1.0.0"
    }


def test_readiness_check():
    response = client.get("/ready")

    assert response.status_code == 200
    assert response.json() == {
        "status": "ready",
        "service": "fastapi-devops-assessment",
        "version": "1.0.0"
    }