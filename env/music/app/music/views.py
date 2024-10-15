from rest_framework.response import Response
from adrf.decorators import api_view
from .utils import shazam, recommend
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
    @api_view(['GET'])
    async def recommendations(request):


        if not 'track_id' in request.GET:
            return Response({"error": "track_id is a required parameter"}, status=400)
        track_id = int(request.GET["track_id"])
        track_details = await recommend(track_id)
        #return Response(track_details)
        if track_details.get("error"):
            return Response(track_details, status=400)
        return Response(track_details)
    
    
# Create your views here.
