/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

/**
 *
 * @author Trade
 */
public class Instrument {
    String insToken, exchangeToken, tradSym, name, lastPrice, expiry, strike, tickSize, lotSize,
            instrument, segment, exchange;

    public Instrument(String str) {
        String[] tok = str.split(",");
        insToken = tok[0];
        exchangeToken = tok[1];
        tradSym = tok[2];
        name = tok[3];
        lastPrice = tok[4];
        expiry = tok[5];
        strike = tok[6];
        tickSize = tok[7];
        lotSize = tok[8];
        instrument = tok[9];
        segment = tok[10];
        exchange = tok[11];
    }

    public String getInsToken() {
        return insToken;
    }

    public void setInsToken(String insToken) {
        this.insToken = insToken;
    }

    public String getExchangeToken() {
        return exchangeToken;
    }

    public void setExchangeToken(String exchangeToken) {
        this.exchangeToken = exchangeToken;
    }

    public String getTradSym() {
        return tradSym;
    }

    public void setTradSym(String tradSym) {
        this.tradSym = tradSym;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLastPrice() {
        return lastPrice;
    }

    public void setLastPrice(String lastPrice) {
        this.lastPrice = lastPrice;
    }

    public String getExpiry() {
        return expiry;
    }

    public void setExpiry(String expiry) {
        this.expiry = expiry;
    }

    public String getStrike() {
        return strike;
    }

    public void setStrike(String strike) {
        this.strike = strike;
    }

    public String getTickSize() {
        return tickSize;
    }

    public void setTickSize(String tickSize) {
        this.tickSize = tickSize;
    }

    public String getLotSize() {
        return lotSize;
    }

    public void setLotSize(String lotSize) {
        this.lotSize = lotSize;
    }

    public String getInstrument() {
        return instrument;
    }

    public void setInstrument(String instrument) {
        this.instrument = instrument;
    }

    public String getSegment() {
        return segment;
    }

    public void setSegment(String segment) {
        this.segment = segment;
    }

    public String getExchange() {
        return exchange;
    }

    public void setExchange(String exchange) {
        this.exchange = exchange;
    }
}
