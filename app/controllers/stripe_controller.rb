class StripeController < ApplicationController
  def connect
    # Stripe brings the user back with an authorization code in the URL
    code = params[:code]

    # To finish the OAuth flow, we exchange this code for an access token and stripe user id
    response = HTTParty.post("https://connect.stripe.com/oauth/token", 
      :query => { 
        client_secret: ENV.fetch('STRIPE_CLIENT_SECRET'), 
        code: code, 
        grant_type: "authorization_code"
      }
    )

    if response.parsed_response.key?("error")
      # Something went wrong. E.g. the code expired
      redirect_to users_show_url, notice: response.parsed_response["error_description"]
    else
      # Success! :party_parrot:
      @mentor = Mentor.find_by(user_id: current_user.id)
      @mentor.stripe_user_id = response.parsed_response["stripe_user_id"]
      @mentor.save
      redirect_to users_show_url, notice: 'Successfully connected with Stripe!'
    end
  end
end