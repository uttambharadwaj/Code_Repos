/**
 * Created by W501611 on 9/15/2020.
 */

public with sharing class CreditLineBeforeUpdateHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp) {

        CreditLineHelper.setCreditLineDataFields(tp.newList);

    }
}