class TermCategory < ActiveRecord::Base
  belongs_to :project
  has_many :terms, foreign_key: 'category_id', dependent: :nullify

  acts_as_list scope: :project_id

  attr_accessible :name, :project_id, :position

  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:project_id]

  alias destroy_without_reassign destroy

  # Destroy the category
  # If a category is specified, terms are reassigned to this category
  def destroy(reassign_to = nil)
    if reassign_to && reassign_to.is_a?(TermCategory) && reassign_to.project == project
      Term.update_all("category_id = #{reassign_to.id}", "category_id = #{id}")
    end
    destroy_without_reassign
  end

  def <=>(category)
    position <=> category.position
  end

  def to_s
    name
  end
end
