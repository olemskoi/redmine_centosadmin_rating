namespace :centos_rating do
  task must_rate: :environment do
    settings = Setting.plugin_redmine_centosadmin_rating

    if settings['must_rate']
      Project.all.each do |project|
        if project.enabled_modules.pluck(:name).include?('centosadmin_rating')
          project.issues.includes(:status).where( 'issue_statuses.name' => settings['must_status'], 'must_rate_sended' => false ).each do |issue|
            if issue.ratings.where(evaluator_id: issue.author_id).count == 0 &&
              issue.author.allowed_to?(:centos_rate, issue.project) &&
              (Time.now - issue.updated_on).to_i / 1.day >= settings['must_day'].to_i
              puts '111'
              RatingMailer.must_rate(issue).deliver
              issue.update_attributes! must_rate_sended: true
            end
          end
        end
      end
    end
  end
end
