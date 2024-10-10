from django.urls import path
from . import views
from django.conf import settings

urlpatterns = [
    path('', views.getSpotify),
    path("/track", views.getTrack),
    path("/track-details", views.getTrackDetails),
    path("/recommendations", views.getRecommendations)
]