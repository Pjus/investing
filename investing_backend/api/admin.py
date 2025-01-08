from django.contrib import admin
from .models import Stock


@admin.register(Stock)
class StockAdmin(admin.ModelAdmin):
    list_display = ('ticker', 'name', 'market_cap', 'price',
                    'change', 'revenue', 'last_updated')
    search_fields = ('ticker', 'name')
