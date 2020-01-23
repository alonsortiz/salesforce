/*
 * By: Alonso Ortiz - 08/Jan/2020
 * From: https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_apex
 *
 * Challenge 6: Test scheduling logic
 */

@isTest
private class WarehouseSyncScheduleTest {
    
    public static String CRON_EXP = '0 0 0 21 12 ? 2022';
    
    @isTest static void testScheduledJob(){
        
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        
        Test.startTest();
        
        String jobId = System.schedule('WarehouseSyncScheduleTest', CRON_EXP, new WarehouseSyncSchedule());
        
        Test.stopTest();
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger 
                          WHERE Id =: jobId];
        
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-12-21 00:00:00', String.valueOf(ct.NextFireTime));
        
    }
}
