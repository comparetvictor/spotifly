from pydantic import BaseModel
from typing import Optional

class Track(BaseModel):
    id: Optional[int] = None
    title: str
    path: str
    artist: Optional[str] = None
    album: Optional[str] = None
    duration: Optional[int] = None
