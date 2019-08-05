class DefaultController < BaseController
  # @param [Rack::Request] request
  def initialize(request)
    super(request)
  end

  def index
    game_service = GameService.new
    if @request.post?
      game_service.init_game(@request)
      game_service.start_game(@request)
    end
    return redirect_to('game') if game_service.game_start?(@session)

    response(body: render('index.html.haml', game_service.home), status: 200, header: {})
  end

  def submit_answer
    return not_found unless @request.post?
    game_service = GameService.new
    begin
      game_service.submit_answer(@request)
    rescue CodebreakerAi::WinException
      return redirect_to('win')
    rescue CodebreakerAi::LoseException
      return redirect_to('lose')
    end

    redirect_to('game')
  end

  def hint
    return not_found unless @request.get?
    game_service = GameService.new
    begin
      game_service.hint(@request)
    rescue CodebreakerAi::HintException
      return redirect_to('game1')
    end
    redirect_to('game')
  end

  def game
    game_service = GameService.new
    begin
      game = game_service.game(@request)
    rescue CodebreakerRack::UserNotRegisteredException
      return redirect_to('home')
    end
    response(body: render('game.html.haml', game), status: 200, header: {})
  end

  def win
    game_service = GameService.new
    response(body: render('win.html.haml', game_service.win(@request)), status: 200, header: {})
  end

  def lose
    game_service = GameService.new
    response(body: render('lose.html.haml', game_service.lose(@request)), status: 200, header: {})
  end

  def statistics
    game_service = GameService.new
    response(body: render('statistics.html.haml', game_service.statistics), status: 200, header: {})
  end
end