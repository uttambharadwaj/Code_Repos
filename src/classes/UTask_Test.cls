@isTest
public class UTask_Test
{
    //Use this to test task trigger
    static testMethod void testThis()
    {
        Account acc = new Account();
        acc.Name = 'testAcc';   
        insert acc;
         
        Task tsk = New Task();
        tsk.WhatId = acc.Id;
        tsk.type = '0-Standard';
        tsk.subject = 'Solicited Application';
        insert tsk;
    }
}