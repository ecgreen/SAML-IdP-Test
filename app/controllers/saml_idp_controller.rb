require 'rest-client'
require 'repost'
include SamlIdp

class SamlIdpController < SamlIdp::IdpController

	def new
		puts "in new"
		render :template => "saml_idp/idp/new"
	end

	def create
		puts "in create"
		unless params[:email].blank? && params[:password].blank?
        	person = idp_authenticate(params[:email], params[:password])
			if person.nil?
				@saml_idp_fail_msg = "Incorrect email or password."
			else
				puts "in create else"
				@saml_response = idp_make_saml_response(person)

				puts saml_acs_url
				return redirect_post(saml_acs_url, params: { SAMLResponse: @saml_response })
				# puts response_url
				# return redirect_to response_url

        	end
      	end
    	render :template => "saml_idp/idp/new"
	end

	def idp_authenticate(email, password)
		{ email: email }
	end

	def idp_make_saml_response(user)
		encode_SAMLResponse(user[:email])
	end
end