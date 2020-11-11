package com.tradecopier.util;

import com.tradecopier.exceptions.InvalidRequestParameterValueException;

public class AppSubscription {

    public static interface Subscriptions {
        //Acts as an Parent for 
    }

    public static enum McxBuySellLevels implements Subscriptions {
        COMPLETE_PACKAGE;

        public static boolean isSubscriptionExist(String subFor) {
            boolean isExist = false;
            for (McxBuySellLevels sub : McxBuySellLevels.values()) {
                if (sub.toString().equals(subFor)) {
                    isExist = true;
                    break;
                }
            }
            return isExist;
        }
    }

    public static enum McxAutoTips implements Subscriptions {
        COMPLETE_PACKAGE;

        public static boolean isSubscriptionExist(String subFor) {
            boolean isExist = false;
            for (McxAutoTips sub : McxAutoTips.values()) {
                if (sub.toString().equals(subFor)) {
                    isExist = true;
                    break;
                }
            }
            return isExist;
        }
    }

    public static enum Mt4TradeMaker implements Subscriptions {
        COMPLETE_PACKAGE;

        public static boolean isSubscriptionExist(String subFor) {
            boolean isExist = false;
            for (Mt4TradeMaker sub : Mt4TradeMaker.values()) {
                if (sub.toString().equals(subFor)) {
                    isExist = true;
                    break;
                }
            }
            return isExist;
        }
    }

    public static enum McxRatesAutoTips implements Subscriptions {
        COMPLETE_PACKAGE,
        LIVE_RATES_PACKAGE,
        AUTO_TIPS_PACKAGE;

        public static boolean isSubscriptionExist(String subFor) {
            boolean isExist = false;
            for (McxRatesAutoTips sub : McxRatesAutoTips.values()) {
                if (sub.toString().equals(subFor)) {
                    isExist = true;
                    break;
                }
            }
            return isExist;
        }
    }

    public static class Utils {

        public static AppSubscription.Subscriptions getSubscriptionEnumValue(String subForString, ClientAppName appName) throws InvalidRequestParameterValueException {
            switch (appName) {
                case TRADE_COPIER:
                    if (AppSubscription.Mt4TradeMaker.isSubscriptionExist(subForString)) {
                        return AppSubscription.McxAutoTips.valueOf(subForString);
                    }
            }
            throw new InvalidRequestParameterValueException("Invalid value of Subscription For: " + subForString);
        }

        public static String[] getAppSubscriptionStringArray(ClientAppName appName) {
            AppSubscription.McxBuySellLevels[] enumArray = AppSubscription.McxBuySellLevels.values();
            String[] subs = new String[enumArray.length];
            for (int i = 0; i < subs.length; i++) {
                subs[i] = enumArray[i].toString();
            }
            return subs;
        }
    }
}
