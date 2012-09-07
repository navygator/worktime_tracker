class WorkItem < ActiveRecord::Base
  attr_accessible :description, :end_at, :start_at, :type_id, :user_id, :workflow_state

  include Workflow

  workflow do
    state :new do
      event :submit, :transitions_to => :submitted
    end
    state :submitted do
      event :confirm, :transitions_to => :confirmed
      event :decline, :transitions_to => :new
    end
    state :confirmed do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :submitted
    end
    state :accepted
    end
end
