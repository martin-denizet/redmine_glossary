class Term < ActiveRecord::Base

  unloadable

  belongs_to :category, class_name: 'TermCategory', foreign_key: 'category_id'
  belongs_to :project
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates_presence_of :name, :project
  validates_length_of :name, maximum: 255

  acts_as_attachable view_permission: :view_terms,
                     edit_permission: :manage_terms,
                     delete_permission: :manage_terms

  acts_as_searchable columns: ["#{table_name}.name",
                               "#{table_name}.description"],
                     preload: [:project]

  acts_as_event title: proc { |o| "#{l(:glossary_title)} ##{o.id}: #{o.name}" },
                description: :description,
                datetime: :created_on,
                type: 'terms',
                url: proc { |o|
                  { controller: 'glossary',
                    action: 'show',
                    project_id: o.project,
                    id: o.id }
                }

  attr_accessible :project_id, :category_id, :author,
                  :name, :name_en, :datatype, :codename, :description,
                  :rubi, :abbr_whole

  scope :visible, lambda { |*args|
    user = args.shift || User.current
    joins(:project)
      .where(Project.allowed_to_condition(user, :view_terms, *args))
  }

  def author
    author_id ? User.find_by_id(author_id) : nil
  end

  def updater
    updater_id ? User.find_by_id(updater_id) : nil
  end

  def project
    Project.find_by_id(project_id)
  end

  def datetime
    self[:created_on] != self[:updated_on] ? self[:updated_on] : self[:created_on]
  end

  def value(prmname)
    case prmname
    when 'project'
      project ? project.name : ''
    when 'category'
      category ? category : ''
    when 'datetime'
      datetime
    else
      self[prmname]
    end
  end

  def param_to_s(prmname)
    if (prmname == 'created_on') || (prmname == 'updated_on')
      format_time(self[prmname])
    else
      value(prmname).to_s
    end
  end

  def <=>(term)
    id <=> term.id
  end

  def self.compare_safe(a, b)
    if !a && !b
      return 0
    elsif !a || !b
      return -1 if a
      return 1 if b
    end
    yield(a, b)
  end

  def self.compare_by_param(prm, a, b)
    case prm
    when 'project'
      a.project.identifier <=> b.project.identifier
    when 'category'
      compare_safe(a.category, b.category) do |acat, bcat|
        acat.position <=> bcat.position
      end
    when 'datetime'
      compare_safe(a.value(prm), b.value(prm)) do |aval, bval|
        (aval <=> bval) * -1
      end
    when 'name'
      (a.rubi.empty? ? a.name : a.rubi) <=> (b.rubi.empty? ? b.name : b.rubi)
    else
      compare_safe(a.value(prm), b.value(prm)) do |aval, bval|
        aval <=> bval
      end
    end
  end

  def to_s
    "##{id}: #{name}"
  end

  def self.find_for_macro(tname, proj, all_project = false)
    if proj
      term = Term.find_by(project_id: proj.id, name: tname)
      return term		if term
    end
    return nil unless all_project
    find_by_name(tname)
  end

  def self.default_show_params
    %w[name_en rubi abbr_whole datatype codename project category]
  end

  def self.default_searched_params
    %w[name name_en abbr_whole datatype codename description]
  end

  def self.default_sort_params
    %w[id name name_en abbr_whole datatype codename project category
       datetime]
  end

  def self.hidable_params
    %w[name_en rubi abbr_whole datatype codename]
  end

  def self.setting_params
    %w[name_en rubi abbr_whole datatype codename]
  end

  def self.export_params
    %w[id project
       name name_en rubi abbr_whole category datatype codename
       author updater created_on updated_on
       description]
  end

  def self.import_params
    %w[name name_en rubi abbr_whole category datatype codename
       description]
  end
end
