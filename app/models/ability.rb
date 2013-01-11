class Ability
  include CanCan::Ability

  def initialize(user)
    #handle guest users
    if (user.nil?)
      cannot :manage, :all
      return
    else
      can :manage, :all
      can :document_upload, :list
    end

  end
end