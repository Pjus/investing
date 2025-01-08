import yfinance as yf
import requests
from datetime import datetime, timezone
from .models import Stock


def convert_unix_to_date(data, keys):
    for key in keys:
        if key in data and data[key] is not None:
            try:
                data[key] = datetime.fromtimestamp(
                    int(data[key]), tz=timezone.utc).strftime('%Y-%m-%d')
            except ValueError:
                pass  # 유효하지 않은 값 처리
    return data


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
        # 변환 대상 키
        date_keys = ["exDividendDate", "lastDividendDate"]
        stock_details = convert_unix_to_date(stock_details, date_keys)
        return_values = {
            "status": "success",
            "symbol": symbol,
            "period": period,
            "interval": interval,
            "data": result,  # 과거 주가 데이터
            # 명시적으로 추가
            "fiftyTwoWeekChange": stock_details.get("52WeekChange"),
            **{k: v for k, v in stock_details.items() if k != "52WeekChange"},  # 나머지 데이터
        }
        return return_values

    except Exception as e:
        return {"status": "error", "message": str(e)}


def fetch_stocks_data():
    page_num = 0
    header = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'
    }
    try:
        while page_num < 4:
            page_num += 1
            url = f"https://api.stockanalysis.com/api/screener/s/f?m=marketCap&s=desc&c=no,s,n,marketCap,price,change,revenue&cn=1000&f=exchange-is-NASDAQ&p={page_num}&i=stocks"
            response = requests.get(url, timeout=5, headers=header)  # 10초 제한
            response.raise_for_status()
            data = response.json()  # JSON 데이터 파싱
            for stock in data['data']['data']:
                print(stock['s'])
                try:
                    changePercent = (stock['change'] / stock['price']) * 100
                    Stock.objects.update_or_create(
                        ticker=stock['s'],
                        defaults={
                            'name': stock['n'],
                            'market_cap': stock['marketCap'],
                            'price': stock['price'],
                            'change': stock['change'],
                            'change_percent': changePercent,
                            'revenue': stock['revenue']
                        }
                    )
                except Exception as e:
                    print(f"Error saving stock data: {e}")
    except requests.RequestException as e:
        print(f"Error fetching stock data: {e}")
        return []
