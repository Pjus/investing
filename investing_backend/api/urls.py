from django.urls import path
from .views import  NewsAPIView, StockDataAPIView, SP500APIView 


urlpatterns = [
    path('stock/<str:symbol>/', StockDataAPIView.as_view(), name='stock-data'),
    path('market/<str:index_name>/', SP500APIView.as_view(), name='market_index'),
    path('news/', NewsAPIView.as_view(), name='news'),
]
