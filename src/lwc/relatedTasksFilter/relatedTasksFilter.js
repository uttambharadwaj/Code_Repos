/**
 * Created by mfarrell on 4/22/20.
 */

import {LightningElement, api} from 'lwc';

export default class RelatedTasksFilter extends LightningElement {
    @api taskTypeFilter;
    @api taskHistoricalDateFilter = false;
    @api taskFutureDateFilter = false;
    showPopover = false;
    buttonVariant;
    filters = {};
    typeValue = [];
    typeOptions = [
        { label: 'Call', value: 'Call' },
        { label: 'Email', value: 'Email' },
        { label: 'Skip Tracing', value: 'Skip Tracing' },
        { label: 'Returned Payment', value: 'Returned Payment' },
        { label: 'Account Maintenance', value: 'Account Maintenance' },
    ];
    dateValue = [];
    dateOptions = [
        { label: 'Future', value: 'Future' },
        { label: 'Historical', value: 'Historical' },
    ];

    handleTypeChange(event) {
        this.typeValue = event.detail.value;
    }
    handleDateChange(event) {
        this.dateValue = event.detail.value;
    }
    handleFilterClick () {
        if(this.showPopover) {
            this.handleCloseClick();
        } else {
            this.showPopover = true;
            this.buttonVariant = 'brand';
        }
    }
    handleApplyFilterClick () {
        this.taskTypeFilter = this.typeValue.toString();
        this.taskFutureDateFilter = this.dateValue.includes('Future');
        this.taskHistoricalDateFilter = this.dateValue.includes('Historical');
        this.filters = {type: this.taskTypeFilter, historicalDates: this.taskHistoricalDateFilter, futureDates: this.taskFutureDateFilter}
        const event = new CustomEvent('filterapplied', {
            detail: this.filters
        });
        this.dispatchEvent(event);
        this.handleCloseClick();

    }
    handleClearFilterClick () {
        this.typeValue = [];
        this.dateValue = [];
        this.handleApplyFilterClick();
    }
    handleCloseClick () {
        this.showPopover = false;
        this.buttonVariant = undefined;
    }

}