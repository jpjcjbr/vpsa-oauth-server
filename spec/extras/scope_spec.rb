require 'spec_helper'

describe "Oauth" do
  before { Scope.destroy_all }

  before { @scope = Factory(:scope_entidades_read) }
  before { @scope = Factory(:scope_entidades_all) }
  before { @scope = Factory(:scope_pastas_read) }
  before { @scope = Factory(:scope_pastas_all) }
  before { @scope = Factory(:scope_read) }
  before { @scope = Factory(:scope_all) }

  context "#normalize_scope" do
    context "single resource" do 
      context "single action" do
        let(:normalized) { Oauth.normalize_scope("entidades/index") }
        subject { normalized }
        it { should include "entidades/index" } 
      end

      context "read actions" do
        let(:normalized) { Oauth.normalize_scope("entidades/read") }
        subject { normalized }

        it { should include "entidades/index" }
        it { should include "entidades/show" }
        it { should_not include "entidades/create"}
      end

      context "read actions and create action" do
        let(:normalized) { Oauth.normalize_scope("entidades/read entidades/create") }
        subject { normalized }
  
        it { should include "entidades/index" }
        it { should include "entidades/show" }
        it { should include "entidades/create"}
      end

      context "all rest actions" do
        let(:normalized) { Oauth.normalize_scope("entidades") }
        subject { normalized }

        it { should include "entidades/index" }
        it { should include "entidades/show" } 
        it { should include "entidades/create" }
        it { should include "entidades/update" }
        it { should include "entidades/destroy"}
        it { should_not include "pastas/index" }
        it { should_not include "entidades" }
      end
    end

    context "all resources" do
      context "single actions" do
        let(:normalized) { Oauth.normalize_scope("entidades/index pastas/index") }
        subject { normalized }
        it { should include "entidades/index" }
        it { should_not include "entidades/show" }
        it { should include "pastas/index" }
        it { should_not include "pastas/show" }
      end
      
      context "read actions" do
        let(:normalized) { Oauth.normalize_scope("read") }
        subject { normalized }

        it { should include "entidades/index" }
        it { should include "entidades/show" }
        it { should_not include "entidades/create"}

        it { should include "pastas/index" }
        it { should include "pastas/show" }
        it { should_not include "pastas/create"}     

        it { should_not include "read" }
        it { should_not include "entidades/read" }
        it { should_not include "pastas/read" }
      end

      context "all rest actions" do
        let(:normalized) { Oauth.normalize_scope("all") }
        subject { normalized }

        it { should include "entidades/index" }
        it { should include "entidades/show" } 
        it { should include "entidades/create" }
        it { should include "entidades/update" }
        it { should include "entidades/destroy"}

        it { should include "pastas/index" }
        it { should include "pastas/show" } 
        it { should include "pastas/create" }
        it { should include "pastas/update" }
        it { should include "pastas/destroy"}

        it { should_not include "all"}
        it { should_not include "entidades"}
        it { should_not include "pastas"}
        it { should_not include "entidades/read"}
        it { should_not include "pastas/read"}
      end
    end

  end
end
