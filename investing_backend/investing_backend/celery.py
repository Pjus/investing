from __future__ import absolute_import, unicode_literals
import os
from celery import Celery

# Django의 기본 설정 모듈을 Celery에 알립니다.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'investing_backend.settings')

app = Celery('investing_backend')

# Django 설정에서 namespace가 CELERY인 항목을 모두 가져옵니다.
app.config_from_object('django.conf:settings', namespace='CELERY')

# 등록된 모든 앱에서 tasks.py 파일을 찾아 등록합니다.
app.autodiscover_tasks()
