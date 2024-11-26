from .views import SP500APIView
from .views import StockDataAPIView
from django.urls import path
from rest_framework.routers import DefaultRouter
from .views import WatchlistViewSet

router = DefaultRouter()
router.register(r'watchlist', WatchlistViewSet, basename='watchlist')

urlpatterns = router.urls

urlpatterns += [
    path('stock/<str:symbol>/', StockDataAPIView.as_view(), name='stock-data'),
    path('snp500/', SP500APIView.as_view(), name='snp500'),

]
