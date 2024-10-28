from django.db import models

# Create your models here.
class SpotifyToken(models.Model):
    user = models.CharField(max_length=100, null=True)
    access_token = models.CharField(max_length=100,  null=True)
    # refresh_token = models.CharField(max_length=100,  null=True)
    token_type = models.CharField(max_length=100,  null=True)
    expires_in = models.DateTimeField( null=True)
    created_at = models.DateTimeField( null=True)

    def __str__(self):
        return self.user