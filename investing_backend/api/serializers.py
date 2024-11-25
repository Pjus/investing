from rest_framework import serializers
from .models import Watchlist


class WatchlistSerializer(serializers.ModelSerializer):
    class Meta:
        model = Watchlist
        fields = '__all__'


class StockHistoricalDataSerializer(serializers.Serializer):
    Date = serializers.CharField()
    Open = serializers.FloatField()
    High = serializers.FloatField()
    Low = serializers.FloatField()
    Close = serializers.FloatField()
    Volume = serializers.FloatField()


class StockDetailSerializer(serializers.Serializer):
    status = serializers.CharField()
    symbol = serializers.CharField()
    period = serializers.CharField()
    interval = serializers.CharField()
    data = StockHistoricalDataSerializer(many=True)  # 다중 레코드 처리
    longName = serializers.CharField(required=False, allow_null=True)
    industry = serializers.CharField(required=False, allow_null=True)
    sector = serializers.CharField(required=False, allow_null=True)
    currentPrice = serializers.FloatField(required=False, allow_null=True)
    marketCap = serializers.CharField(required=False, allow_null=True)
