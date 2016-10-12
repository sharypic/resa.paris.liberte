class DeviseMailerPreview < ActionMailer::Preview

  def confirmation_instructions
    DeviseMailer.confirmation_instructions(Resident.first, "faketoken", {})
  end

  def reset_password_instructions
    DeviseMailer.reset_password_instructions(Resident.first, "faketoken", {})
  end
end
