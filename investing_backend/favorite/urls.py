from django.urls import path
from .views import FavoriteListCreateView, FavoriteDeleteView, StockSearchView, StockListView

urlpatterns = [
    path('list/', FavoriteListCreateView.as_view(), name='favorite-list-create'),
    path('add/<str:ticker>/', FavoriteListCreateView.as_view(), name='favorite-add'),
    path('delete/<str:ticker>/', FavoriteDeleteView.as_view(),
         name='favorite-delete'),
    path('search/', StockSearchView.as_view(), name='stock-search'),
    path('stocks/', StockListView.as_view(), name='stock-list'),

]
