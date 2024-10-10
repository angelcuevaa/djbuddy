from datetime import datetime, timedelta, timezone
from .models import SpotifyToken
import requests

BASE_URL = 'https://api.spotify.com/v1'

def getCreds():
        #credentials do exist
        if  SpotifyToken.objects.exists():
            #check if creds are exipired or not
            tokens = SpotifyToken.objects.first()
            #check if token expires within 5 min from now to avoid potential unauthorized error
            if(datetime.now(timezone.utc) + timedelta(minutes=5) > tokens.expires_in):
                createToken()
        #credentials do not exist
        else:
            createToken()
        return SpotifyToken.objects.first()
def createToken():
    data = {
            "grant_type": "client_credentials",
            "client_id": "5263c1f3c76245b69fc5f425050215ab",
            "client_secret": "71b7dec16c784e7a9f2fcbdaaa60f627"
            }

    response = requests.post("https://accounts.spotify.com/api/token",
                            headers={"Content-Type": "application/x-www-form-urlencoded"},
                            data=data
                        ).json()
    access_token = response.get('access_token')
    token_type = response.get('token_type')
    expires_in = response.get('expires_in')
    print (response)

    updateOrCreateUserTokens(access_token, token_type, expires_in)

def executeSpotifyRequest(endpoint, params=""):
    access_token = getCreds().access_token
    headers = {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        'Authorization': "Bearer " + access_token
    }

    response = requests.get(f'{BASE_URL + endpoint}', headers=headers, params=params)

    try:
         return response.json()
    except:
         return({"error": "Invalid request", "response": response})

    
# def refreshToken(refresh_token):
#         data = {
#                 "grant_type": "refresh_token",
#                 "client_id": "5263c1f3c76245b69fc5f425050215ab",
#                 "refresh_token": refresh_token
#                 }
#         response = requests.post("https://accounts.spotify.com/api/token",
#                                     headers={"Content-Type": "application/x-www-form-urlencoded"},
#                                     data=data
#                                 ).json()
#         access_token = response.get('access_token')
#         token_type = response.get('token_type')
#         refresh_token = response.get('refresh_token')
#         expires_in = response.get('expires_in')

#         updateOrCreateUserTokens(access_token, refresh_token, token_type, expires_in)

      
def updateOrCreateUserTokens(access_token, token_type, expires_in):
      tokens = ""
      expires_in = datetime.now(timezone.utc) + timedelta(seconds=expires_in)
      print(expires_in)
      if SpotifyToken.objects.exists():
            print("in exists")
            tokens = SpotifyToken.objects.first()
            tokens.access_token = access_token
            tokens.expires_in = expires_in
            tokens.save(update_fields=["user","access_token","expires_in"])
      else:
            tokens = SpotifyToken(user="admin", access_token=access_token, token_type=token_type, expires_in=expires_in)
            tokens.save()

