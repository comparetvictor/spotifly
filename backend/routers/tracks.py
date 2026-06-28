from fastapi import APIRouter, HTTPException
from models.track import Track
from typing import List

router = APIRouter(prefix="/tracks", tags=["tracks"])

tracks_db: List[Track] = []
counter = 0

@router.get("/", response_model=List[Track])
def get_tracks():
    return tracks_db

@router.post("/", response_model=Track)
def add_track(track: Track):
    global counter
    counter += 1
    track.id = counter
    tracks_db.append(track)
    return track

@router.delete("/{track_id}")
def delete_track(track_id: int):
    global tracks_db
    track = next((t for t in tracks_db if t.id == track_id), None)
    if not track:
        raise HTTPException(status_code=404, detail="Morceau introuvable")
    tracks_db = [t for t in tracks_db if t.id != track_id]
    return {"message": "Morceau supprimé"}