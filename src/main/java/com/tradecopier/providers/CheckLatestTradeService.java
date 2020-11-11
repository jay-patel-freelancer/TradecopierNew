package com.tradecopier.providers;

import dblayer.MasterChildAccountsDAO;
import dblayer.TCOnOffDAO;
import java.sql.SQLException;
import java.text.DateFormatSymbols;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;
import to.ClientAppAccount;
import to.MasterAccount;
import to.TradeCopierOnOff;
import util.ClientAppName;
import util.Constants;

public class CheckLatestTradeService {

    private Timer timer, timer2;
    private MasterChildAccountsDAO maDAO = new MasterChildAccountsDAO();
    private ClientAppAccountService appAccountService = new ClientAppAccountService();
    private final TCOnOffDAO tcoo = new TCOnOffDAO();
    private int delay = 0, delay2 = 0;
    private Timer timerReset24Hours;
    private Timer timerReset24Hours2;
    private final boolean DAEMON_THREAD = false;

    public void startService() {
        timerReset24Hours = new Timer("Latest Trade Thread", DAEMON_THREAD);
        final TimerTask dailyTask = new TimerTask() {

            @Override
            public void run() {
                try {
                    maDAO.logoutUpstox();
                } catch (SQLException ex) {
                }
                startServices();
            }
        };

        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("Asia/Kolkata"));
        cal.setTime(new Date());
        cal.set(Calendar.MINUTE, 55);
        cal.set(Calendar.SECOND, 0);
        if (cal.get(Calendar.HOUR_OF_DAY) < 8) {
            cal.set(Calendar.HOUR_OF_DAY, 8);
        } else {
            cal.add(Calendar.DAY_OF_MONTH, 1);
            cal.set(Calendar.HOUR_OF_DAY, 8);
        }

        timerReset24Hours.scheduleAtFixedRate(dailyTask, cal.getTime(), TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS));

        timerReset24Hours2 = new Timer("Latest Trade Thread", DAEMON_THREAD);
        final TimerTask dailyTask2 = new TimerTask() {

            @Override
            public void run() {
                stopService();
                try {
                    maDAO.logoutUpstox();
                } catch (SQLException ex) {
                }
            }
        };

        Calendar cal2 = Calendar.getInstance(TimeZone.getTimeZone("Asia/Kolkata"));
        cal2.setTime(new Date());
        cal2.set(Calendar.MINUTE, 55);
        cal2.set(Calendar.SECOND, 0);
        if (cal2.get(Calendar.HOUR_OF_DAY) < 23) {
            cal2.set(Calendar.HOUR_OF_DAY, 23);
        } else {
            cal2.add(Calendar.DAY_OF_MONTH, 1);
            cal2.set(Calendar.HOUR_OF_DAY, 23);
        }

        timerReset24Hours2.scheduleAtFixedRate(dailyTask2, cal2.getTime(), TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS));
    }

    public void startServices() {
        timer = new Timer();
        startPoker();
        startPoker2();
    }

    private void startPoker() {
        timer = new Timer();
        timer.schedule(new TimerTask() {
            public void run() {
                try {
                    TradeCopierOnOff tco = tcoo.getTradeCopierOnOff();
                    if (tco != null && tco.isOnoff() == true) {
                        Calendar callendar = Calendar.getInstance(TimeZone.getTimeZone("Asia/Kolkata"));
                        String dayNames[] = new DateFormatSymbols().getWeekdays();
                        if (!dayNames[callendar.get(Calendar.DAY_OF_WEEK)].toLowerCase().equals("sunday") && !dayNames[callendar.get(Calendar.DAY_OF_WEEK)].toLowerCase().equals("saturday")) {
                            ArrayList<MasterAccount> mAccounts = maDAO.getMasterAccounts();
                            for (MasterAccount account : mAccounts) {
                                ClientAppAccount appAccountWithUser = appAccountService.getUserAppAccountByUserId(account.getUserId(), ClientAppName.valueOf("TRADE_COPIER"));
                                Calendar calToday = Calendar.getInstance(TimeZone.getTimeZone("Asia/Kolkata"));
                                calToday.setTime(new Date());
                                calToday.set(Calendar.HOUR_OF_DAY, 0);
                                calToday.set(Calendar.MINUTE, 0);
                                calToday.set(Calendar.SECOND, 0);
                                calToday.set(Calendar.MILLISECOND, 0);
                                long dateDiffInMillis = appAccountWithUser.getSubscriptionExpireDate().getTime() - calToday.getTime().getTime();
                                if ((TimeUnit.DAYS.convert(dateDiffInMillis, TimeUnit.MILLISECONDS)) > 0) {
                                    if (account.getBroker().trim().equalsIgnoreCase("Kite") && account.getOnOff().equalsIgnoreCase("on")) {
                                        Constants.masterThreadExecutor.submit(new KiteGetOrder(account));
                                    } else if (account.getBroker().trim().equalsIgnoreCase("Ant") && account.getOnOff().equalsIgnoreCase("on")) {
                                        Constants.masterThreadExecutor.submit(new AntGetOrder(account));
                                    } else if (account.getBroker().trim().equalsIgnoreCase("Upstox") && account.getOnOff().equalsIgnoreCase("on")) {
                                        Constants.masterThreadExecutor.submit(new UpstoxGetOrder(account));
                                    }
                                }
                            }
                        }
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
                delay = 2000;  // change the delay time
                timer.cancel(); // cancel time
                startPoker();   // start the time again with a new delay time
            }
        }, delay, 2000);
    }
    
    private void startPoker2() {
        timer2 = new Timer();
        timer2.schedule(new TimerTask() {
            public void run() {
                try {
                    TradeCopierOnOff tco = tcoo.getTradeCopierOnOff();
                    if (tco != null && tco.isOnoff() == true) {
                        Calendar callendar = Calendar.getInstance(TimeZone.getTimeZone("Asia/Kolkata"));
                        String dayNames[] = new DateFormatSymbols().getWeekdays();
                        if (!dayNames[callendar.get(Calendar.DAY_OF_WEEK)].toLowerCase().equals("sunday") && !dayNames[callendar.get(Calendar.DAY_OF_WEEK)].toLowerCase().equals("saturday")) {
                            try {
                                maDAO.logoutAll();
                            } catch (SQLException ex) {
                            }
                        }
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
                delay2 = 60*1000*10;
                timer2.cancel();
                startPoker2();
            }
        }, delay2, 60*1000*10);
    }

    public void stopService() {
        if (timer != null) {
            try {
                timer.cancel();
                timer = null;
            } catch (Exception e) {
            }
        }
        if (timer2 != null) {
            try {
                timer2.cancel();
                timer2 = null;
            } catch (Exception e) {
            }
        }
    }

    //Singleton Class Code
    private CheckLatestTradeService() {
    }

    private static class InstanceHolder {

        public static final CheckLatestTradeService INSTANCE = new CheckLatestTradeService();
    }

    public static CheckLatestTradeService getInstance() {
        return InstanceHolder.INSTANCE;
    }
}
