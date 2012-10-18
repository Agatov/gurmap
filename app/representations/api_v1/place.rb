module ApiV1::Place
  extend ActiveSupport::Concern
  included do

    api_accessible :list do |template|
      template.add :id
      template.add :name
      template.add :address
      template.add :longitude
      template.add :latitude
      template.add :avatar_preview
      template.add :min_sale
      template.add :max_sale
      template.add :average_check
    end

  end
end