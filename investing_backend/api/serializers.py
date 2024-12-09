from .models import Portfolio, Watchlist, Favorite
from rest_framework import serializers


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
    data = StockHistoricalDataSerializer(many=True)  # 과거 주가 데이터

    # 회사 정보
    longName = serializers.CharField(required=False, allow_null=True)
    shortName = serializers.CharField(required=False, allow_null=True)
    industry = serializers.CharField(required=False, allow_null=True)
    sector = serializers.CharField(required=False, allow_null=True)

    # 주식 가격 및 관련 데이터
    currentPrice = serializers.FloatField(required=False, allow_null=True)
    previousClose = serializers.FloatField(required=False, allow_null=True)
    regularMarketOpen = serializers.FloatField(required=False, allow_null=True)
    regularMarketDayHigh = serializers.FloatField(
        required=False, allow_null=True)
    regularMarketDayLow = serializers.FloatField(
        required=False, allow_null=True)
    fiftyTwoWeekHigh = serializers.FloatField(required=False, allow_null=True)
    fiftyTwoWeekLow = serializers.FloatField(required=False, allow_null=True)
    beta = serializers.FloatField(required=False, allow_null=True)
    trailingPE = serializers.FloatField(required=False, allow_null=True)
    forwardPE = serializers.FloatField(required=False, allow_null=True)
    priceToBook = serializers.FloatField(required=False, allow_null=True)
    targetHighPrice = serializers.FloatField(required=False, allow_null=True)
    targetLowPrice = serializers.FloatField(required=False, allow_null=True)
    targetMeanPrice = serializers.FloatField(required=False, allow_null=True)
    targetMedianPrice = serializers.FloatField(required=False, allow_null=True)

    # 재무 정보
    marketCap = serializers.CharField(required=False, allow_null=True)
    totalRevenue = serializers.CharField(required=False, allow_null=True)
    revenuePerShare = serializers.FloatField(required=False, allow_null=True)
    ebitda = serializers.FloatField(required=False, allow_null=True)
    operatingCashflow = serializers.FloatField(required=False, allow_null=True)
    freeCashflow = serializers.FloatField(required=False, allow_null=True)
    totalDebt = serializers.FloatField(required=False, allow_null=True)
    debtToEquity = serializers.FloatField(required=False, allow_null=True)
    returnOnAssets = serializers.FloatField(required=False, allow_null=True)
    returnOnEquity = serializers.FloatField(required=False, allow_null=True)
    profitMargins = serializers.FloatField(required=False, allow_null=True)

    # 배당 정보
    dividendRate = serializers.FloatField(required=False, allow_null=True)
    dividendYield = serializers.FloatField(required=False, allow_null=True)
    exDividendDate = serializers.CharField(required=False, allow_null=True)
    lastDividendValue = serializers.FloatField(required=False, allow_null=True)
    lastDividendDate = serializers.CharField(required=False, allow_null=True)

    # 성장 및 분석
    earningsGrowth = serializers.FloatField(required=False, allow_null=True)
    revenueGrowth = serializers.FloatField(required=False, allow_null=True)
    trailingEps = serializers.FloatField(required=False, allow_null=True)
    forwardEps = serializers.FloatField(required=False, allow_null=True)
    earningsQuarterlyGrowth = serializers.FloatField(
        required=False, allow_null=True)
    fiftyTwoWeekChange = serializers.FloatField(required=False, allow_null=True)

    # 기타
    financialCurrency = serializers.CharField(required=False, allow_null=True)


class FavoriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Favorite
        fields = ['id', 'ticker', 'name', 'created_at']

    def validate(self, data):
        user = self.context['request'].user
        if Favorite.objects.filter(user=user, ticker=data['ticker']).exists():
            raise serializers.ValidationError(
                {"ticker": "This stock is already in your favorites."})
        return data


class PortfolioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Portfolio
        fields = ['id', 'ticker', 'shares']
