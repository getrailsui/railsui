class DeviseMailerPreview < ActionMailer::Preview
  # Requires enablement on app/models/user.rb

  # def confirmation_instructions
  #   Devise::Mailer.confirmation_instructions(User.first, "faketoken")
  # end

  # Requires enablement on app/models/user.rb

  # def unlock_instructions
   # Devise::Mailer.unlock_instructions(User.first, "faketoken")
  #end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, "faketoken")
  end

  def email_changed
    Devise::Mailer.email_changed(User.first)
  end

  def password_changed
    Devise::Mailer.password_change(User.first)
  end
end
