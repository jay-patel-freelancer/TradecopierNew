/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tradecopier.providers;

import java.io.IOException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import javax.net.ssl.SSLContext;
import javax.websocket.DeploymentException;
import okhttp3.ConnectionPool;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.WebSocket;
import org.apache.http.HttpResponse;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.CookieSpecs;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.conn.socket.ConnectionSocketFactory;
import org.apache.http.conn.socket.PlainConnectionSocketFactory;
import org.apache.http.conn.ssl.NoopHostnameVerifier;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.TrustStrategy;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.impl.cookie.BasicClientCookie;
import org.apache.http.ssl.SSLContextBuilder;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import to.MasterAccount;
import upstox.MessageListener;
import upstox.MessageSubscriber;
import upstox.UpstoxWebSocketSubscriber2;
import upstox.WrappedWebSocket;

/**
 *
 * @author umair
 */
public class UpstoxGetOrder implements Runnable {

    MasterAccount account = null;
    CookieStore cookies;
    HttpClient client;
    String token, appId;

    public UpstoxGetOrder(MasterAccount account) {
        this.account = account;
    }

    @Override
    public void run() {
        if (account.isLoged() == false) {
            try {
                BasicCredentialsProvider proxyCredentials = null;
                cookies = new BasicCookieStore();
                BasicClientCookie cookie = new BasicClientCookie("mode", "login");
                cookie.setDomain("");
                cookie.setPath("/");
                cookies.addCookie(cookie);

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
                                .setCookieSpec(CookieSpecs.NETSCAPE)
                                .setProxy(null)
                                .setConnectTimeout(timeout)
                                .setConnectionRequestTimeout(timeout)
                                .setSocketTimeout(timeout)
                                .build())
                        .build();

                getTokenAndAppId();
                connectToSocket();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void getTokenAndAppId() {
        /*HttpGet request = new HttpGet("https://pro.upstox.com/");
        HttpResponse response = null;

        request.setHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36");
        request.setHeader("Referer", "https://pro.upstox.com/");
        request.setHeader("Sec-Fetch-Mode", "navigate");
        request.setHeader("Sec-Fetch-Site", "same-origin");
        request.setHeader("Sec-Fetch-User", "?1");
        request.setHeader("Host", "pro.upstox.com");
        request.setHeader("Upgrade-Insecure-Requests", "1");
        while (response == null) {
            try {
                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
                if (response.getStatusLine().getStatusCode() == 200) {
                    Document doc = Jsoup.parse(result.toString());
                    Elements scripts = doc.getElementsByTag("script");
                    Element script = scripts.get(22);
                    String str = script.data().split("return")[1].split("}")[0] + "}";
                    JSONObject jsonObject = new JSONObject(str);
                    appId = jsonObject.getString("apiId");
                    token = jsonObject.getString("token");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (response != null && response.getEntity() != null) {
                        EntityUtils.consume(response.getEntity());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }*/
        appId = "e6bb46d9d4b16dae8cf5173e047fa10ca1d79ec48d3e9fb747d4eabad8ba5313";
        token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1ODk4MjMxNDk4NTUsImV4cCI6MTU5OTgyMzE0OTg1NSwiaXNzIjoiVVBTVE9YUFJPTUFJTiIsImF1ZCI6IlVQU1RPWFBST01BSU58V0VCIiwic3ViIjoiR2V0IFNvY2tldCBDb25uZWN0aW9uIn0.NVfTTQ9Tp0H7VxWEjG8EBedqpBhI8V7T6reZLT5yYnA";
    }

    public void connectToSocket() throws DeploymentException, IOException, InterruptedException {
        List<MessageSubscriber> subscribers = new ArrayList<>();
        subscribers.add(new UpstoxWebSocketSubscriber2(account, token, appId));
        WrappedWebSocket ws = makeConnection(subscribers);
    }

    private WrappedWebSocket makeConnection(final List<MessageSubscriber> subscribers) {

        final OkHttpClient.Builder httpClientBuilder = new OkHttpClient.Builder();
        final OkHttpClient httpClient = httpClientBuilder
                .connectionPool(
                        new ConnectionPool(5, 1, TimeUnit.SECONDS))
                .readTimeout(5 * 3, TimeUnit.SECONDS)
                .writeTimeout(5 * 3, TimeUnit.SECONDS)
                .pingInterval(2, TimeUnit.SECONDS)
                .retryOnConnectionFailure(true)
                .build();

        final Request request = prepareRequest();

        final WebSocket webSocket = httpClient.newWebSocket(request, new MessageListener(subscribers));

        return new WrappedWebSocket(webSocket);
    }

    private Request prepareRequest() {
        return new Request.Builder()
                .header("Upgrade", "websocket")
                .header("User-Agent", "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36")
                .header("Origin", "https://pro.upstox.com")
                .header("Sec-WebSocket-Key", Double.toString(Math.random()))
                .header("Sec-WebSocket-Version", "13")
                .url("wss://ws.upstox.com/socket.io/?apiId=" + appId + "&token=" + token + "&ReleaseType=Green&client_id=" + account.getLoginId() + "&deviceId=-1922472816&EIO=3&transport=websocket")
                .build();
    }

}
