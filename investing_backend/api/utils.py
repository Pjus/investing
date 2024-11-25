import yfinance as yf


def get_stock_data(symbol, period="1y", interval="1d"):
    try:
        # 종목 데이터 다운로드
        stock = yf.Ticker(symbol)
        infos = stock.info  # 종목 상세 정보
        historical_data = stock.history(period=period, interval=interval)

        # DataFrame을 JSON으로 변환
        data = historical_data.reset_index()

        # datetime을 문자열로 변환 (날짜와 시간을 포함)
        if 'Datetime' in data.columns:
            data['Date'] = data['Datetime'].dt.strftime('%Y-%m-%d %H:%M:%S')
        else:
            data['Date'] = data['Date'].dt.strftime('%Y-%m-%d %H:%M:%S')

        result = data.to_dict(orient="records")

        # 필요한 종목 정보
        stock_details = {
            "longName": infos.get("longName", None),
            "industry": infos.get("industry", None),
            "sector": infos.get("sector", None),
            "currentPrice": infos.get("currentPrice", None),
            "marketCap": infos.get("marketCap", None),
        }

        return {
            "status": "success",
            "symbol": symbol,
            "period": period,
            "interval": interval,
            "data": result,
            **stock_details,  # 추가 정보 병합
        }
    except Exception as e:
        return {"status": "error", "message": str(e)}
