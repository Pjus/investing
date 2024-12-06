# from celery import shared_task
# from ..api.utils import save_stocks_to_db
# from django_celery_beat.models import PeriodicTask, PeriodicTasks

# PeriodicTask.objects.all().update(last_run_at=None)
# PeriodicTasks.update_changed()

# @shared_task
# def fetch_and_save_stocks():
#     save_stocks_to_db()
#     print("Stock Updated.")



from __future__ import absolute_import, unicode_literals
from .celery import app

from django.conf import settings

import django
django.setup()

from celery import shared_task

@shared_task
def test_task():
    print("hello world")