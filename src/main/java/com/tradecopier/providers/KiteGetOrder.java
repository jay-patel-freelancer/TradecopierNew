/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tradecopier.providers;

import dblayer.MasterChildAccountsDAO;
import dblayer.OrdersDAO;
import java.io.UnsupportedEncodingException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
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
import org.json.JSONArray;
import org.json.JSONObject;
import to.ChildAccount;
import to.MasterAccount;
import util.Constants;
import java.util.logging.Level;

/**
 *
 * @author umair
 */
public class KiteGetOrder implements Runnable {

    MasterAccount accountm = null;
    CookieStore cookies;
    HttpClient client;
    private MasterChildAccountsDAO maDAO = new MasterChildAccountsDAO();
    private OrdersDAO orderDAO = new OrdersDAO();

    public KiteGetOrder(MasterAccount account) {
        this.accountm = account;
    }

    @Override
    public void run() {
        try {
            BasicCredentialsProvider proxyCredentials = null;
            if (accountm.getCookie() != null) {
                cookies = new BasicCookieStore();
            } else {
                cookies = new BasicCookieStore();
            }
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

            boolean b = false;
            if (accountm.getCookie() != null) {
                java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
                log.log(Level.INFO, "kite get orders 1 ");
                b = orders(accountm.getToken());
            }

            if (b == false) {
                getRequest();

                JSONObject loginObject = login(accountm.getLoginId().trim(), accountm.getPassword().trim());

                java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
                log.log(Level.INFO, "kite get orders loginObject " + loginObject);

                if (loginObject == null || !loginObject.get("status").equals("success")) {
                    return;
                }

                String requestId = loginObject.getJSONObject("data").getString("request_id");;
                JSONObject answerObject = answer(accountm.getLoginId(), requestId, accountm.getPin());

                log.log(Level.INFO, "kite get orders answerObject " + answerObject);
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
                maDAO.addCookieToM(cookies, token, accountm.getId());
                accountm.setToken(token);
                accountm.setCookie(cookies);
                orders(token);
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
                log.log(Level.INFO, "kite login string " + result.toString());
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

    private JSONObject getOrders(String token) {
        HttpGet request = new HttpGet("https://kite.zerodha.com/oms/orders");
        HttpResponse response = null;
        JSONObject retJson = null;

        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        request.setHeader("Referer", "https://kite.zerodha.com/orders");
        request.setHeader("Accept", "application/json, text/plain, */*");
        request.setHeader("authorization", "enctoken " + token);
        request.setHeader("Host", "kite.zerodha.com");
        request.setHeader("x-kite-version", "2.0.4");
        while (response == null) {
            try {
                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
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

    public boolean orders(String token) throws ParseException, SQLException {
        JSONObject ordersObject = getOrders(token);

        java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
        log.log(Level.INFO, "kite ordersObject " + ordersObject);

        if (ordersObject == null || !ordersObject.get("status").equals("success")) {
            return false;
        }
        JSONArray orderArray = ordersObject.getJSONArray("data");

        ArrayList<JSONObject> objs = new ArrayList<>();

        for (int i = 0; i < orderArray.length(); i++) {
            JSONObject obj = orderArray.getJSONObject(i);
            if (accountm.isOrf()) {
                orderDAO.addOrder(obj.getString("order_id"));
            } else if (orderDAO.isExist(obj.getString("order_id")) == false && (obj.getString("order_type").equalsIgnoreCase("MARKET") || obj.getString("order_type").equalsIgnoreCase("LIMIT"))) {
                boolean b = true;
                if (obj.getString("order_type").equalsIgnoreCase("LIMIT") && !obj.getString("status").equalsIgnoreCase("Complete")) {
                    b = false;
                }
                if (b == true) {
                    objs.add(obj);
                    log.log(Level.INFO, "kite ordersID " + obj.getString("order_id"));
                    orderDAO.addOrder(obj.getString("order_id"));
                }
            }
        }
        if (accountm.isOrf()) {
            maDAO.updateOrf(false);
        }
        if (objs.size() > 0) {
            ArrayList<ChildAccount> cAccounts = maDAO.getChildAccountsByMasterId(accountm.getId());
            for (ChildAccount account : cAccounts) {
                if (account.getBroker().equalsIgnoreCase("Kite") && account.getOnOff().equalsIgnoreCase("on")) {
                    Constants.childThreadExecutor.submit(new KiteSendKeys(account, objs, "Kite", accountm));
                } else if (account.getBroker().equalsIgnoreCase("Ant") && account.getOnOff().equalsIgnoreCase("on")) {
                    Constants.childThreadExecutor.submit(new AntSendKeys(account, objs, "Kite", accountm));
                } else if (account.getBroker().equalsIgnoreCase("Upstox") && account.getOnOff().equalsIgnoreCase("on")) {
                    Constants.childThreadExecutor.submit(new UpstoxSendKeys(account, objs, "Kite"));
                }
            }
        }
        return true;
    }

}
