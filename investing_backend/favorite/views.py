from api.serializers import StockSerializer
from api.models import Stock
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .models import Favorite
from .serializers import FavoriteSerializer

from api.models import Stock


class FavoriteListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # 로그인한 사용자의 즐겨찾기 항목 가져오기
        favorites = Favorite.objects.filter(user=request.user)

        # 즐겨찾기 항목의 티커를 기반으로 주식 데이터를 가져오기
        stock_tickers = favorites.values_list('ticker', flat=True)
        stock_tickers = [ticker.upper() for ticker in stock_tickers]
        stocks = Stock.objects.filter(ticker__in=stock_tickers)
        stock_data = StockSerializer(stocks, many=True)

        return Response(stock_data.data, status=status.HTTP_200_OK)

    def post(self, request):

        # Pass the request object explicitly to the serializer's context
        ticker = request.data.get('ticker').lower()

        serializer = FavoriteSerializer(
            data=request.data, context={'request': request})

        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FavoriteDeleteView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, ticker):
        try:
            favorite = Favorite.objects.get(
                ticker=ticker.lower(), user=request.user)
            favorite.delete()
            return Response({"message": "Deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
        except Favorite.DoesNotExist:
            return Response({"error": "Favorite not found."}, status=status.HTTP_404_NOT_FOUND)


class StockListView(APIView):
    def get(self, request):
        stocks = Stock.objects.all()  # 전체 데이터 가져오기
        serializer = StockSerializer(stocks, many=True)
        return Response(serializer.data)


class StockSearchView(APIView):
    def get(self, request):
        query = request.query_params.get('query', '')
        if query:
            stocks = Stock.objects.filter(ticker=query.upper())  # 이름 검색
        else:
            stocks = Stock.objects.all()  # 전체 목록
        print(query)
        print(stocks)

        serializer = StockSerializer(stocks, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
