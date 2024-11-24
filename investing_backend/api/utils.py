import yfinance as yf


def get_stock_data(symbol, period="1d", interval="1m"):
    try:
        # 종목 데이터 다운로드
        stock = yf.Ticker(symbol)
        historical_data = stock.history(period=period, interval=interval)

        # DataFrame을 JSON으로 변환
        data = historical_data.reset_index()

        # datetime을 문자열로 변환 (날짜와 시간을 포함)
        if 'Datetime' in data.columns:
            data['Date'] = data['Datetime'].dt.strftime('%Y-%m-%d %H:%M:%S')
        else:
            data['Date'] = data['Date'].dt.strftime('%Y-%m-%d %H:%M:%S')

        # 필요 시 datetime에서 시간 정보 제거 (날짜만 표시)
        # data['Date'] = data['Datetime'].dt.date.astype(str)

        result = data.to_dict(orient="records")

        return {
            "status": "success",
            "symbol": symbol,
            "period": period,
            "interval": interval,
            "data": result
        }
    except Exception as e:
        return {"status": "error", "message": str(e)}
