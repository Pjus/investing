from __future__ import absolute_import, unicode_literals

# Celery 앱을 로드합니다.
from .celery import app as celery_app

__all__ = ('celery_app',)
