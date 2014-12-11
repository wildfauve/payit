class Note
  
  def initialize(user_proxy: nil)
    @user_proxy = user_proxy
    @client = EvernoteOAuth::Client.new(token: @user_proxy.access_token)
    @note_store = @client.note_store
    
  end

  def find_all
    client = EvernoteOAuth::Client.new(token: @user_proxy.access_token)
    note_store = client.note_store

    note_filter = Evernote::EDAM::NoteStore::NoteFilter.new
    notes = note_store.findNotes(note_filter, 0, 10)
    raise
  end
  
  def create_note
    note = Evernote::EDAM::Type::Note.new
    note.title = "Note"
    note.content = <<EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
    <en-note>Test Content</en-note>
EOF
    note.tagNames = ["Evernote API Sample"]
    begin      
      resp = @note_store.createNote(note)
    rescue Evernote::EDAM::Error::EDAMUserException => e
      raise
    end
  end
  
end