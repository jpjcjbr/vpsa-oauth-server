class UrlVpsa
  
  def initialize(args)
    @url = args[:url]
    @base = args[:base]
    @usuario = args[:usuario]
    @entidades = args[:entidades]
    @inicio = args[:inicio]
    @quantidade = args[:quantidade]
    @quantidade_maxima = args[:quantidade_maxima]
  end

  def formatada
    url = url_com_base
    url << filtro_usuario
    url << filtro_inicio
    url << filtro_quantidade
    url << filtro_entidades
  end

  private

	def url_com_base
	  @base ? @url.sub('{base}', @base) : @url
	end

	def filtro_usuario
	  @usuario ? '?idUsuarioLogado=' + @usuario.to_s : ''
	end

	def filtro_inicio
	  @inicio ||= '0'
	  return '&inicio=' + @inicio
	end
	
	def filtro_quantidade
	  @quantidade = @quantidade_maxima if !@quantidade || @quantidade.to_i > @quantidade_maxima || @quantidade.to_i <= 0
	  return '&quantidade=' + @quantidade.to_s
	end
	
	def filtro_entidades
	  @entidades ? '&entidades=' + @entidades : ''
	end
	
end