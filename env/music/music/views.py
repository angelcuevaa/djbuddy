from rest_framework.response import Response
from adrf.decorators import api_view
from .utils import shazam
from adrf.views import APIView
from .serializer import AudioSerializer






# def recognizeTrack(request):
#     # track = await shazam()
#     # print(track)
#     loop = asyncio.get_event_loop()
#     loop.run_until_complete(shazam())
#     #return Response({"response":"in"})

class MyViewSet (APIView):
    @api_view(['POST'])
    async def recognizeTrack(request):
        serializer = AudioSerializer(data=request.data)
        if not serializer.is_valid():
            return Response({"error": "expected audio file"})
        audio_file = serializer.validated_data['audio']
        track = await shazam(audio_file.file.read())
        return Response(track)
        # return Response(track)
    
# Create your views here.
