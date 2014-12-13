class Note
  
  def initialize(user_proxy: nil)
    @user_proxy = user_proxy
    @client ||= EvernoteOAuth::Client.new(token: @user_proxy.access_token)
    @note_store ||= @client.note_store
  end

  def find_all
    note_filter = Evernote::EDAM::NoteStore::NoteFilter.new
    note_filter.tagGuids = ["PayIt"]
    spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec()
    notes = note_store.findNotesMetadata(@user_proxy.access_token, note_filter, 0, 10, spec)
    raise
  end
  
  def create_note(payment: nil, parent_notebook: nil)
    note = Evernote::EDAM::Type::Note.new
    
    note.title = payment.title
    
    now_time = Time.now.to_i * 1000
    then_time = (Time.parse(payment.reminder.to_s) + 9.hours).to_i * 1000
    #then_time = now_time + 3600000 # one hour after `now`
 
    # init NoteAttributes instance
    note.attributes = Evernote::EDAM::Type::NoteAttributes.new
    note.attributes.reminderOrder = now_time
    note.attributes.reminderTime = then_time
    
    n_body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    n_body += "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"
    n_body += "<en-note>#{payment.note}</en-note>"
    note.content = n_body
    note.tagNames = ["PayIt", "reminder"]
    if parent_notebook && parent_notebook.guid
      note.notebookGuid = parent_notebook.guid
    end
    begin
        evernote = @note_store.createNote(note)
      rescue Evernote::EDAM::Error::EDAMUserException => edue
        ## Something was wrong with the note data
        ## See EDAMErrorCode enumeration for error code explanation
        ## http://dev.evernote.com/documentation/reference/Errors.html#Enum_EDAMErrorCode
        raise
        puts "EDAMUserException: #{edue}"
      rescue Evernote::EDAM::Error::EDAMNotFoundException => ednfe
        ## Parent Notebook GUID doesn't correspond to an actual notebook
        puts "EDAMNotFoundException: Invalid parent notebook GUID"
      end
 
      ## Return created note object
      evernote
   end
  
end