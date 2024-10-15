#look for songs based on audio file

#want to implement a microphone feature to work like shazam

#once we get song from shazamio, we take isrc to search on spotify
# get song from spotify since shazamio only returns from apple music
# spotify returns the key of the song
#  use spotify recommendation endpoint to get songs are similar based on key

#https://developer.spotify.com/documentation/web-api/reference/get-audio-features
#https://developer.spotify.com/documentation/web-api/reference/get-recommendations
#https://developer.spotify.com/documentation/web-api/reference/get-an-artist
#https://developer.spotify.com/documentation/web-api/reference/search

import asyncio
from shazamio import Shazam, Serialize
import json
import librosa
import numpy as np



# async def main():
#   shazam = Shazam()
#   # out = await shazam.recognize_song('dora.ogg') # slow and deprecated, don't use this!
#   out = await shazam.recognize('audio_files\\x.wav')  # rust version, use this!
#   print(json.dumps(out))

async def main():
  shazam = Shazam()
  track_id = 692700920
  related = await shazam.related_tracks(track_id=track_id, limit=5, offset=2)
  # ONLY №3, №4 SONG
  print(related)

# async def main():
#   shazam = Shazam()
#   track_id = 692700920
#   about_track = await shazam.track_about(track_id=track_id)
#   serialized = Serialize.track(data=about_track)

#   print(json.dumps(about_track))  # dict
#   print(serialized)  # serialized from dataclass factory


# file_path = open("audio_files\\x.wav", "r")
# print(type(file_path))

loop = asyncio.get_event_loop()
loop.run_until_complete(main())

#finding tempo
# y, sr = librosa.load("audio_files\\audio.mp3")
# tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr)
# print("Tempo:", tempo)





