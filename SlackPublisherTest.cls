/**
 * Test class for SlackPublisher
 *
 * @author      Scott Coleman <scott@cloudgiants.com>
 */
@isTest
public class SlackPublisherTest {
    
    @isTest
    static void postToSlackTest () {
        SlackPublisher.Payload payload = new SlackPublisher.Payload();
        payload.slackURL = 'https://www.example.test/12345';
        payload.messageText = 'Test message.';
        payload.field1Name = 'Field 1';
        payload.field1Value = 'Value 1';
        payload.field2Name = 'Field 2';
        payload.field2Value = 'Value 2';
        payload.field3Name = 'Field 3';
        payload.field3Value = 'Value 3';
        payload.field4Name = 'Field 4';
        payload.field4Value = 'Value 4';
        payload.recordId = '1234567890';
        
        Test.startTest();

        SlackPublisher.postToSlack(new List<SlackPublisher.Payload>{payload});
        
        Test.stopTest();
    }

}