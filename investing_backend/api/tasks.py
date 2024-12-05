from celery import shared_task
from .utils import save_stocks_to_db

@shared_task
def fetch_and_save_stocks():
    save_stocks_to_db()
