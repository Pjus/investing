from django.urls import path
from .views import FavoriteListCreateView, FavoriteDeleteView

urlpatterns = [
    path('list/', FavoriteListCreateView.as_view(), name='favorite-list-create'),
    path('add/<int:id>/', FavoriteDeleteView.as_view(), name='favorite-delete'),
]