import yfinance as yf
import requests
from django.conf import settings
from .models import Stock

def get_stock_data(symbol, period="1y", interval="1d"):
    try:
        # 종목 데이터 다운로드
        stock = yf.Ticker(symbol)
        infos = stock.info  # 종목 상세 정보
        historical_data = stock.history(period=period, interval=interval)

        # 선택된 키에 대한 필터링
        selected_keys = [
            # 회사 정보
            'longName', 'shortName', 'industry', 'sector',

            # 주식 가격 및 관련 데이터
            'currentPrice', 'previousClose', 'regularMarketOpen', 'regularMarketDayHigh',
            'regularMarketDayLow', 'fiftyTwoWeekHigh', 'fiftyTwoWeekLow', 'beta',
            'trailingPE', 'forwardPE', 'priceToBook',
            'targetHighPrice', 'targetLowPrice', 'targetMeanPrice', 'targetMedianPrice',

            # 재무 정보
            'marketCap', 'totalRevenue', 'revenuePerShare', 'ebitda', 'operatingCashflow',
            'freeCashflow', 'totalDebt', 'debtToEquity',
            'returnOnAssets', 'returnOnEquity', 'profitMargins',

            # 배당 정보
            'dividendRate', 'dividendYield', 'exDividendDate',
            'lastDividendValue', 'lastDividendDate',

            # 성장 및 분석
            'earningsGrowth', 'revenueGrowth', 'trailingEps', 'forwardEps', 'earningsQuarterlyGrowth',
            '52WeekChange',

            # 기타
            'financialCurrency'
        ]

        # 필요한 키만 필터링
        stock_details = {key: infos.get(key, None) for key in selected_keys}

        # DataFrame을 JSON으로 변환
        historical_data = historical_data.reset_index()

        # datetime을 문자열로 변환
        if 'Datetime' in historical_data.columns:
            historical_data['Date'] = historical_data['Datetime'].dt.strftime(
                '%Y-%m-%d')
        else:
            historical_data['Date'] = historical_data['Date'].dt.strftime(
                '%Y-%m-%d')

        # 데이터 변환
        result = historical_data.to_dict(orient="records")

        return {
            "status": "success",
            "symbol": symbol,
            "period": period,
            "interval": interval,
            "data": result,  # 과거 주가 데이터
            **stock_details,  # 선택된 키의 종목 상세 정보
        }
    except Exception as e:
        return {"status": "error", "message": str(e)}





def fetch_stocks_data():
    page_num = 0
    header = {
        'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'
    }
    try:
        while page_num < 4:
            page_num += 1
            url = f"https://api.stockanalysis.com/api/screener/s/f?m=marketCap&s=desc&c=no,s,n,marketCap,price,change,revenue&cn=1000&f=exchange-is-NASDAQ&p={page_num}&i=stocks"
            response = requests.get(url, timeout=10, headers=header)  # 10초 제한
            response.raise_for_status()
            data = response.json()  # JSON 데이터 파싱
            return data.get('data', [])  # 'data' 키에 주식 정보가 저장됨
    except requests.RequestException as e:
        print(f"Error fetching stock data: {e}")
        return []


def save_stocks_to_db():
    stocks_data = fetch_stocks_data()

    if not stocks_data:
        print("No data fetched from the API.")
        return

    for stock in stocks_data:
        try:
            # 데이터 매핑
            symbol = stock.get('s')
            name = stock.get('n')
            market_cap = stock.get('marketCap')
            price = stock.get('price')
            change = stock.get('change')
            revenue = stock.get('revenue')

            # 데이터 저장 또는 업데이트
            Stock.objects.update_or_create(
                symbol=symbol,
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
