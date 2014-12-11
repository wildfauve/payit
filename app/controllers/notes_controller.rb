class NotesController < ApplicationController
  
  def index
    #@notes = Note.new(user_proxy: @current_user_proxy).find_all
    @note = Note.new(user_proxy: @current_user_proxy).create_note
  end
  
end