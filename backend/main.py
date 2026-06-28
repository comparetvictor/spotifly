from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import tracks

app = FastAPI(title="Spotifly API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(tracks.router)

@app.get("/")
def root():
    return {"message": "Spotifly API is running"}

@app.get("/health")
def health():
    return {"status": "ok"}
