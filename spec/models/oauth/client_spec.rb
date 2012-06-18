require 'spec_helper'

describe Client do
  before  { @client = Factory.create(:client) }
  subject { @client }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:uri) }
  it { should allow_value(VALID_URIS).for(:uri) }
  it { should validate_presence_of(:created_from) }
  it { should allow_value(VALID_URIS).for(:created_from) }
  it { should validate_presence_of(:redirect_uri) }
  it { should allow_value(VALID_URIS).for(:redirect_uri) }

  its(:secret) { should_not be_nil }

  it ".granted!" do
    lambda{ subject.granted! }.should change{ subject.granted_times }.by(1)
  end

  it ".revoked!" do
    lambda{ subject.revoked! }.should change{ subject.revoked_times }.by(1)
  end

  it { should_not be_blocked }
  context "#block!" do
    before { @authorization         = Factory.create(:oauth_authorization) }
    before { @another_authorization = Factory.create(:oauth_authorization, client_uri: ANOTHER_CLIENT_URI) }
    before { @token                 = Factory.create(:oauth_token) }
    before { @another_token         = Factory.create(:oauth_token, client_uri: ANOTHER_CLIENT_URI) }

    before { subject.block! }

    it { should be_blocked }
    it { @authorization.reload.should be_blocked }
    it { @another_authorization.reload.should_not be_blocked }
    it { @token.reload.should be_blocked }
    it { @another_token.reload.should_not be_blocked }

    context "#unblock!" do
      before { subject.unblock! }

      it { should_not be_blocked }
      it { @authorization.reload.should be_blocked }
      it { @token.reload.should be_blocked }
    end
  end

  context ".find_by_id" do
    context "without scope" do
      let(:found) { Client.where_uri(subject.uri, subject.redirect_uri).first }
      it { found.should_not be_nil }
    end

    context "with valid scope" do
      let(:found) { Client.where_scope(subject.scope_values).where_uri(subject.uri, subject.redirect_uri).first }
      it { found.should_not be_nil }
    end

    # TODO: Understand why with subject it raise error
    context "with not valid scope" do
      let(:found) { Client.where_scope(["not.valid"]).where_uri(subject.uri, subject.redirect_uri).first }
      it { found.should be_nil }
    end
  end

  context ".find_by_secret" do
    let(:found) { Client.where_secret(subject.secret, subject.uri).first }
    it { found.should_not be_nil }
  end

  context ".where_scope" do
    context "with complete scope" do
      let(:scope) { ALL_SCOPE }
      subject { Client.where_scope(scope).first }
      it { should_not be_nil }
    end

    context "with partial scope" do
      let(:scope) { ["entidades/show", "entidades/create"] }
      subject { Client.where_scope(scope).first }
      it { should_not be_nil }
    end

    context "with invalid scope" do
      let(:scope) { ["type.write", "reresource.not_existingg"] }
      subject { Client.where_scope(scope).first }
      it { should be_nil }
    end
  end

  context "#destroy" do
    subject { Factory.create(:client) }
    before do
      OauthAuthorization.destroy_all
      3.times { Factory.create(:oauth_authorization) }
      OauthToken.destroy_all
      3.times { Factory.create(:oauth_token) }
    end

    it "should remove related authorizations" do
      lambda{ subject.destroy }.should change{
        OauthAuthorization.all.size
      }.by(-3)
    end

    it "should remove related tokens" do
      lambda{ subject.destroy }.should change{
        OauthToken.all.size
      }.by(-3)
    end
  end

  context ".sync_clients_with_scope" do
    before { Client.destroy_all }
    before { Scope.destroy_all }

    before { @client = Factory(:client) }
    before { @read_client = Factory(:client_read) }
    before { @scope = Factory(:scope_entidades_all) }
    before { @scope_read = Factory(:scope_entidades_read, values: ["entidades/show"]) }
    before { Client.sync_clients_with_scope("entidades/read") }

    context "with indirect scope" do
      subject { @client.reload.scope_values }
      it { should include "entidades/show" }
      it { should include "entidades/create" }
      it { should include "entidades/update" }
      it { should include "entidades/destroy" }
      it { should_not include "entidades/index" }
    end

    context "with direct scope" do
      subject { @read_client.reload.scope_values }
      it { should include "entidades/show" }
      it { should_not include "entidades/index" }
    end
  end

end

