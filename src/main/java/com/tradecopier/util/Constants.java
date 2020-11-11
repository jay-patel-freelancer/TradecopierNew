package util;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Constants {

    public static String LOGIN = "login",
            USER = "user",
            LOGIN_ERROR = "loginError",
            APP_ACCOUNT = "app-account",
            JSON_MIME = "application/json";

    public static SimpleDateFormat dateFormatShort = new SimpleDateFormat("dd-MM-yyyy", new Locale("en", "IN")),
            dateFormatLong = new SimpleDateFormat("dd-MM-yyyy hh:mm a", new Locale("en", "IN")),
            df = new SimpleDateFormat("yyyy-MM-dd");

    public static boolean DEBUG = true;
    
    public static ExecutorService masterThreadExecutor = Executors.newFixedThreadPool(200);
    public static ExecutorService childThreadExecutor = Executors.newFixedThreadPool(200);
    
    public static HashMap<String, Instrument> insMap = new HashMap<>();

    public class JsonResponseCode {

        public final static int OK = 0,
                INVALID_PARAMETER = 1,
                INVALID_CREDENTIAL = 2,
                EMAIL_EXIST = 3,
                DEVICE_WITH_OTHER_USER = 4,
                USER_WITH_OTHER_DEVICE = 5,
                SUBSCRIPTION_EXPIRES = 6,
                PHONE_NUMBER_EXIST = 7,
                WRONG_OTP = 8,
                SERVER_ERROR = 500;
    }
}
