class Router

  def self.route(request)
    controller = DefaultController.new(request)
    case request.path
      when '/' then controller.index
      when '/game' then controller.game
      when '/submit_answer' then controller.submit_answer
      when '/hint' then controller.hint
      when '/win' then controller.win
      when '/lose' then controller.lose
      when '/statistics' then controller.statistics
      else controller.not_found
    end
  end
end