from .utils import get_stock_data
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import viewsets
from .models import Watchlist
from .serializers import WatchlistSerializer, StockDetailSerializer
from rest_framework import status


class WatchlistViewSet(viewsets.ModelViewSet):
    queryset = Watchlist.objects.all()
    serializer_class = WatchlistSerializer


class StockDataAPIView(APIView):
    def get(self, request, symbol):
        # 프론트에서 전달된 period와 interval을 읽음 (기본값 설정)
        period = request.GET.get("period", "1y")      # 기본값: 1년
        interval = request.GET.get("interval", "1d")  # 기본값: 1일

        # yfinance에서 데이터 가져오기
        stock_data = get_stock_data(symbol, period=period, interval=interval)

        if stock_data['status'] == 'error':
            return Response(stock_data, status=status.HTTP_400_BAD_REQUEST)

        # Serializer를 통해 데이터 직렬화
        serializer = StockDetailSerializer(stock_data)
        return Response(serializer.data, status=status.HTTP_200_OK)
