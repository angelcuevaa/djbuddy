#look for songs based on audio file

#want to implement a microphone feature to work like shazam

#once we get song from shazamio, we take isrc to search on spotify
# get song from spotify since shazamio only returns from apple music
# spotify returns the key of the song
#  use spotify recommendation endpoint to get songs are similar based on key

import asyncio
from shazamio import Shazam, Serialize
import json
# import librosa
import numpy as np



async def shazam(file):
  shazam = Shazam()
  # out = await shazam.recognize_song('dora.ogg') # slow and deprecated, don't use this!
  out = await shazam.recognize(file)
  # out = await shazam.recognize('C:\\Users\\angel\\OneDrive\Documents\\Playground\\Music App\\audio_files\\oddmob.mp3')  # rust version, use this!
  return out


#finding tempo
# y, sr = librosa.load("audio_files\\audio.mp3")
# tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr)
# print("Tempo:", tempo)





