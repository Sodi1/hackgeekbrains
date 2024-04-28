RailsAdmin.config do |config|
  config.asset_source = :sprockets
  class RailsAdmin::Config::Fields::Types::Vector < RailsAdmin::Config::Fields::Base
    RailsAdmin::Config::Fields::Types.register(self)
  end
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    config.model 'AnswerQuestion' do
      list do
        field :answer
        field :question
        field :category
        field :answer_class
      end
      show do
        field :answer
        field :question
        field :category
        field :answer_class
      end
      edit do
        field :answer
        field :question
        field :category
        field :answer_class
      end
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
