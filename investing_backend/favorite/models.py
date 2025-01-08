from django.db import models
from django.contrib.auth.models import User
from django.db.models import UniqueConstraint
from django.db.models.functions import Lower


class Favorite(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="api_favorites"
    )
    ticker = models.CharField(max_length=10)
    name = models.CharField(max_length=100)
    current_price = models.DecimalField(
        max_digits=10, decimal_places=2, null=True)
    change = models.DecimalField(max_digits=10, decimal_places=2, null=True)
    change_percent = models.DecimalField(
        max_digits=10, decimal_places=2, null=True)  # in percentage
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [
            UniqueConstraint(
                fields=['user', 'ticker'],
                name='unique_user_ticker_case_insensitive',
                condition=models.Q(ticker__isnull=False),
                violation_error_message="Ticker must be unique for the user, ignoring case.",
            ),
        ]

    def __str__(self):
        return f"{self.user.username} - {self.ticker}"

    def save(self, *args, **kwargs):
        self.ticker = self.ticker.lower()  # 저장 전에 소문자로 변환
        super().save(*args, **kwargs)
