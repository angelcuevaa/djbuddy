import json
from django.shortcuts import render
from rest_framework.views import APIView
import requests
from .utils import updateOrCreateUserTokens
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .utils import getCreds, executeSpotifyRequest
from .serizlizer import SpotifyTokenSerializer

# @api_view(['GET'])
# def getSpotify(request):
#     response = getCreds()
#     serializer = SpotifyTokenSerializer(response, many=False)
#     return Response(serializer.data)

         
@api_view(['POST'])
def getTrack(request):
    body_unicode = request.body.decode('utf-8')
    body = json.loads(body_unicode)
    isrc = body.get("isrc")
    if not isrc:
        return Response({"error": "ISRC is a required parameter"}, status=400)

    params = {
        "q": f'isrc:{isrc}',
        "type": "track",
        "limit": 1
    }
    search_response = executeSpotifyRequest("/search", params)
    search_item_arr = search_response.get("tracks", {}).get("items", [])
    if (len(search_item_arr) < 1):
        return Response({"message": "No tracks matching ISRC"}, status=200)
    spotify_track = search_item_arr[0]

    #track_features_response = executeSpotifyRequest(f'/audio-features/{spotify_track_id}')

    return Response(spotify_track)

@api_view(['GET'])
def getTrackDetails(request):
    if not 'track_id' in request.GET:
         return Response({"error": "track_id is a required parameter"}, status=400)
    track_id = request.GET["track_id"]
    track_details = executeSpotifyRequest(f'/audio-features/{track_id}')
    camelot_dict = {
        (0,1):'8B',
		(1,1):'3B',
		(2,1):'10B',
		(3,1):'5B',
		(4,1):'12B',
		(5,1):'7B',
		(6,1):'2B',
		(7,1):'9B',
		(8,1):'4B',
		(9,1):'11B',
		(10,1):'6B',
		(11,1):'1B',
		(0,0):'5A',
		(1,0):'12A',
		(2,0):'7A',
		(3,0):'2A',
		(4,0):'9A',
		(5,0):'4A',
		(6,0):'11A',
		(7,0):'6A',
		(8,0):'1A',
		(9,0):'8A',
		(10,0):'3A',
		(11,0):'10A'
    }
    track_details["camelot"] = camelot_dict[(track_details.get("key"), track_details.get("mode"))]
    return Response(track_details) 

@api_view(['GET'])
def getRecommendations(request):
    #seed tracks, min tempo, key
    if (not 'track_id' in request.GET) or (not 'tempo' in request.GET) or (not 'key' in request.GET):
         return Response({"error": "track_id, tempo, and key are required parameters"}, status=400)
    track_id = request.GET["track_id"]
    tempo = int(request.GET["tempo"])
    key = request.GET["key"]
    params = {
        "seed_tracks": track_id,
        "min_tempo": tempo - 5,
        "max_tempo": tempo + 5,
        "target_key": key,
        "limit": 10
    }
    recommendations_response = executeSpotifyRequest(f'/recommendations',params)
    return Response(recommendations_response)

