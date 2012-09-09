require 'net/https'
require 'uri'
require 'json'

class PetitionsController < ApplicationController
  # GET /petitions
  # GET /petitions.json
  def index
    @petitions = Petition.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @petitions, callback: params[:callback] }
    end
  end

  # GET /petitions/1
  # GET /petitions/1.json
  def show
    @petition = Petition.find(params[:id])

    puts "PDF Link url = "
    @petition.pdf_link =  view_document(create_envelope(get_template))
    
    puts @petition.pdf_link

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @petition }
    end
  end

  # GET /petitions/new
  # GET /petitions/new.json
  def new
    @petition = Petition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @petition }
    end
  end

  # GET /petitions/1/edit
  def edit
    @petition = Petition.find(params[:id])
  end

  # POST /petitions
  # POST /petitions.json
  def create
    @petition = Petition.new(params[:petition])

    respond_to do |format|
      if @petition.save
        format.html { redirect_to @petition, notice: 'Petition was successfully created.' }
        format.json { render json: @petition, status: :created, location: @petition }
      else
        format.html { render action: "new" }
        format.json { render json: @petition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /petitions/1
  # PUT /petitions/1.json
  def update
    @petition = Petition.find(params[:id])

    respond_to do |format|
      if @petition.update_attributes(params[:petition])
        format.html { redirect_to @petition, notice: 'Petition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @petition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /petitions/1
  # DELETE /petitions/1.json
  def destroy
    @petition = Petition.find(params[:id])
    @petition.destroy

    respond_to do |format|
      format.html { redirect_to petitions_url }
      format.json { head :no_content }
    end
  end

  def get_template
    docusign_authentication_headers = {
            "X-DocuSign-Authentication" => "" \
              "<DocuSignCredentials>" \
                "<Username>rhuff.9999@gmail.com</Username>" \
                "<Password>Deskpro0docusign</Password>" \
                "<IntegratorKey>NAXX-b2095226-449e-4c21-9f8b-5c3ca4287c07</IntegratorKey>" \
              "</DocuSignCredentials>"
    }

    accept_headers = {"Accept" => "application/json"}
    #puts docusign_authentication_headers
    #puts accept_headers
    #puts docusign_authentication_headers.merge(accept_headers)
    headers = docusign_authentication_headers.merge(accept_headers)

    uri = URI.parse("https://demo.docusign.net/restapi/v2/accounts/203548/templates")
    request = Net::HTTP::Get.new(uri.request_uri, headers)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(request).body 
    #puts response

    hashed_response = JSON.parse(response)
    templates = hashed_response['envelopeTemplates']
    templateId = templates[0]['templateId']

    puts "****************"
    templateId
  end

def create_envelope(templateId)
  puts "~~~~~~~~~~~~ "
  puts templateId

    docusign_authentication_headers = {
            "X-DocuSign-Authentication" => "" \
              "<DocuSignCredentials>" \
                "<Username>rhuff.9999@gmail.com</Username>" \
                "<Password>Deskpro0docusign</Password>" \
                "<IntegratorKey>NAXX-b2095226-449e-4c21-9f8b-5c3ca4287c07</IntegratorKey>" \
              "</DocuSignCredentials>"
    }

    content_type_header = {"content-type" => "application/json"}
    accept_headers = {"Accept" => "application/json"}
    #puts docusign_authentication_headers
    #puts accept_headers
    #puts docusign_authentication_headers.merge(accept_headers)
    headers = docusign_authentication_headers.merge(accept_headers).merge(content_type_header)

    blurb = "Blurb"
    subject = "Subject"
    email = "james.hwang.usc@gmail.com"
    name = "James Hwang"
    roleName = "RoleOne"
    clientUserId = "1"
    status = "sent"


    post_body = "{
        \"emailBlurb\"   : \"" + blurb + "\",
        \"emailSubject\" : \"" + subject + "\",
        \"templateId\"    : \"" + templateId + "\",
        \"customFields\"  : {
          \"textCustomFields\" : [{
            \"name\" : \"lastName\",
            \"show\" : \"true\",
            \"required\" : \"true\",
            \"value\" : \"Smith\"
          }]
        },
        \"templateRoles\"   : [ {
          \"email\" : \"" + email + "\",
          \"name\" :  \"" + name + "\",
          \"roleName\" :  \"" + roleName + "\",
          \"clientUserId\" :  \"" + clientUserId + "\"}],
        \"status\" : \"" + status + "\"
      }"

    uri = URI.parse("https://demo.docusign.net/restapi/v2/accounts/203548/envelopes")
    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = post_body
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(request).body 
    puts response

    hashed_response = JSON.parse(response)
    envelope_id = hashed_response['envelopeId']

    envelope_id
  end

def view_document(envelopeId)
  puts "~~~~~~~~~~~~ "
  puts envelopeId

    docusign_authentication_headers = {
            "X-DocuSign-Authentication" => "" \
              "<DocuSignCredentials>" \
                "<Username>rhuff.9999@gmail.com</Username>" \
                "<Password>Deskpro0docusign</Password>" \
                "<IntegratorKey>NAXX-b2095226-449e-4c21-9f8b-5c3ca4287c07</IntegratorKey>" \
              "</DocuSignCredentials>"
    }

    content_type_header = {"content-type" => "application/json"}
    accept_headers = {"Accept" => "application/json"}
    #puts docusign_authentication_headers
    #puts accept_headers
    #puts docusign_authentication_headers.merge(accept_headers)
    headers = docusign_authentication_headers.merge(accept_headers).merge(content_type_header)

    blurb = "Blurb"
    subject = "Subject"
    email = "james.hwang.usc@gmail.com"
    name = "Name"
    roleName = "RoleOne"
    clientUserId = "1"
    status = "sent"

    post_body = "{
        \"authenticationMethod\"   : \"None\",
        \"email\" : \"james.hwang.usc@gmail.com\",
        \"returnUrl\" : \"http://easypetition.herokuapp.com/close.html\",
        \"userName\" : \"James Hwang\",
        \"clientUserId\" : \"1\"
      }"

    uri = URI.parse("https://demo.docusign.net/restapi/v2/accounts/203548/envelopes/" + envelopeId + "/views/recipient")
    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = post_body
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(request).body 

    hashed_response = JSON.parse(response)
    document_url = hashed_response['url']

    document_url

#    templates = hashed_response[0]['envelopeId']

  end
end
