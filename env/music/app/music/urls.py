from django.urls import path
from . import views
from django.conf import settings

urlpatterns = [
    path('recognize',views.MyViewSet.recognizeTrack ),
    path("recommendations", views.MyViewSet.recommendations)
]