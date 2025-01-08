from rest_framework import serializers
from .models import Favorite


class FavoriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Favorite
        fields = ['id', 'user', 'ticker', 'name', 'current_price',
                  'change', 'change_percent', 'created_at']
        read_only_fields = ['user', 'created_at']

    def validate(self, data):
        user = self.context['request'].user
        ticker = data.get('ticker').lower()  # 대소문자 변환

        if Favorite.objects.filter(user=user, ticker=ticker).exists():
            raise serializers.ValidationError(
                "This stock is already in your favorites.")
        return data
