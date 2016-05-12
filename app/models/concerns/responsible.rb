module Responsible
  extend ActiveSupport::Concern

  included do
    belongs_to :author, class_name: 'User', foreign_key: :created_by
    belongs_to :updated_by, class_name: 'User', foreign_key: :last_updated_by
  end

  def creator
    author.try(:full_name, 'display') || 'Default'
  end

  def editor
    updated_by.try(:full_name, 'display') || 'Default'
  end


end