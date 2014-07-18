# encoding: UTF-8
class RatingMailer < ActionMailer::Base
  def self.default_url_options
    { host: Setting.host_name, protocol: Setting.protocol }
  end

  def must_rate( issue )
    @issue = issue
    
    mail from: Setting.mail_from, 
         to: @issue.author.mail, 
         subject: "#{@issue.subject}: ждет оценки"
  end
end
