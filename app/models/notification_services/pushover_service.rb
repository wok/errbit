class NotificationServices::PushoverService < NotificationService
  Label = "pushover"
  Fields += [
      [:api_token, {
          :placeholder => "User Key",
          :label => "User Key"
      }],
      [:subdomain, {
          :placeholder => "Application API Token",
          :label => "Application API Token"
      }]
  ]

  def check_params
    if Fields.detect {|f| self[f[0]].blank? }
      errors.add :base, 'You must specify your User Key and Application API Token.'
    end
  end

  def url
    "https://pushover.net/login"
  end

  def create_notification(problem)
    # build the hoi client
    notification = Rushover::Client.new(subdomain)

    message = "#{problem.where}\n#{problem.message.to_s.truncate(200)}"

    options = {
      title: "#{problem.app_name}",
      priority: 0,
      url: "https://#{Errbit::Config.host}/apps/#{problem.app.id.to_s}",
      url_title: 'Show'
    }



    if problem.notices_count == 1 
      options[:sound] = 'none'
    else
      options[:title] += " (#{problem.notices_count})"
    end

    api_token.split( ',' ).each do |token|
      notification.notify( token, message, options )
    end
  end
end
