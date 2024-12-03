from django.db.models.signals import post_delete
from django.dispatch import receiver
from django.contrib.auth.models import User
from .models import Favorite


@receiver(post_delete, sender=User)
def delete_favorites_on_user_delete(sender, instance, **kwargs):
    # 사용자가 삭제되면 관련 즐겨찾기 삭제
    Favorite.objects.filter(user=instance).delete()
