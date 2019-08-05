class BaseController
  def not_found
    variables = {:page_not_found => I18n.t(:"page_not_found"), :home_button => I18n.t(:"buttons.home")}
    response(body: render('404.html.haml', variables), status: 404, header: {})
  end

  def render(template, variables)
    # return options.inspect
    # pry
    view_path = template.match?(/^_/) ? 'partials/' + template : template

    path = File.expand_path("../../views/#{view_path}", __FILE__)

    Haml::Engine.new(File.read(path)).render(binding, variables)
    # Haml::Engine.new(File.read(path)).render(binding)
  end

  protected

  # @param [Rack::Request] request
  def initialize(request)
    # @type [Rack::Request] @request
    @request = request
    # @type [Rack::Session::Pool] @session
    @session = request.session
  end

  def response(body:, status:, header:)
    Rack::Response.new(body, status, header)
  end

  # @return [Rack::Response]
  def redirect_to(name)
    response = Rack::Response.new
    response.redirect(UrlGeneratorService.generate_url(name))
    response
  end
end