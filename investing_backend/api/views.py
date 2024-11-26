import yfinance as yf
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


class SP500APIView(APIView):
    def get(self, request):
        try:
            # S&P 500 데이터 가져오기
            ticker = '^GSPC'
            stock = yf.Ticker(ticker)
            info = stock.history(period='1d')  # 1일 간의 데이터
            # 필요한 정보 추출
            last_close = info['Close'].iloc[-1]
            open_price = info['Open'].iloc[-1]
            change = (last_close - open_price) / open_price * 100
            day_range = f"{stock.info['dayLow']} - {stock.info['dayHigh']}"

            result = {
                "symbol": ticker,
                "last_close": round(last_close, 2),
                "change_percent": round(change, 2),
                "day_range": day_range,
            }

            print(result)

            return Response(result, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
