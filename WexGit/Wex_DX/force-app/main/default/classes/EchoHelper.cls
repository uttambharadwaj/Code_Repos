public class EchoHelper {

    private static boolean alreadyCreatedTasks = false;

    public static boolean hasAlreadyCreatedFollowUpTasks() {
        return alreadyCreatedTasks;
    }

    public static void setAlreadyCreatedFollowUpTasks() {
        alreadyCreatedTasks = true;
    }

    public static String getFollowUpSubject(String subject) {
        return 'Follow Up: ' + subject;
    }

}