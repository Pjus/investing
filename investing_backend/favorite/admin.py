from django.contrib import admin
from .models import Favorite
# Register your models here.
@admin.register(Favorite)
class FavoriteAdmin(admin.ModelAdmin):
    list_display = ('user', 'ticker', 'created_at')
    search_fields = ('user', 'ticker')
    list_filter = ('user', 'ticker')
    ordering = ('-created_at',)
    readonly_fields = ('created_at',)
