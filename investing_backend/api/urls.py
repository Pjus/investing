from django.urls import path
from rest_framework.routers import DefaultRouter
from .views import WatchlistViewSet, NewsAPIView, StockDataAPIView, SP500APIView, PortfolioListView, PortfolioDetailView, FavoriteAPIView

router = DefaultRouter()
router.register(r'watchlist', WatchlistViewSet, basename='watchlist')

urlpatterns = router.urls

urlpatterns += [
    path('stock/<str:symbol>/', StockDataAPIView.as_view(), name='stock-data'),
    path('market/<str:index_name>/', SP500APIView.as_view(), name='market_index'),
    path('news/', NewsAPIView.as_view(), name='news'),
    path('favorites/', FavoriteAPIView.as_view(), name='favorites'),
    path('portfolio/', PortfolioListView.as_view(), name='portfolio_list'),
    path('portfolio/<str:ticker>/',
         PortfolioDetailView.as_view(), name='portfolio_detail'),
    
]
