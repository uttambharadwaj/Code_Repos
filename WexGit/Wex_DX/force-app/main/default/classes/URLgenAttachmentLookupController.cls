// To do
// - Filter by file size..
public class URLgenAttachmentLookupController {
    
    public String selectedFolder { get; set; }
    
    public String searchTerm { get; set; }
    
    public List<SelectOption> folders {
        get {
            List<Folder> folders = [SELECT Id, Name FROM Folder WHERE Type = 'Document' ORDER BY Name ASC];
            
            List<SelectOption> folderOptions = new List<SelectOption>();
            
            folderOptions.add(new SelectOption('#', 'My Documents'));
            
            for(Folder folder : folders) {
            	folderOptions.add(new SelectOption(folder.Id,folder.Name));
            }
            
            return folderOptions;
        }
    }
    
    public List<Document> documents { get; set; }
    
    public URLgenAttachmentLookupController() {
        
        selectedFolder = '#'; // start out on my documents
        
        displayDocuments();
        
    }
    
    public void clearSearch() {
		searchTerm = null;
        
        selectedFolder = '#';
        
        displayDocuments();
    }
    
    public void displayDocuments() {
        
        System.debug('*** FOLDER ' + selectedFolder);
        
        String whereQuery = '%';
        
        if(!String.isEmpty(searchTerm)) {
            whereQuery = '%' + searchTerm + '%';
        }

        if(selectedFolder.equalsIgnoreCase('#')) {
            	documents = [SELECT Id, Name, Description FROM Document WHERE (Name like :whereQuery or Description like :whereQuery) and AuthorId = :UserInfo.getUserId() and IsInternalUseOnly = false ORDER BY Name ASC];
        }
        else {
       		documents = [SELECT Id, Name, Description FROM Document WHERE (Name like :whereQuery or Description like :whereQuery) and FolderId = :selectedFolder and IsInternalUseOnly = false ORDER BY Name ASC];
        }
        
    }
    
}