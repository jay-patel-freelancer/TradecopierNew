/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tradecopier.services;

import java.io.UnsupportedEncodingException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import javax.net.ssl.SSLContext;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.CookieSpecs;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.conn.socket.ConnectionSocketFactory;
import org.apache.http.conn.socket.PlainConnectionSocketFactory;
import org.apache.http.conn.ssl.NoopHostnameVerifier;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.TrustStrategy;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.ssl.SSLContextBuilder;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import to.ChildAccount;
import to.MasterAccount;
import util.Constants;
import util.Instrument;

/**
 *
 * @author umairullah
 */
public class AntSendKeys implements Runnable {

    CookieStore cookies;
    HttpClient client;

    ChildAccount cAccount = null;
    MasterAccount account = null;
    ArrayList<JSONObject> obj = null;
    String from = "";

    public AntSendKeys(ChildAccount cAccount, ArrayList<JSONObject> obj, String from, MasterAccount account) {
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
            JSONObject answerObject = null;
            JSONObject loginObject = null;
            java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
            for (int i = 0; i < 2; i++) {

                loginObject = login();

                log.log(Level.INFO, "ant place loginObject " + loginObject);

                if (loginObject != null && loginObject.get("status").equals("success")) {
                    break;
                }
            }

            if (loginObject == null || !loginObject.get("status").equals("success")) {
                return;
            }
            for (int i = 0; i < 2; i++) {
                JSONArray array = loginObject.getJSONObject("data").getJSONArray("question_ids");
                String payloadData = "{\"answers\":[\"" + cAccount.getQ1() + "\",\"" + cAccount.getQ2() + "\"],\"login_id\":\"" + cAccount.getLoginId() + "\",\"question_ids\":" + array.toString() + ",\"device\":\"web\",\"count\":2}";
                answerObject = answer(payloadData);

                log.log(Level.INFO, "ant place answerObject " + answerObject);

                if (answerObject != null && answerObject.get("status").equals("success")) {
                    break;
                }
            }

            if (answerObject == null || !answerObject.get("status").equals("success")) {
                return;
            }

            String token = answerObject.getJSONObject("data").getString("auth_token");
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

    private JSONObject login() {
        HttpPost request = new HttpPost("https://ant.aliceblueonline.com/api/v2/login");
        List<NameValuePair> data = new ArrayList<NameValuePair>();
        HttpResponse response = null;
        JSONObject retJson = null;

        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        request.setHeader("Referer", "https://ant.aliceblueonline.com/");
        request.setHeader("X-Device-Type", "web");
        data.add(new BasicNameValuePair("device", "web"));
        data.add(new BasicNameValuePair("login_id", cAccount.getLoginId()));
        data.add(new BasicNameValuePair("password", cAccount.getPassword()));
        while (response == null) {
            try {

                request.setEntity(new UrlEncodedFormEntity(data));
                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
                java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
                log.log(Level.INFO, "ant place loginresult " + cAccount.getLoginId() + "****" + result);
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

    private JSONObject answer(String payloadData) throws UnsupportedEncodingException {
        HttpPost request = new HttpPost("https://ant.aliceblueonline.com/api/v2/checktwofa");
        HttpResponse response = null;
        JSONObject retJson = null;

        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        request.setHeader("Referer", "https://ant.aliceblueonline.com/");
        request.setHeader("X-Device-Type", "web");
        StringEntity params = new StringEntity(payloadData, ContentType.APPLICATION_JSON);
        while (response == null) {
            try {

                request.setEntity(params);
                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
                java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
                log.log(Level.INFO, "ant place answerresult " + cAccount.getLoginId() + "****" + result);
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

    private JSONObject placeOrder(String token, JSONObject objj) {
        java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
        HttpPost request = new HttpPost("https://ant.aliceblueonline.com/api/v2/order");
        List<NameValuePair> data = new ArrayList<NameValuePair>();
        HttpResponse response = null;
        JSONObject retJson = null;

        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        request.setHeader("Referer", "https://ant.aliceblueonline.com/");
        request.setHeader("X-Authorization-Token", token);
        request.setHeader("X-Device-Type", "web");
        data.add(new BasicNameValuePair("exchange", objj.getString("exchange").toUpperCase().split("_")[0]));
        if (from.equalsIgnoreCase("Ant")) {
            data.add(new BasicNameValuePair("instrument_token", objj.getString("instrument_token")));
        } else if (from.equalsIgnoreCase("Kite")) {
            data.add(new BasicNameValuePair("instrument_token", Constants.insMap.get("" + objj.getLong("instrument_token")).getExchangeToken()));
        } else if (from.equalsIgnoreCase("Upstox")) {
            data.add(new BasicNameValuePair("instrument_token", objj.getString("token")));
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
        log.log(Level.INFO, "ant place order qty " + cAccount.getLoginId() + "****" + qty);
        data.add(new BasicNameValuePair("quantity", "" + qty));
        data.add(new BasicNameValuePair("disclosed_quantity", "" + objj.getInt("disclosed_quantity")));
        data.add(new BasicNameValuePair("source", "web"));
        while (response == null) {
            try {

                request.setEntity(new UrlEncodedFormEntity(data));
                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
                log.log(Level.INFO, "ant place orderresult " + cAccount.getLoginId() + "****" + result);
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
