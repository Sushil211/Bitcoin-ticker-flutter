import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

const apiKey = 'f9a308f4ded842a0f28703985ccdf41f';
const currenciesTickerURL = 'https://api.nomics.com/v1/currencies/ticker';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String convertedValueFromBTC = '?';
  String convertedValueFromETH = '?';
  String convertedValueFromLTC = '?';

  DropdownButton<String> androidDropDown() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currenciesList.map<DropdownMenuItem<String>>((currency) {
        return DropdownMenuItem<String>(
          child: Text(currency),
          value: currency,
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getCoinData();
        });
      },
    );
  }

  Widget iOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 30.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getCoinData();
        });
      },
      children: currenciesList.map<Text>((currency) {
        return Text(currency);
      }).toList(),
    );
  }

  void getCoinData() async {
    try {
      String url =
          '$currenciesTickerURL?key=$apiKey&ids=BTC,ETH,LTC&interval=1d,30d&convert=$selectedCurrency&per-page=100&page=1';
      CoinData coinData = CoinData(url);
      var data = await coinData.getData();

      setState(() {
        convertedValueFromBTC = num.parse(data[0]['price']).round().toString();
        convertedValueFromETH = num.parse(data[1]['price']).round().toString();
        convertedValueFromLTC = num.parse(data[2]['price']).round().toString();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoinData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            color: Colors.lightBlueAccent,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 28.0),
                              child: Text(
                                '1 BTC = $convertedValueFromBTC $selectedCurrency',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.lightBlueAccent,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 28.0),
                              child: Text(
                                '1 ETH = $convertedValueFromETH $selectedCurrency',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.lightBlueAccent,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 28.0),
                              child: Text(
                                '1 LTC = $convertedValueFromLTC $selectedCurrency',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 150.0,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: 30.0),
                      color: Colors.lightBlue,
                      child: Platform.isIOS ? iOSPicker() : androidDropDown(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
