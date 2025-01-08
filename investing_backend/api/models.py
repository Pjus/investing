from django.db import models


class Stock(models.Model):
    ticker = models.CharField(max_length=10, unique=True)  # 종목 코드
    name = models.CharField(max_length=255)  # 회사 이름
    market_cap = models.BigIntegerField(null=True, blank=True)  # 시가 총액
    price = models.DecimalField(
        max_digits=10, decimal_places=2, null=True, blank=True)  # 현재 가격
    change = models.DecimalField(
        max_digits=6, decimal_places=2, null=True, blank=True, help_text="Price change (current - previous)"
    )  # 가격 변동
    change_percent = models.DecimalField(
        max_digits=6, decimal_places=2, null=True, blank=True, help_text="Price change in percentage"
    )  # 가격 변동 (퍼센트)
    revenue = models.BigIntegerField(null=True, blank=True)  # 매출
    last_updated = models.DateTimeField(auto_now=True)  # 마지막 업데이트 시간

    def __str__(self):
        return f"{self.ticker} - {self.name}"
