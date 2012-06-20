require 'spec_helper'

describe UrlVpsa do

  describe "formatada" do
    
    it "adiciona a base a URL" do
      args = {
        :url => 'https://www.vpsa.com.br/rest/{base}/clientes',
        :base => 'baseteste', :entidades => '1,2,5', 
        :inicio => '0', :quantidade => '6', :quantidade_maxima => 10
      }
      UrlVpsa.new(args).formatada.start_with?('https://www.vpsa.com.br/rest/baseteste/clientes').should be_true
    end
    
    describe "filtro de entidade" do
      it "adiciona o filtro se informado" do
        args = {
          :url => 'https://www.vpsa.com.br/rest/{base}/clientes',
          :base => 'baseteste', :entidades => '1,2,5', 
          :inicio => '0', :quantidade => '6', :quantidade_maxima => 10
        }
        UrlVpsa.new(args).formatada.include?('entidades=1,2,5').should be_true
      end
      it "nao adiciona o filtro se nao foi informado" do
        args = {
          :url => 'https://www.vpsa.com.br/rest/{base}/clientes',
          :base => 'baseteste',
          :inicio => '0', :quantidade => '6', :quantidade_maxima => 10
        }
        UrlVpsa.new(args).formatada.include?('entidades').should be_false
      end
    end
    
    describe "filtro de inicio" do
      it "adiciona o filtro se informado" do
        args = {
          :url => 'https://www.vpsa.com.br/rest/{base}/clientes',
          :base => 'baseteste', :entidades => '1,2,5', 
          :inicio => '23', :quantidade => '6', :quantidade_maxima => 10
        }
        UrlVpsa.new(args).formatada.include?('inicio=23').should be_true
      end
      it "adiciona o filtro com valor padrao se nao foi informado" do
        args = {
          :url => 'https://www.vpsa.com.br/rest/{base}/clientes',
          :base => 'baseteste', :entidades => '1,2,5', 
          :quantidade => '6', :quantidade_maxima => 10
        }
        UrlVpsa.new(args).formatada.include?('inicio=0').should be_true
      end
    end
    
    describe "filtro de quantidade" do
      it "adiciona o filtro se informado" do
        args = {
          :url => 'https://www.vpsa.com.br/rest/{base}/clientes',
          :base => 'baseteste', :entidades => '1,2,5', 
          :inicio => '23', :quantidade => '6', :quantidade_maxima => 10
        }
        UrlVpsa.new(args).formatada.include?('quantidade=6').should be_true
      end
      it "adiciona o filtro com valor maximo se nao foi informado" do
        args = {
          :url => 'https://www.vpsa.com.br/rest/{base}/clientes',
          :base => 'baseteste', :entidades => '1,2,5', 
          :inicio => '23', :quantidade_maxima => 12
        }
        UrlVpsa.new(args).formatada.include?('quantidade=12').should be_true
      end
      it "adiciona o filtro com valor maximo se o informado nao for um inteiro" do
        args = {
          :url => 'https://www.vpsa.com.br/rest/{base}/clientes',
          :base => 'baseteste', :entidades => '1,2,5', 
          :inicio => '23', :quantidade => 'isso_nao_eh_um_numero', :quantidade_maxima => 12
        }
        UrlVpsa.new(args).formatada.include?('quantidade=isso_nao_eh_um_numero').should be_false
        UrlVpsa.new(args).formatada.include?('quantidade=12').should be_true
      end
      it "troca o filtro pelo valor maximo se o informado for maior" do
        args = {
          :url => 'https://www.vpsa.com.br/rest/{base}/clientes',
          :base => 'baseteste', :entidades => '1,2,5', 
          :inicio => '23', :quantidade => '13', :quantidade_maxima => 12
        }
        UrlVpsa.new(args).formatada.include?('quantidade=12').should be_true
      end
      it "troca o filtro pelo valor maximo se o informado for negativo" do
        args = {
          :url => 'https://www.vpsa.com.br/rest/{base}/clientes',
          :base => 'baseteste', :entidades => '1,2,5', 
          :inicio => '23', :quantidade => '-1', :quantidade_maxima => 12
        }
        UrlVpsa.new(args).formatada.include?('quantidade=12').should be_true
      end
    end
    
  end

end
