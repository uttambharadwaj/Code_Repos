public class Calabrio_ServiceHistoricalRow {

    // Required columns
    private String acdServiceId;
    private double contactsOffered;
    private double contactsHandled;
    private double contactsAnswered;
    private double contactsAbandoned;
    private double totalTalkSeconds;
    private double totalHoldSeconds;
    private double totalAfterContactWorkSeconds;
    private double totalAnswerDelaySeconds;
    private double serviceLevelPercent;

    // Optional columns
    private Date periodStart;
    private double contactsBlocked;
    private double serviceLevelSeconds;
    private double contactsInQueue;

    public Calabrio_ServiceHistoricalRow(String acdServiceId, double contactsOffered, double contactsHandled, double contactsAnswered, double contactsAbandoned, double totalTalkSeconds, double totalHoldSeconds, double totalAfterContactWorkSeconds, double totalAnswerDelaySeconds, double serviceLevelPercent) {
        this.acdServiceId = acdServiceId;
        this.contactsOffered = contactsOffered;
        this.contactsHandled = contactsHandled;
        this.contactsAnswered = contactsAnswered;
        this.contactsAbandoned = contactsAbandoned;
        this.totalTalkSeconds = totalTalkSeconds;
        this.totalHoldSeconds = totalHoldSeconds;
        this.totalAfterContactWorkSeconds = totalAfterContactWorkSeconds;
        this.totalAnswerDelaySeconds = totalAnswerDelaySeconds;
        this.serviceLevelPercent = serviceLevelPercent;
    }

    public String getAcdServiceId() {
        return acdServiceId;
    }

 //   public void setAcdServiceId(String acdServiceId) {
 //       this.acdServiceId = acdServiceId;
 //   }

    public double getContactsOffered() {
        return contactsOffered;
    }

 //   public void setContactsOffered(double contactsOffered) {
  //      this.contactsOffered = contactsOffered;
 //   }

    public double getContactsHandled() {
        return contactsHandled;
    }

 //   public void setContactsHandled(double contactsHandled) {
 //       this.contactsHandled = contactsHandled;
 //  }

    public double getContactsAnswered() {
        return contactsAnswered;
    }

 //   public void setContactsAnswered(double contactsAnswered) {
 //       this.contactsAnswered = contactsAnswered;
 //   }

    public double getContactsAbandoned() {
        return contactsAbandoned;
    }

  //  public void setContactsAbandoned(double contactsAbandoned) {
 //       this.contactsAbandoned = contactsAbandoned;
 //   }

    public double getTotalTalkSeconds() {
        return totalTalkSeconds;
    }

 //   public void setTotalTalkSeconds(double totalTalkSeconds) {
 //       this.totalTalkSeconds = totalTalkSeconds;
 //   }

    public double getTotalHoldSeconds() {
        return totalHoldSeconds;
    }

 //   public void setTotalHoldSeconds(double totalHoldSeconds) {
  //      this.totalHoldSeconds = totalHoldSeconds;
  //  }

    public double getTotalAfterContactWorkSeconds() {
        return totalAfterContactWorkSeconds;
    }

 //   public void setTotalAfterContactWorkSeconds(double totalAfterContactWorkSeconds) {
 //       this.totalAfterContactWorkSeconds = totalAfterContactWorkSeconds;
 //   }

    public double getTotalAnswerDelaySeconds() {
        return totalAnswerDelaySeconds;
    }

 //   public void setTotalAnswerDelaySeconds(double totalAnswerDelaySeconds) {
  //      this.totalAnswerDelaySeconds = totalAnswerDelaySeconds;
 //   }

    public double getServiceLevelPercent() {
        return serviceLevelPercent;
    }

 //   public void setServiceLevelPercent(double serviceLevelPercent) {
 //       this.serviceLevelPercent = serviceLevelPercent;
 //   }

 //   public Date getPeriodStart() {
 //       return periodStart;
 //   }

 //   public void setPeriodStart(Date periodStart) {
 //       this.periodStart = periodStart;
 //   }

 //   public double getContactsBlocked() {
 //       return contactsBlocked;
 //   }

 //   public void setContactsBlocked(double contactsBlocked) {
 //       this.contactsBlocked = contactsBlocked;
 //   }

 //   public double getServiceLevelSeconds() {
 //       return serviceLevelSeconds;
  //  }

  //  public void setServiceLevelSeconds(double serviceLevelSeconds) {
 //       this.serviceLevelSeconds = serviceLevelSeconds;
 //   }

 //   public double getContactsInQueue() {
  //      return contactsInQueue;
  //  }

  //  public void setContactsInQueue(double contactsInQueue) {
 //       this.contactsInQueue = contactsInQueue;
  //  }
}