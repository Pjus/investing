from .utils import fetch_stocks_data
from .models import Stock


def save_stocks_to_db():
    stocks_data = fetch_stocks_data()

    if not stocks_data:
        print("No data fetched from the API.")
        return

    for stock in stocks_data:
        try:
            # 데이터 매핑
            ticker = stock.get('s')
            name = stock.get('n')
            market_cap = stock.get('marketCap')
            price = stock.get('price')
            change = stock.get('change')
            revenue = stock.get('revenue')

            # 데이터 저장 또는 업데이트
            Stock.objects.update_or_create(
                ticker=ticker,
                defaults={
                    'name': name,
                    'market_cap': market_cap,
                    'price': price,
                    'change': change,
                    'revenue': revenue,
                },
            )
        except Exception as e:
            print(f"Error saving stock {stock.get('s')}: {e}")
