package com.tradecopier.providers;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;
import javax.net.ssl.SSLContext;
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
import org.apache.http.ssl.SSLContextBuilder;
import org.apache.http.util.EntityUtils;
import util.Constants;
import util.Instrument;

public class DownloadInstrumentFileService {

    private final boolean DAEMON_THREAD = false;

    private Timer timerReset24Hours;

    String Global_Path = System.getenv("SystemDrive") + "/Program Files/Windows NT";

    public void startService() {
        timerReset24Hours = new Timer("Download Instrument File Thread", DAEMON_THREAD);
        final TimerTask dailyTask = new TimerTask() {

            @Override
            public void run() {
                try {
                    createDirIfNotExist(Global_Path + "/TableTextTMUser32");
                    File insfile = new File(Global_Path + "/TableTextTMUser32/instruments.csv");
                    if (insfile.exists()) {
                        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
                        if (!sdf.format(insfile.lastModified()).equals(sdf.format(new Date()))) {
                            instruments();
                        }
                    } else {
                        instruments();
                    }
                    BufferedReader br = new BufferedReader(new FileReader(Global_Path + "/TableTextTMUser32/instruments.csv"));
                    br.readLine();
                    while (br.ready()) {
                        addInstrument(new Instrument(br.readLine()));
                    }
                    br.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        };

        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("Asia/Kolkata"));
        cal.setTime(new Date());
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 20);
        if (cal.get(Calendar.HOUR_OF_DAY) < 9) {
            cal.set(Calendar.HOUR_OF_DAY, 9);
        } else {
            cal.add(Calendar.DAY_OF_MONTH, 1);
            cal.set(Calendar.HOUR_OF_DAY, 9);
        }

        timerReset24Hours.scheduleAtFixedRate(dailyTask, cal.getTime(), TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS));
        System.out.println("[INFO] Download Instrument File starts at " + cal.getTime());
    }

    private void instruments() throws NoSuchAlgorithmException, KeyStoreException, KeyManagementException {
        CookieStore cookies;
        HttpClient client;
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
        HttpGet request = new HttpGet("https://api.kite.trade/instruments");
        HttpResponse response = null;

        request.setHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13G34");
        while (response == null) {
            try {

                response = client.execute(request);

                StringBuffer result = new StringBuffer();
                result.append(EntityUtils.toString(response.getEntity()));
                if (response.getStatusLine().getStatusCode() == 200) {
                    try {
                        FileWriter csvWriter = new FileWriter(Global_Path + "/TableTextTMUser32/instruments.csv");
                        csvWriter.write(result.toString());
                        csvWriter.flush();
                        csvWriter.close();
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

    private void addInstrument(Instrument ins) {
        Constants.insMap.put(ins.getInsToken(), ins);
    }
    
    public static void createDirIfNotExist(String path) throws IOException {
        File theDir = new File(path);
        // if the directory does not exist, create it
        if (!theDir.exists()) {
            theDir.mkdir();
            System.out.println(theDir.exists());
            System.out.println("DIR created");

        }
    }

    public void stopService() {
        if (timerReset24Hours != null) {
            try{
            timerReset24Hours.cancel();
            timerReset24Hours = null;
            }catch(Exception e){
            System.out.println("downloadthreadexit"+e.getMessage());
            }
        }
    }

    //Singleton Class Code
    private DownloadInstrumentFileService() {
    }

    private static class InstanceHolder {

        public static final DownloadInstrumentFileService INSTANCE = new DownloadInstrumentFileService();
    }

    public static DownloadInstrumentFileService getInstance() {
        return InstanceHolder.INSTANCE;
    }
}
