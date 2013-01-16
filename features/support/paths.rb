module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

      when /the home\s?page/
        '/'

      when /gas totals/
        'gas_summary'

      when /gas totals/
        'gas_summary'

      when /the Annual Report/
        'annual_reports'

      when /source manager/
        'source_manager'

      when /gas readings/
        'gas_readings'

      when /upload gas file/
        'gas_uploads'

      when /upload electricity file/
        'electricity_uploads'

      when /electricity readings/
        'electricity_readings'

      when /upload documents/
        'document_uploads'

      when /gas comparison page/
        'gas_detail'

      when /electricity comparison page/
        'electricity_detail'

      when /conversion factor/
        'conversion_factors'

      when /the footprint report/
        'footprint_report_page'

      when /login/
        'login'

      when /edit bad gas reading/
        '/gas_readings/edit/1'

      when /app config/
        "#{edit_app_config_path AppConfig.first}"

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))

      else
        begin
          page_name =~ /the (.*) page/
          path_components = $1.split(/\s+/)
          self.send(path_components.push('path').join('_').to_sym)
        rescue Object => e
          raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                    "Now, go and add a mapping in #{__FILE__}"
        end
    end
  end
end

World(NavigationHelpers)
