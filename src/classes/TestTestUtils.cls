@isTest
public class TestTestUtils {
    @isTest static void testSetBoolean(){
        TestUtils.enable_isRunningTest = true;
        SYSTEM.assertEquals(true, TestUtils.isRunningTest(), 'Assert:');
        
    }
    @isTest static void testDefaultBoolean(){
        
        SYSTEM.assertEquals(false, TestUtils.isRunningTest(), 'Assert:');
        
    }
    
    
}