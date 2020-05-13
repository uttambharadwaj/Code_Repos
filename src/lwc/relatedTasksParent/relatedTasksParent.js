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
        this.taskTypeFilter = event.detail;
        console.log(this.taskTypeFilter);
    }
    // handlePageChange(event) {
    //     this.page = event.detail;
    // }
}