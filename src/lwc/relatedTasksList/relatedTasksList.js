/**
 * Created by mfarrell on 4/9/20
 * Child of relatedTasksParent
 */

import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAllTasks from '@salesforce/apex/LWC_TasksController.getAllTasks';
import getTaskCount from '@salesforce/apex/LWC_TasksController.getTaskCount';

export default class TaskList extends NavigationMixin(LightningElement) {
    activities;
    error;
    @api recordId;
    @api currentpage;
    @api pagesize;
    @api totalrecords;
    totalpages;
    localCurrentPage = null;

    renderedCallback() {
        // trying to prevent multiple executions of this code.
        if (this.localCurrentPage === this.currentpage) {
            return;
        }
        this.localCurrentPage = this.currentpage;
        getTaskCount({ recordId: this.recordId })
            .then(recordsCount => {
                this.totalrecords = recordsCount;
                if (recordsCount) {
                    this.totalpages = Math.ceil(recordsCount / this.pagesize);
                    getAllTasks({ pageNumber: this.currentpage, numberOfRecords: recordsCount, pageSize: this.pagesize, recordId: this.recordId })
                        .then(data => {
                            this.activities = data;
                            this.error = undefined;
                        })
                        .catch(error => {
                            this.error = error;
                            this.activities = undefined;
                        });
                } else {
                    this.activities = [];
                    this.totalpages = 1;
                    this.totalrecords = 0;
                }
                const event = new CustomEvent('recordsload', {
                    detail: recordsCount
                });
                this.dispatchEvent(event);
            })
            .catch(error => {
                this.error = error;
                this.totalrecords = undefined;
            });
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