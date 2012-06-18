require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "ResourceController" do

  context "with not existing access token" do
    before { @token = Factory(:oauth_access) }
    before { @token = Factory(:oauth_token) }
    before { @token_value = @token.token }
    before { @token_json  = {token: @token_value}.to_json }
    before { @token.destroy }

    scenario ".index" do
      visit "/api/entidades?token=" + @token_value
      should_not_be_authorized
    end

    scenario ".show" do
      visit "/api/entidades/0?token=" + @token_value
      should_not_be_authorized
    end
  end

  context "with single action accesses" do
    before { @token_value = Factory(:oauth_token, scope: ["entidades/index"]).token }
    before { @token_json  = {token: @token_value}.to_json }

    scenario ".index" do
      visit "/api/entidades?token=" + @token_value
      page.status_code.should eq(200)
      lambda{ JSON.parse(body) }.should_not raise_error
    end

    scenario ".show" do
      visit "/api/entidades/0?token=" + @token_value
      should_not_be_authorized
    end
  end


  context "with read accesses on a resource" do
    before { @token_value = Factory(:oauth_token_read).token }
    before { @token_json  = {token: @token_value}.to_json }

    scenario ".index" do
      visit "/api/entidades?token=" + @token_value
      page.status_code.should eq(200)
      lambda{ JSON.parse(body) }.should_not raise_error
    end

    scenario ".show" do
      visit "/api/entidades/1?token=" + @token_value
      page.status_code.should eq(200)
      lambda{ JSON.parse(body) }.should_not raise_error
    end
  end


  context "with all accesses" do
    before { @token_value = Factory(:oauth_token).token }
    before { @token_json  = {token: @token_value}.to_json }

    scenario ".index" do
      visit "/api/entidades?token=" + @token_value
      page.status_code.should eq(200)
      lambda{ JSON.parse(body) }.should_not raise_error
    end

    scenario ".show" do
      visit "/api/entidades/1?token=" + @token_value
      page.status_code.should eq(200)
      lambda{ JSON.parse(body) }.should_not raise_error
    end

    context "with token in the header" do
      before { @headers = Hash["Authorization", "OAuth2 #{@token_value}"] }
      before { page.driver.hacked_env.merge!(@headers) }

      scenario ".index" do
        visit "/api/entidades"
        page.status_code.should eq(200)
        lambda{ JSON.parse(body) }.should_not raise_error
      end
    end
  end

end
