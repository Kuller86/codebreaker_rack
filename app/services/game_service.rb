class GameService

  class << self
    def head
      {
          "title" => "Codebreaker Web"
      }
    end
  end

  # @param [Rack::Request] request
  def init_game(request)
    unless game_start?(request.session)
      # request.session[:user] = CodebreakerAi::User.new(request[:player_name], request[:level])
      request.session[:player_name] = request[:player_name]
      request.session[:level] = request[:level]
      request.session[:game_start] = true
    end
    start_game(request.session)
  end

  # @param [Rack::Session::Pool] session
  def start_game(session)
    user = user(session)
    game = CodebreakerAi::Game.new(user)

    if session[:game_state].instance_of?(CodebreakerAi::GameState)
      game.restore_state(session[:game_state])
    elsif
      game.start
      session[:game_state] = game.create_state
    end
    session[:match] = {} if session[:match].nil?
    game
  end

  # @param [Rack::Request] request
  def submit_answer(request)
    game = start_game(request.session)
    request.session[:match] = game.match(request[:number])
    request.session[:game_state] = game.create_state
    add_to_history(request.session, request[:number], request.session[:match])
  end

  def add_to_history(session, number, match)
    session[:history] = [] if session[:history].nil?
    session[:history] << {'number' => number, 'match' => match}
  end

  # @param [Rack::Request] request
  def hint(request)
    game = start_game(request.session)
    game.hint
    request.session[:game_state] = game.create_state
  end

  # @param [Rack::Session::Pool] session
  def game_start?(session)
    session[:game_start]
  end

  def home
    variables = {
        :title => I18n.t(:"menu.title"),
        :short_rules => I18n.t(:"menu.short_rules"),
        :level_label => I18n.t(:"menu.level_label"),
        :player_name_label => I18n.t(:"menu.player_name_label"),
        :levels => [
            {
                :name => I18n.t(:"menu.levels.empty"),
                :value => ''
            },
            {
                :name => I18n.t(:"menu.levels.easy"),
                :value => 'easy'
            },
            {
                :name => I18n.t(:"menu.levels.medium"),
                :value => 'medium'
            },
            {
                :name => I18n.t(:"menu.levels.hard"),
                :value => 'hell'
            }
        ],
        :start_game_button => I18n.t(:"buttons.start_game"),
        :rules_button => I18n.t(:"buttons.rules"),
        :statistics_button => I18n.t(:"buttons.statistics"),
    }
  end

  # @param [Rack::Request] request
  def game(request)
    game = start_game(request.session)
    secret_number = request.session[:game_state] ? request.session[:game_state].secret_number : 'no secret'
    variables = {
        'title' => I18n.t(:"menu.title"),
        'secret_number' => secret_number,
        'history' => history(request.session[:history]),
        'short_rules' => I18n.t(:"menu.short_rules"),
        'level_label' => I18n.t(:"game.level"),
        'level' => I18n.t(:"menu.levels.#{request.session[:level]}"),
        'attempts_label' => I18n.t(:"game.attempts"),
        'attempts' => game.attempts_count,
        'hints_label' => I18n.t(:"game.hints"),
        'hints' => game.hints_count,
        'markers' => markers(request.session[:match]),
        'submit_button' => I18n.t(:"buttons.submit"),
        'show_hint_label' => I18n.t(:"game.show_hint"),
        'show_hint' => game.show_hints
    }
  end

  # @param [Rack::Request] request
  def win(request)
    game = start_game(request.session)
    # @type [CodebreakerAi::User] user
    user = request.session[:user]
    variables = {
        'title' => I18n.t(:"menu.title"),
        'level_label' => I18n.t(:"game.level"),
        'level' => I18n.t(:"menu.levels.easy"),
        'attempts_label' => I18n.t(:"win.attempts"),
        'attempts' => game.attempts_left,
        'hints_label' => I18n.t(:"win.hints"),
        'hints' => game.hints_left,
        'congratulations_message'=> I18n.t(:"win.congratulations_message", player_name: user.name),
        'alt_congratulations_image'=> I18n.t(:"win.alt_congratulations_image"),
        'play_again_button' => I18n.t(:"buttons.play_again"),
        'statistics_button' => I18n.t(:"buttons.statistics")
    }

    reset_game(request.session)
    variables
  end

  # @param [Rack::Request] request
  def lose(request)
    game = start_game(request.session)
    # @type [CodebreakerAi::User] user
    user = request.session[:user]
    variables = {
        'title' => I18n.t(:"menu.title"),
        'level_label' => I18n.t(:"game.level"),
        'level' => I18n.t(:"menu.levels.easy"),
        'attempts_label' => I18n.t(:"win.attempts"),
        'attempts' => game.attempts_left,
        'hints_label' => I18n.t(:"win.hints"),
        'hints' => game.hints_left,
        'lose_message' => I18n.t(:"lose.lose_message", player_name: user.name),
        'code_message' => I18n.t(:"lose.code_message"),
        'code_value'=> '1567',
        'alt_lose_image'=> I18n.t(:"lose.alt_lose_image"),
        'play_again_button' => I18n.t(:"buttons.play_again"),
        'statistics_button' => I18n.t(:"buttons.statistics")
    }
    reset_game(request.session)
    variables
  end

  def statistics
    variables = {
        'title' => I18n.t(:"menu.title"),
        'home_button' => I18n.t(:"buttons.home"),
        'table_headers' => {
            'no' => I18n.t(:"statistics.table.headers.number"),
            'name' => I18n.t(:"statistics.table.headers.name"),
            'level' => I18n.t(:"statistics.table.headers.level"),
            'attempts_left' => I18n.t(:"statistics.table.headers.attempts_left"),
            'hints_left' => I18n.t(:"statistics.table.headers.hints_left"),
            'date' => I18n.t(:"statistics.table.headers.date"),
        },
        'table_rows' => [
          [
            'Player 1',
            'Middle',
            '8/10',
            '3/3',
            '2018.12.04 - 17:00:01'
          ],
          [
              'Player 2',
              'Easy',
              '8/15',
              '3/3',
              '2018.12.04 - 17:02:01'
          ],
          [
              'Player 3',
              'Easy',
              '2/15',
              '0/3',
              '2018.12.04 - 19:02:01'
          ]
        ],
    }
  end

  private

  # @param [Rack::Session::Pool] session
  def reset_game(session)
    # session.delete(:user)
    # session.delete(:player_name)
    # session.delete(:level)
    # session.delete(:history)
    # session.delete(:match)
    # session.delete(:game_state)
    # session.delete(:game_start)
    session.clear
  end

  # @param [Rack::Session::Pool] session
  def user(session)
    raise CodebreakerRack::UserNotRegisteredException, I18n.t(:'user_not_registered') unless session[:player_name] || session[:level]
    if session[:user].nil?
      session[:user] = CodebreakerAi::User.new(session[:player_name], session[:level])
    end
    session[:user]
  end

  def markers(match)
    markers = []
    match[:strict_matches]&.times { |item| markers << '+'}
    match[:non_strict_matches]&.times { |item| markers << '-'}
    markers
  end

  def history(data)
    history_data = []
    data&.each do |item|
      history = {}
      item.each do |key, value|
        if key == 'match'
          history[key.to_sym] = markers(value)
          next
        end
        history[key.to_sym] = value
      end
      history_data << history
    end
    history_data
  end
end
