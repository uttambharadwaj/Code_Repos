/**
 * Created by mfarrell on 4/14/20.
 * Parent Component for related tasks
 */

import { LightningElement, track, api } from 'lwc';

export default class PaginationParent extends LightningElement {
    @api page = 1;
    @api recordId;
    @api totalrecords;
    @api pagesize;
    @api taskTypeFilter = '';
    @api taskHistoricalDateFilter = null;
    @api taskFutureDateFilter = null;

    handlePrevious() {
        if (this.page > 1) {
            this.page = this.page - 1;
        }
    }
    handleNext() {
        if (this.page < this.totalPages)
            this.page = this.page + 1;
    }
    handleFirst() {
        this.page = 1;
    }
    handleLast() {
        this.page = this.totalPages;
    }
    handleRecordsLoad(event) {
        this.totalrecords = event.detail;
        this.totalPages = Math.ceil(this.totalrecords / this.pagesize);
    }
    handledFilterApplied(event) {
        this.taskTypeFilter = event.detail.type;
        this.taskFutureDateFilter = event.detail.futureDates;
        this.taskHistoricalDateFilter = event.detail.historicalDates;
    }

}