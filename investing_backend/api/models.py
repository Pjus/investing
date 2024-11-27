from django.contrib.auth.models import User
from django.db import models


class Watchlist(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    stock_symbol = models.CharField(max_length=10)  # 종목 코드
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.stock_symbol}"


class Stock(models.Model):
    ticker = models.CharField(max_length=10, unique=True)  # 주식 티커
    name = models.CharField(max_length=100)               # 회사 이름
    last_price = models.FloatField(blank=True)  # 마지막 가격 (옵션)
    net_change = models.FloatField(blank=True)  # 순 변동
    pct_change = models.FloatField(blank=True)  # 퍼센트 변동
    marketcap = models.IntegerField(blank=True)  # 시가총액
    country = models.CharField(max_length=50, null=True, blank=True)  # 국가
    ipo_year = models.IntegerField(blank=True)  # 등록년도
    volume = models.IntegerField(blank=True)  # 거래량
    sector = models.CharField(max_length=100, blank=True, null=True)  # 섹터
    industry = models.CharField(max_length=100, blank=True, null=True)  # 산업군

    def __str__(self):
        return f"{self.ticker} - {self.name}"
