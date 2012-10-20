module ApiV1::User
  extend ActiveSupport::Concern
  included do

    api_accessible :list do |template|
      template.add :id
      template.add :first_name
      template.add :last_name
      template.add :avatar_preview
    end

  end
end