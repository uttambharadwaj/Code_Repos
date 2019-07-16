public class Calabrio_Chats {
    
    public Calabrio_Chats() {
        createdChats = new List<LiveChatTranscript>();
        closedChats = new List<LiveChatTranscript>();
    }
    
    private List<LiveChatTranscript> createdChats;
    private List<LiveChatTranscript> closedChats;

    public List<LiveChatTranscript> getCreatedChats() {
        return createdChats;
    }
    
    public List<LiveChatTranscript> getClosedChats() {
        return closedChats;
    }
    
}