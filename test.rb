require 'net/https'
require 'uri'
require 'json'

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
puts templateId