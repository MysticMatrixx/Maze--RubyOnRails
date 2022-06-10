# frozen_string_literal: true

class ImportFileWorker
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(row)
    User.import(row)
    # u = User.new
    # u.first_name = row['first_name']
    # u.last_name = row['last_name']
    # u.phone = row['phone']
    # u.email = row['email']
    # u.password = row['password']
    # binding.pry
    # u.skip_confirmation!
    # u.add_role if row['role'].present? ? row['role'] : 'user'
    # u.save!
    # user.create!
  end
end
