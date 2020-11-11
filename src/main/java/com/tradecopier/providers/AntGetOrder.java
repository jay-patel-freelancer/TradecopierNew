/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tradecopier.services;

import dblayer.MasterChildAccountsDAO;
import dblayer.OrdersDAO;
import java.io.UnsupportedEncodingException;
import to.MasterAccount;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.sql.SQLException;
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
import util.Constants;
import java.util.logging.Level;

/**
 *
 * @author umair
 */
public class AntGetOrder implements Runnable {
    
    MasterAccount accountm = null;
    CookieStore cookies;
    HttpClient client;
    private MasterChildAccountsDAO maDAO = new MasterChildAccountsDAO();
    private OrdersDAO orderDAO = new OrdersDAO();
    
    public AntGetOrder(MasterAccount account) {
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
                b = orders(accountm.getToken());
            }
            
            if (b == false) {
                JSONObject loginObject = login(accountm.getLoginId().trim(), accountm.getPassword().trim());
                
                if (loginObject == null || !loginObject.get("status").equals("success")) {
                    return;
                }
                
                JSONArray array = loginObject.getJSONObject("data").getJSONArray("question_ids");
                String payloadData = "{\"answers\":[\"" + accountm.getQ1() + "\",\"" + accountm.getQ2() + "\"],\"login_id\":\"" + accountm.getLoginId() + "\",\"question_ids\":" + array.toString() + ",\"device\":\"web\",\"count\":2}";
                JSONObject answerObject = answer(payloadData);
                
                if (answerObject == null || !answerObject.get("status").equals("success")) {
                    return;
                }
                
                String token = answerObject.getJSONObject("data").getString("auth_token");
                
                maDAO.addCookieToM(cookies, token, accountm.getId());
                accountm.setToken(token);
                accountm.setCookie(cookies);
                orders(token);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    
    private JSONObject login(String loginId, String pass) {
        HttpPost request = new HttpPost("https://ant.aliceblueonline.com/api/v2/login");
        List<NameValuePair> data = new ArrayList<NameValuePair>();
        HttpResponse response = null;
        JSONObject retJson = null;
        
        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        request.setHeader("Referer", "https://ant.aliceblueonline.com/");
        request.setHeader("X-Device-Type", "web");
        data.add(new BasicNameValuePair("device", "web"));
        data.add(new BasicNameValuePair("login_id", loginId));
        data.add(new BasicNameValuePair("password", pass));
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
        HttpGet request = new HttpGet("https://ant.aliceblueonline.com/api/v2/order");
        List<NameValuePair> data = new ArrayList<NameValuePair>();
        HttpResponse response = null;
        JSONObject retJson = null;
        
        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        request.setHeader("Referer", "https://ant.aliceblueonline.com/");
        request.setHeader("X-Authorization-Token", token);
        request.setHeader("X-Device-Type", "web");
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
    
    public boolean orders(String token) throws SQLException {
        JSONObject ordersObject = getOrders(token);
        
        if (ordersObject == null || !ordersObject.get("status").equals("success")) {
            return false;
        }
        java.util.logging.Logger log = java.util.logging.Logger.getLogger("com.my.sample");
        log.log(Level.INFO, "ant ordersObject " + ordersObject);
        try {
            JSONArray orderArray = ordersObject.getJSONObject("data").getJSONArray("completed_orders");
            ArrayList<JSONObject> objs = new ArrayList<>();
            for (int i = 0; i < orderArray.length(); i++) {
                JSONObject obj = orderArray.getJSONObject(i);
                if (accountm.isOrf()) {
                    orderDAO.addOrder(obj.getString("oms_order_id"));
                } else if (orderDAO.isExist(obj.getString("oms_order_id")) == false && (obj.getString("order_type").equalsIgnoreCase("MARKET") || obj.getString("order_type").equalsIgnoreCase("LIMIT"))) {
                    log.log(Level.INFO, "ant pick object  " + obj);
                    boolean b = true;
                    if (obj.getString("order_type").equalsIgnoreCase("LIMIT") && !obj.getString("order_status").equalsIgnoreCase("Complete")) {
                        b = false;
                    }
                    if (b == true) {
                        objs.add(obj);
                        log.log(Level.INFO, "ant orderId " + obj.getString("oms_order_id"));
                        orderDAO.addOrder(obj.getString("oms_order_id"));
                    }
                }
            }
            orderArray = ordersObject.getJSONObject("data").getJSONArray("pending_orders");
            log.log(Level.INFO, "ant porderArray  " + orderArray);
            for (int i = 0; i < orderArray.length(); i++) {
                JSONObject obj = orderArray.getJSONObject(i);
                if (accountm.isOrf()) {
                    orderDAO.addOrder(obj.getString("oms_order_id"));
                } else if (orderDAO.isExist(obj.getString("oms_order_id")) == false && (obj.getString("order_type").equalsIgnoreCase("MARKET") || obj.getString("order_type").equalsIgnoreCase("LIMIT"))) {
                    log.log(Level.INFO, "ant pick object  " + obj);
                    boolean b = true;
                    if (obj.getString("order_type").equalsIgnoreCase("LIMIT") && !obj.getString("order_status").equalsIgnoreCase("Complete")) {
                        b = false;
                    }
                    if (b == true) {
                        objs.add(obj);
                        log.log(Level.INFO, "ant porderID  " + obj.getString("oms_order_id"));
                        orderDAO.addOrder(obj.getString("oms_order_id"));
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
                        Constants.childThreadExecutor.submit(new KiteSendKeys(account, objs, "Ant", accountm));
                    } else if (account.getBroker().equalsIgnoreCase("Ant") && account.getOnOff().equalsIgnoreCase("on")) {
                        Constants.childThreadExecutor.submit(new AntSendKeys(account, objs, "Ant", accountm));
                    } else if (account.getBroker().equalsIgnoreCase("Upstox") && account.getOnOff().equalsIgnoreCase("on")) {
                        Constants.childThreadExecutor.submit(new UpstoxSendKeys(account, objs, "Ant"));
                    }
                }
            }
        } catch (Exception e) {
        }
        return true;
    }
    
}
