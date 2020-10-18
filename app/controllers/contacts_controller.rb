class ContactsController < ApplicationController
  
  #GET request to / contact-us
  #Show new contact form
  def new
    @contact = Contact.new
  end
  
  #POST request/contacts-us
  def create
    #Mass assignments of form field into contact objec
    @contact = Contact.new(contact_params)
    #the contact object to the database
    if @contact.save
      #Store the form fields via parameters into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      #Place variables into contact mailer
      #Email method and send email
      ContactMailer.contact_email(name,email,body).deliver
      #Store success message in flash hash
      #and redirect to the new action
      flash[:success] = "Message Saved"
      redirect_to new_contact_path
    else
      #If error store errors in flash has and redirect to new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  private 
    #To collect data for form we need to use strong parameters
    #Whitelist the form fields (required)
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end