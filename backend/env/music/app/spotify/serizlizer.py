from rest_framework import serializers
from .models import SpotifyToken

class SpotifyTokenSerializer(serializers.ModelSerializer):
    class Meta:
        model=SpotifyToken
        fields=('user', 'access_token', "expires_in")