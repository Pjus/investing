from .utils import get_stock_data
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import viewsets
from .models import Watchlist
from .serializers import WatchlistSerializer


class WatchlistViewSet(viewsets.ModelViewSet):
    queryset = Watchlist.objects.all()
    serializer_class = WatchlistSerializer


class StockDataAPIView(APIView):
    def get(self, request, symbol):
        # 프론트에서 전달된 period와 interval을 읽음 (기본값 설정)
        period = request.GET.get("period", "1d")      # 기본값: 1일
        interval = request.GET.get("interval", "1m")  # 기본값: 1분
        data = get_stock_data(symbol, period, interval)
        return Response(data)
