/**
 * Created by mfarrell on 4/9/20
 * Child of relatedTasksParent
 */

import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAllTasks from '@salesforce/apex/LWC_TasksController.getAllTasks';
import getTaskCount from '@salesforce/apex/LWC_TasksController.getTaskCount';

export default class TaskList extends NavigationMixin(LightningElement) {
    tasks;
    error;
    @api recordId;
    @api currentpage;
    @api pagesize;
    @api totalrecords;
    @api taskTypeFilter;
    @api taskHistoricalDateFilter;
    @api taskFutureDateFilter;
    totalpages;

    @wire(getTaskCount, {
        recordId: '$recordId',
        taskTypeFilter: '$taskTypeFilter',
        taskHistoricalDateFilter: '$taskHistoricalDateFilter',
        taskFutureDateFilter: '$taskFutureDateFilter'})
    wiredCountTasks({data, error}) {
        if (data) {
            this.totalrecords = data;
            this.error = undefined;
            this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
        } else if (error) {
            this.error = error;
            this.totalrecords = undefined;
        } else {
            this.totalrecords = 0;
        }
    }

    @wire(getAllTasks, {
        pageNumber: '$currentpage',
        pageSize: '$pagesize',
        recordId: '$recordId',
        taskTypeFilter: '$taskTypeFilter',
        taskHistoricalDateFilter: '$taskHistoricalDateFilter',
        taskFutureDateFilter: '$taskFutureDateFilter'})
    wiredGetTasks({data, error}) {
        if (data) {
            this.tasks = data;
            this.error = undefined;
            const event = new CustomEvent('recordsload', {
                detail: this.totalrecords
            });
            this.dispatchEvent(event);
        } else if (error) {
            this.error = error;
            this.tasks = undefined;
        } else {
            this.tasks = [];
            this.totalpages = 1;
        }
    }

    navigateToRecordViewPage(eventRecordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: eventRecordId,
                objectApiName: 'Task',
                actionName: 'view'
            }
        });
    }

    handleClick(event) {
        event.preventDefault();
        event.stopPropagation();
        this.navigateToRecordViewPage(event.target.dataset.recordId);
    }

}