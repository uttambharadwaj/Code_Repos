public class Calabrio_AgentProductivityRow {
    
    public String acdAgentId { get; set;}
    private String acdServiceId;
    private double contactsHandled;
    private double totalTalkSeconds;
    private double totalHoldSeconds;
    private double totalAfterContactWorkSeconds;
    private double totalPeriodHandleTimeSeconds;
    private double totalUnproratedReadyWaitingSeconds;
    private double totalUnproratedNotReadyBusySeconds;
    private double totalUnproratedInSessionSeconds;

    // Optional fields
    Date periodStart;
    double contactsTransferredOut;
    double contactsTransferredIn;
    private double contactsExternalIn;
    private double contactsExternalOut;
    private double totalReservedSeconds;
    private double totalProratedWaitingSeconds;
    private double totalProratedNotReadyBusySeconds;
    private double contactsAnswered;
    private double totalAnswerDelaySeconds;

    public Calabrio_AgentProductivityRow(String acdAgentId, String acdServiceId, double contactsHandled, double totalTalkSeconds,
                                double totalHoldSeconds, double totalAfterContactWorkSeconds, double totalPeriodHandleTimeSeconds,
                                double totalUnproratedReadyWaitingSeconds, double totalUnproratedNotReadyBusySeconds,
                                double totalUnproratedInSessionSeconds,double totalAnswerDelaySeconds) {
        this.acdAgentId = acdAgentId;
        this.acdServiceId = acdServiceId;
        this.contactsHandled = contactsHandled;
        this.totalTalkSeconds = totalTalkSeconds;
        this.totalHoldSeconds = totalHoldSeconds;
        this.totalAfterContactWorkSeconds = totalAfterContactWorkSeconds;
        this.totalPeriodHandleTimeSeconds = totalPeriodHandleTimeSeconds;
        this.totalUnproratedReadyWaitingSeconds = totalUnproratedReadyWaitingSeconds;
        this.totalUnproratedNotReadyBusySeconds = totalUnproratedNotReadyBusySeconds;
        this.totalUnproratedInSessionSeconds = totalUnproratedInSessionSeconds;
        this.totalAnswerDelaySeconds = totalAnswerDelaySeconds;
    }

    //public String getAcdAgentId() {
   //     return acdAgentId;
   // }

    //public void setAcdAgentId(String acdAgentId) {
  //      this.acdAgentId = acdAgentId;
   // }

    public String getAcdServiceId() {
        return acdServiceId;
    }

   // public void setAcdServiceId(String acdServiceId) {
   //     this.acdServiceId = acdServiceId;
   // }

    public double getContactsHandled() {
        return contactsHandled;
    }

    //public void setContactsHandled(double contactsHandled) {
   //     this.contactsHandled = contactsHandled;
   // }

    public double getTotalTalkSeconds() {
        return totalTalkSeconds;
    }

  //  public void setTotalTalkSeconds(double totalTalkSeconds) {
  //      this.totalTalkSeconds = totalTalkSeconds;
  //  }

    public double getTotalHoldSeconds() {
        return totalHoldSeconds;
    }

  //  public void setTotalHoldSeconds(double totalHoldSeconds) {
   //     this.totalHoldSeconds = totalHoldSeconds;
  //  }

    public double getTotalAfterContactWorkSeconds() {
        return totalAfterContactWorkSeconds;
    }

  //  public void setTotalAfterContactWorkSeconds(double totalAfterContactWorkSeconds) {
  //      this.totalAfterContactWorkSeconds = totalAfterContactWorkSeconds;
  //  }

    public double getTotalPeriodHandleTimeSeconds() {
        return totalPeriodHandleTimeSeconds;
    }

   // public void setTotalPeriodHandleTimeSeconds(double totalPeriodHandleTimeSeconds) {
  //      this.totalPeriodHandleTimeSeconds = totalPeriodHandleTimeSeconds;
  //  }

    public double getTotalUnproratedReadyWaitingSeconds() {
        return totalUnproratedReadyWaitingSeconds;
    }

  //  public void setTotalUnproratedReadyWaitingSeconds(double totalUnproratedReadyWaitingSeconds) {
  //      this.totalUnproratedReadyWaitingSeconds = totalUnproratedReadyWaitingSeconds;
  //  }

    public double getTotalUnproratedNotReadyBusySeconds() {
        return totalUnproratedNotReadyBusySeconds;
    }

  //  public void setTotalUnproratedNotReadyBusySeconds(double totalUnproratedNotReadyBusySeconds) {
  //      this.totalUnproratedNotReadyBusySeconds = totalUnproratedNotReadyBusySeconds;
  //  }

    public double getTotalUnproratedInSessionSeconds() {
        return totalUnproratedInSessionSeconds;
    }

  //  public void setTotalUnproratedInSessionSeconds(double totalUnproratedInSessionSeconds) {
  //      this.totalUnproratedInSessionSeconds = totalUnproratedInSessionSeconds;
  //  }

  //  public Date getPeriodStart() {
  //      return periodStart;
  //  }

  //  public void setPeriodStart(Date periodStart) {
  //      this.periodStart = periodStart;
  //  }

  //  public double getContactsTransferredOut() {
  //      return contactsTransferredOut;
  //  }

  //  public void setContactsTransferredOut(double contactsTransferredOut) {
  //      this.contactsTransferredOut = contactsTransferredOut;
  //  }

  //  public double getContactsTransferredIn() {
  //      return contactsTransferredIn;
  //  }

  //  public void setContactsTransferredIn(double contactsTransferredIn) {
  //      this.contactsTransferredIn = contactsTransferredIn;
  //  }

 //   public double getContactsExternalIn() {
  //      return contactsExternalIn;
  //  }

  //  public void setContactsExternalIn(double contactsExternalIn) {
  //      this.contactsExternalIn = contactsExternalIn;
  //  }

 //   public double getContactsExternalOut() {
 //       return contactsExternalOut;
  //  }

 //   public void setContactsExternalOut(double contactsExternalOut) {
 //       this.contactsExternalOut = contactsExternalOut;
 //   }

  //  public double getTotalReservedSeconds() {
  //      return totalReservedSeconds;
  //  }

  //  public void setTotalReservedSeconds(double totalReservedSeconds) {
  //      this.totalReservedSeconds = totalReservedSeconds;
  //  }

  //  public double getTotalProratedWaitingSeconds() {
  //      return totalProratedWaitingSeconds;
  //  }

  //  public void setTotalProratedWaitingSeconds(double totalProratedWaitingSeconds) {
 //       this.totalProratedWaitingSeconds = totalProratedWaitingSeconds;
  //  }

 //   public double getTotalProratedNotReadyBusySeconds() {
 //       return totalProratedNotReadyBusySeconds;
 //   }

 //   public void setTotalProratedNotReadyBusySeconds(double totalProratedNotReadyBusySeconds) {
 //       this.totalProratedNotReadyBusySeconds = totalProratedNotReadyBusySeconds;
 //   }

 //   public double getContactsAnswered() {
 //       return contactsAnswered;
 //   }

 //   public void setContactsAnswered(double contactsAnswered) {
 //       this.contactsAnswered = contactsAnswered;
 //   }

    public double getTotalAnswerDelaySeconds() {
        return totalAnswerDelaySeconds;
    }

  //  public void setTotalAnswerDelaySeconds(double totalAnswerDelaySeconds) {
  //      this.totalAnswerDelaySeconds = totalAnswerDelaySeconds;
  //  }

}