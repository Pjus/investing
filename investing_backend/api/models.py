from django.contrib.auth.models import User
from django.db import models


class Stock(models.Model):
    symbol = models.CharField(max_length=10, unique=True)  # 종목 코드
    name = models.CharField(max_length=255)  # 회사 이름
    market_cap = models.BigIntegerField(null=True, blank=True)  # 시가 총액
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)  # 현재 가격
    change = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)  # 가격 변동
    revenue = models.BigIntegerField(null=True, blank=True)  # 매출
    last_updated = models.DateTimeField(auto_now=True)  # 마지막 업데이트 시간

    def __str__(self):
        return f"{self.symbol} - {self.name}"

class Watchlist(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    stock_symbol = models.CharField(max_length=10)  # 종목 코드
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.stock_symbol}"


class Favorite(models.Model):
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="favorites")
    ticker = models.CharField(max_length=10)  # 주식 티커
    name = models.CharField(max_length=100)  # 주식 이름
    created_at = models.DateTimeField(auto_now_add=True)  # 즐겨찾기 추가 시간

    class Meta:
        unique_together = ('user', 'ticker')  # 동일 사용자와 티커 조합 중복 방지

    def __str__(self):
        return f"{self.user.username} - {self.ticker}"


class Portfolio(models.Model):
    user = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='portfolio')
    ticker = models.CharField(max_length=10)
    shares = models.FloatField()

    def __str__(self):
        return f"{self.ticker} - {self.shares} shares"
