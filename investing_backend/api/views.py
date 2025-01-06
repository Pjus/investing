from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import pandas as pd
import yfinance as yf
from finvizfinance.news import News
from .utils import get_stock_data
from .models import Stock
from .serializers import StockDetailSerializer


class StockDataAPIView(APIView):
    def get(self, request, symbol):
        period = request.GET.get("period", "1y")      # 기본값: 1년
        interval = request.GET.get("interval", "1d")  # 기본값: 1일

        stock_data = get_stock_data(symbol, period=period, interval=interval)

        if stock_data['status'] == 'error':
            return Response(stock_data, status=status.HTTP_400_BAD_REQUEST)

        serializer = StockDetailSerializer(stock_data)
        return Response(serializer.data, status=status.HTTP_200_OK)


class SP500APIView(APIView):
    def get(self, request, index_name):
        try:
            index_tickers = {
                "snp500": "^GSPC",
                "dowjones": "^DJI",
                "nasdaq": "^IXIC"
            }
            ticker = index_tickers.get(index_name.lower())
            if not ticker:
                return Response(
                    {"error": f"Invalid index name: {index_name}"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            stock = yf.Ticker(ticker)
            info = stock.history(period='1d')

            if info.empty:
                return Response(
                    {"error": "No data available for the index."},
                    status=status.HTTP_204_NO_CONTENT,
                )

            last_close = info['Close'].iloc[-1]
            open_price = info['Open'].iloc[-1]
            change = last_close - open_price
            pct_change = (last_close - open_price) / open_price * 100

            result = {
                "symbol": ticker,
                "last_close": round(last_close, 2),
                "change_net": round(change, 2),
                "change_percent": round(pct_change, 2),
                "day_range": (round(info['Low'].iloc[-1], 2), round(info['High'].iloc[-1], 2)),
            }

            return Response(result, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class NewsAPIView(APIView):
    def get(self, request):
        try:
            # 뉴스 데이터 가져오기
            fnews = News()
            all_news = fnews.get_news()
            news_data = all_news['news']  # 뉴스 리스트

            # Pandas DataFrame으로 변환
            df = pd.DataFrame(news_data, columns=["Date", "Title", "Source", "Link"])

            # 명시적으로 비어 있는지 확인
            if df.empty:
                return Response(
                    {"status": "error", "message": "No news data to return"},
                    status=status.HTTP_204_NO_CONTENT,
                )

            # DataFrame을 JSON으로 변환
            news_json = df.to_dict(orient="records")
            return Response({"status": "success", "data": news_json}, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"status": "error", "message": str(e)}, status=status.HTTP_400_BAD_REQUEST)
