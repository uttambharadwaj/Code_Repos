/**
 * Created by mfarrell on 4/9/20.
 */

import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAllActivities from '@salesforce/apex/LWC_ActivitiesController.getAllActivities';

export default class ActivityList extends NavigationMixin(LightningElement) {
    activities;
    error;

    @api recordId;
    
    @wire(getAllActivities, {recordId: '$recordId'})
    wiredActivities({error, data}) {
        if (data) {
            this.activities = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.activities = undefined;
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