class ImportUsersJob < ApplicationJob
  # require 'csv'
  queue_as :default
  # include Sidekiq::Worker
  # sidekiq_options retry: false

  def perform(csv_file, _current_user)
    accessible_attributes = %w[first_name last_name id password email phone]
    CSV.foreach(csv_file, headers: true) do |row|
      user = User.find_by_id(row['id']) || User.new
      user.attributes = row.to_hash.slice(*accessible_attributes)
      user.save!
      user.add_role :user
      # User.create! row.to_hash
    end
  end
end
