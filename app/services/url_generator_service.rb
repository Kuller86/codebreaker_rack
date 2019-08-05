class UrlGeneratorService
  class << self
    def generate_url(name)
      case name
        when 'home' then '/'
        when 'game' then '/game'
        when 'submit_answer' then '/submit_answer'
        when 'hint' then '/hint'
        when 'rules' then '/rules'
        when 'statistics' then '/statistics'
        when 'win' then '/win'
        when 'lose' then '/lose'
        else raise UrlNotFoundException, I18n.t(:"url_not_found_by_name")
      end
    end
  end
end