@isTest
private class TestVerifyDate {
    
    @isTest static void date1BeforeDate2() {
        Date date1 = System.today();
        Date date2 = System.today().addDays(50);
        Date date3 = VerifyDate.CheckDates(date1, date2);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
		Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(lastDay, date3);
    }
    
    @isTest static void date2BeforeDate1() {
        Date date1 = System.today().addDays(50);
        Date date2 = System.today();
        Date date3 = VerifyDate.CheckDates(date1, date2);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
		Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(lastDay, date3);
    }
    
    @isTest static void date1Within30Date2() {
        Date date1 = System.today().addDays(10);
        Date date2 = System.today();
        Date date3 = VerifyDate.CheckDates(date1, date2);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
		Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(lastDay, date3);
    }
    
    @isTest static void date2Within30Date1() {
        Date date1 = System.today();
        Date date2 = System.today().addDays(10);
        Date date3 = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(date2, date3);
    }
    
    @isTest static void date1equalsDate2 () {
        Date date1 = System.today();
        Date date2 = System.today();
        Date date3 = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(date2, date3);
    }
}