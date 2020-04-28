/**
 * Created by mfarrell on 4/14/20
 * Child of relatedTasksParent
 */

import { LightningElement, api } from 'lwc';
export default class PaginatorBottom extends LightningElement {

    @api totalrecords;
    @api currentpage;
    @api pagesize;

    get showFirstButton() {
        if (this.currentpage === 1) {
            return true;
        }
        return false;
    }

    get showLastButton() {
        if (Math.ceil(this.totalrecords / this.pagesize) === this.currentpage) {
            return true;
        } else {
            return false;
        }
    }
    // button handlers
    handlePrevious() {
        this.dispatchEvent(new CustomEvent('previous'));
    }
    handleNext() {
        this.dispatchEvent(new CustomEvent('next'));
    }
    handleFirst() {
        this.dispatchEvent(new CustomEvent('first'));
    }
    handleLast() {
        this.dispatchEvent(new CustomEvent('last'));
    }
}