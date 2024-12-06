from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from api.scheduler import save_stocks_to_db  # 새로 작성한 함수 임포트

def start_scheduler():
    scheduler = BackgroundScheduler()
    scheduler.add_job(
        save_stocks_to_db,
        trigger=CronTrigger(hour=10, minute=0),  # 매일 오전 10시에 실행
        id='save_stocks_job',
        replace_existing=True,
    )
    scheduler.start()
