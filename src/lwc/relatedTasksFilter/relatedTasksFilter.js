/**
 * Created by mfarrell on 4/22/20.
 */

import {LightningElement, api} from 'lwc';

export default class RelatedTasksFilter extends LightningElement {
    @api taskTypeFilter;
    showPopover = false;
    buttonVariant;
    value = [];
    options = [
        { label: 'Call', value: 'Call' },
        { label: 'Email', value: 'Email' },
    ];

    handleChange(event) {
        this.value = event.detail.value;
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
        this.taskTypeFilter = this.value.toString();
        const event = new CustomEvent('filterapplied', {
            detail: this.taskTypeFilter
        });
        this.dispatchEvent(event);
        this.handleCloseClick();

    }
    handleClearFilterClick () {
        this.value = [];
        this.handleApplyFilterClick();
    }

    handleCloseClick () {
        this.showPopover = false;
        this.buttonVariant = undefined;
    }

}