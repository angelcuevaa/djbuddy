# Generated by Django 5.1.1 on 2024-10-08 02:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('spotify', '0004_alter_spotifytoken_access_token_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='spotifytoken',
            name='access_token',
            field=models.CharField(max_length=100, null=True),
        ),
        migrations.AlterField(
            model_name='spotifytoken',
            name='created_at',
            field=models.DateTimeField(null=True),
        ),
        migrations.AlterField(
            model_name='spotifytoken',
            name='expires_in',
            field=models.DateTimeField(null=True),
        ),
        migrations.AlterField(
            model_name='spotifytoken',
            name='refresh_token',
            field=models.CharField(max_length=100, null=True),
        ),
        migrations.AlterField(
            model_name='spotifytoken',
            name='token_type',
            field=models.CharField(max_length=100, null=True),
        ),
        migrations.AlterField(
            model_name='spotifytoken',
            name='user',
            field=models.CharField(max_length=100, null=True),
        ),
    ]