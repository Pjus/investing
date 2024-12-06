# api/management/commands/start_scheduler.py
from django.core.management.base import BaseCommand
from api.scheduler import start_scheduler

class Command(BaseCommand):
    help = 'Start the scheduler'

    def handle(self, *args, **kwargs):
        start_scheduler()
        self.stdout.write("Scheduler started.")
