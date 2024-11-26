import yfinance as yf


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
                '%Y-%m-%d %H:%M:%S')
        else:
            historical_data['Date'] = historical_data['Date'].dt.strftime(
                '%Y-%m-%d %H:%M:%S')

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
