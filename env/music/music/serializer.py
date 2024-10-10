from rest_framework import serializers
from .models import Data
class DataSerializer(serializers.ModelSerializer):
    class Meta:
        model=Data
        fields=('name', 'description')

class AudioSerializer(serializers.Serializer):
    audio = serializers.FileField() 
