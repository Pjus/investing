# api/scheduler.py
import django
from apscheduler.schedulers.background import BackgroundScheduler
from api.tasks import save_stocks_to_db  # 태스크 함수 불러오기

def start_scheduler():
    # Django 초기화
    django.setup()
    
    scheduler = BackgroundScheduler()
    scheduler.add_job(save_stocks_to_db, 'interval', hours=1)  # 매 1시간마다 실행
    scheduler.start()

