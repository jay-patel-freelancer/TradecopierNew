/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tradecopier.providers;

import java.io.UnsupportedEncodingException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.net.ssl.SSLContext;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.CookieSpecs;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.conn.socket.ConnectionSocketFactory;
import org.apache.http.conn.socket.PlainConnectionSocketFactory;
import org.apache.http.conn.ssl.NoopHostnameVerifier;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.TrustStrategy;
import org.apache.http.cookie.Cookie;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.ssl.SSLContextBuilder;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;
import to.ChildAccount;
import to.MasterAccount;
import util.Constants;
import util.Instrument;
import java.util.logging.Level;

/**
 *
 * @author umair
 */
public class KiteSendKeys implements Runnable {

    ChildAccount cAccount = null;
    MasterAccount account = null;
    ArrayList<JSONObject> obj = null;
    String from = "";

    CookieStore cookies;
    HttpClient client;

    public KiteSendKeys(ChildAccount cAccount, ArrayList<JSONObject> obj, String from, MasterAccount account) {
        this.cAccount = cAccount;
        this.obj = obj;
        this.from = from;
        this.account = account;
    }

    @Override
    public void run() {
        try {
            BasicCredentialsProvider proxyCredentials = null;
            cookies = new BasicCookieStore();
            final int timeout = 15000;
            SSLContext sslContext = new SSLContextBuilder().loadTrustMaterial(null, new TrustStrategy() {
                public boolean isTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {
                    return true;
                }
            }).build();
            client = HttpClientBuilder.create()
                    .setDefaultCookieStore(cookies)
                    .setSSLContext(sslContext)
                    .setConnectionManager(
                            new PoolingHttpClientConnectionManager(
                                    RegistryBuilder.<ConnectionSocketFactory>create()
                                            .register("http", PlainConnectionSocketFactory.INSTANCE)
                                            .register("https", new SSLConnectionSocketFactory(sslContext,
                                                    NoopHostnameVerifier.INSTANCE))
                                            .build()
                            ))
                    .setRoutePlanner(null)
                    .setDefaultCredentialsProvider(proxyCredentials)
                    .setDefaultRequestConfig(RequestConfig.custom()
                            .setCookieSpec(CookieSpecs.STANDARD)
                            .setProxy(null)
                            .setConnectTimeout(timeout)
                            .setConnectionRequestTimeout(timeout)
                            .setSocketTimeout(timeout)
                            .build())
                    .build();
            getRequest();

            JSONObject loginObject = null;
            JSONObject answerObject = null;

            java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");

            for (int i = 0; i < 2; i++) {

                loginObject = login(cAccount.getLoginId().trim(), cAccount.getPassword().trim());

                log.log(Level.INFO, "kite place login " + loginObject);

                if (loginObject != null && !loginObject.get("status").equals("success")) {
                    break;
                }
            }

            if (loginObject == null || !loginObject.get("status").equals("success")) {
                return;
            }

            for (int i = 0; i < 2; i++) {
                String requestId = loginObject.getJSONObject("data").getString("request_id");;
                answerObject = answer(cAccount.getLoginId(), requestId, cAccount.getPin());

                log.log(Level.INFO, "kite place answer " + answerObject);

                if (answerObject != null && answerObject.get("status").equals("success")) {
                    break;
                }
            }

            if (answerObject == null || !answerObject.get("status").equals("success")) {
                return;
            }

            String token = "";
            List<Cookie> cookieList = cookies.getCookies();

            for (Cookie c : cookieList) {
                if (c.getName().equals("enctoken")) {
                    token = c.getValue();
                    break;
                }
            }

            dashboard();
            for (JSONObject objj : obj) {
                for (int i = 0; i < 3; i++) {
                    JSONObject orderObject = placeOrder(token, objj);
                    log.log(Level.INFO, "ant place orderObject2 " + orderObject);
                    if (orderObject != null && orderObject.get("status").equals("success")) {
                        break;
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void getRequest() {
        HttpGet request = new HttpGet("https://kite.zerodha.com/");
        List<NameValuePair> data = new ArrayList<NameValuePair>();
        HttpResponse response = null;
        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        while (response == null) {
            try {
                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
                if (response.getStatusLine().getStatusCode() == 200) {
                    break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (request != null) {
                    request.releaseConnection();
                }
                try {
                    if (response != null && response.getEntity() != null) {
                        EntityUtils.consume(response.getEntity());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private JSONObject login(String loginId, String pass) {
        HttpPost request = new HttpPost("https://kite.zerodha.com/api/login");
        List<NameValuePair> data = new ArrayList<NameValuePair>();
        HttpResponse response = null;
        JSONObject retJson = null;

        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        request.setHeader("Referer", "https://kite.zerodha.com/");
        data.add(new BasicNameValuePair("captcha", ""));
        data.add(new BasicNameValuePair("user_id", loginId));
        data.add(new BasicNameValuePair("password", pass));
        while (response == null) {
            try {

                request.setEntity(new UrlEncodedFormEntity(data));
                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
                java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
                log.log(Level.INFO, "kite place loginresult " + cAccount.getLoginId() + "****" + result);
                if (response.getStatusLine().getStatusCode() == 200) {
                    try {
                        retJson = new JSONObject(result.toString());
                        break;
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (request != null) {
                    request.releaseConnection();
                }
                try {
                    if (response != null && response.getEntity() != null) {
                        EntityUtils.consume(response.getEntity());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return retJson;
    }

    private JSONObject answer(String userId, String requestId, String pin) throws UnsupportedEncodingException {
        HttpPost request = new HttpPost("https://kite.zerodha.com/api/twofa");
        List<NameValuePair> data = new ArrayList<NameValuePair>();
        HttpResponse response = null;
        JSONObject retJson = null;

        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        request.setHeader("Referer", "https://kite.zerodha.com/");
        request.setHeader("X-Device-Type", "web");
        data.add(new BasicNameValuePair("x-kite-userid", userId));
        data.add(new BasicNameValuePair("x-kite-version", "2.0.4"));
        data.add(new BasicNameValuePair("user_id", userId));
        data.add(new BasicNameValuePair("request_id", requestId));
        data.add(new BasicNameValuePair("twofa_value", pin));
        while (response == null) {
            try {

                request.setEntity(new UrlEncodedFormEntity(data));
                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
                java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
                log.log(Level.INFO, "kite place answerresult " + cAccount.getLoginId() + "****" + result);
                if (response.getStatusLine().getStatusCode() == 200) {
                    try {
                        retJson = new JSONObject(result.toString());
                        break;
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (request != null) {
                    request.releaseConnection();
                }
                try {
                    if (response != null && response.getEntity() != null) {
                        EntityUtils.consume(response.getEntity());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return retJson;
    }

    private void dashboard() {
        HttpGet request = new HttpGet("https://kite.zerodha.com/dashboard");
        List<NameValuePair> data = new ArrayList<NameValuePair>();
        HttpResponse response = null;

        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        while (response == null) {
            try {
                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
                if (response.getStatusLine().getStatusCode() == 200) {
                    try {
                        break;
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (request != null) {
                    request.releaseConnection();
                }
                try {
                    if (response != null && response.getEntity() != null) {
                        EntityUtils.consume(response.getEntity());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private JSONObject placeOrder(String token, JSONObject objj) {
        java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
        HttpPost request = new HttpPost("https://kite.zerodha.com/oms/orders/regular");
        List<NameValuePair> data = new ArrayList<NameValuePair>();
        HttpResponse response = null;
        JSONObject retJson = null;

        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        request.setHeader("Referer", "https://kite.zerodha.com/dashboard");
        request.setHeader("Accept", "application/json, text/plain, */*");
        request.setHeader("Content-Type", "application/x-www-form-urlencoded");
        request.setHeader("Origin", "https://kite.zerodha.com");
        request.setHeader("authorization", "enctoken " + token);
        request.setHeader("x-kite-userid", cAccount.getLoginId());
        request.setHeader("x-kite-version", "2.0.4");
        data.add(new BasicNameValuePair("exchange", objj.getString("exchange").toUpperCase().split("_")[0]));
        if (from.equalsIgnoreCase("Ant")) {
            data.add(new BasicNameValuePair("tradingsymbol", objj.getString("trading_symbol").split("-")[0].toUpperCase()));
        } else if (from.equalsIgnoreCase("Kite")) {
            data.add(new BasicNameValuePair("tradingsymbol", objj.getString("tradingsymbol").toUpperCase()));
        } else if (from.equalsIgnoreCase("Upstox")) {
            for (Map.Entry<String, Instrument> entry : Constants.insMap.entrySet()) {
                Instrument ins = entry.getValue();
                if (ins.getExchangeToken().equals(objj.getString("token"))) {
                    data.add(new BasicNameValuePair("tradingsymbol", ins.getTradSym()));
                    break;
                }
            }
        }
        if (from.equalsIgnoreCase("Upstox")) {
            data.add(new BasicNameValuePair("transaction_type", objj.getString("side").equals("B") ? "BUY" : "SELL"));
            data.add(new BasicNameValuePair("order_type", "MARKET"));
            data.add(new BasicNameValuePair("price", objj.getString("price")));
            data.add(new BasicNameValuePair("product", objj.getString("product").equals("I") ? "MIS" : "NRML"));
            data.add(new BasicNameValuePair("validity", objj.getString("duration")));
            data.add(new BasicNameValuePair("trigger_price", objj.getString("trigger_price")));
        } else {
            data.add(new BasicNameValuePair("transaction_type", objj.getString("transaction_type")));
            data.add(new BasicNameValuePair("order_type", "MARKET"));
            data.add(new BasicNameValuePair("price", "" + objj.getInt("price")));
            data.add(new BasicNameValuePair("product", objj.getString("product")));
            data.add(new BasicNameValuePair("validity", objj.getString("validity")));
            data.add(new BasicNameValuePair("trigger_price", "" + objj.getInt("trigger_price")));
        }
        int qty = (int) (Double.parseDouble(cAccount.getQtyMultiply().trim())* objj.getInt("quantity"));
        log.log(Level.INFO, "kite place order qty " + cAccount.getLoginId() + "****" + qty);
        data.add(new BasicNameValuePair("quantity", "" + qty));
        data.add(new BasicNameValuePair("disclosed_quantity", "" + objj.getInt("disclosed_quantity")));
        data.add(new BasicNameValuePair("squareoff", "0"));
        data.add(new BasicNameValuePair("stoploss", "0"));
        data.add(new BasicNameValuePair("trailing_stoploss", "0"));
        data.add(new BasicNameValuePair("variety", "regular"));
        data.add(new BasicNameValuePair("user_id", cAccount.getLoginId()));
        while (response == null) {
            try {

                request.setEntity(new UrlEncodedFormEntity(data));
                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
                log.log(Level.INFO, "kite place orderresult " + cAccount.getLoginId() + "****" + result);
                if (response.getStatusLine().getStatusCode() == 200) {
                    try {
                        retJson = new JSONObject(result.toString());
                        break;
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (request != null) {
                    request.releaseConnection();
                }
                try {
                    if (response != null && response.getEntity() != null) {
                        EntityUtils.consume(response.getEntity());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return retJson;
    }
}
