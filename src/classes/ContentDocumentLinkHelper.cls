public class ContentDocumentLinkHelper {

	public static void fleetEnrollmentContentDocumentAdded(List<ContentDocumentLink> records) {

		List<ContentDocumentLink> fleetEnrollmentLinks = new List<ContentDocumentLink>();
		for (ContentDocumentLink record : records) {

			if (record.LinkedEntityId != null) {
				String objectName = UtilityClass.getObjName(record.LinkedEntityId);
				if (objectName.equalsIgnoreCase('FleetEnrollment__c')) fleetEnrollmentLinks.add(record);
			}
		}

		if (!fleetEnrollmentLinks.isEmpty()) FleetEnrollmentData.fleetEnrollmentDataUpdated(fleetEnrollmentLinks);
	}
}