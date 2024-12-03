from django.apps import AppConfig


class ApiConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "api"

    def ready(self):
        from api import signals
        _ = signals  # 명시적으로 사용하여 경고 제거
