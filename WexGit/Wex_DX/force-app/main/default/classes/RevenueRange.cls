/**
 * Created by lhowland on 3/25/2020.
 * Used to build the Revolver credit limit matrix
 */

public without sharing class RevenueRange {

    public Decimal minimmRevenue { get; set; }
    public Decimal maximumRevenue { get; set; }
    public Decimal creditLine { get; set; }

    public RevenueRange() {
    }

    public RevenueRange(Decimal minimmRevenue, Decimal maximumRevenue, Decimal creditLine) {
        this.minimmRevenue = minimmRevenue;
        this.maximumRevenue = maximumRevenue;
        this.creditLine = creditLine;
    }
}