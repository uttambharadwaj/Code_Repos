public class Calabrio_CaseHistoryWrapper {
    
    public string Field { get; set; }
    public object NewValue { get; set; }
    public object OldValue { get; set; }
    public Id CaseOwnerId { get; set;}
    public string CaseOrigin { get; set; }
    public Id CaseId { get; set; }
    public string Reason { get; set; }

    public Calabrio_CaseHistoryWrapper(string Field, object NewValue, object OldValue, Id CaseOwnerId, string CaseOrigin, Id CaseId, string Reason ) {
        this.Field = Field;
        this.NewValue = NewValue;
        this.OldValue = OldValue;
        this.CaseOwnerId = CaseOwnerId;
        this.CaseOrigin = CaseOrigin;
        this.CaseId = CaseId;
        this.Reason = Reason;
    }
    
}