from django.urls import path
from .views import NewsAPIView, StockDataAPIView, SP500APIView, FetchStocksAPIView


urlpatterns = [
    path('stock/<str:symbol>/', StockDataAPIView.as_view(), name='stock-data'),
    path('market/<str:index_name>/', SP500APIView.as_view(), name='market_index'),
    path('news/', NewsAPIView.as_view(), name='news'),
    path('fetch-stocks/', FetchStocksAPIView.as_view(), name='fetch-stocks'),
]
