class GlossaryStyle < ActiveRecord::Base
  unloadable

  GROUP_BY_NONE     = 0
  GROUP_BY_CATEGORY = 1
  GROUP_BY_PROJECT  = 2

  PROJECT_CURRENT  = 0
  PROJECT_MINE     = 1
  PROJECT_ALL      = 2

  belongs_to :project

  attr_accessible :groupby

  def grouping?
    case groupby
    when GROUP_BY_CATEGORY
      return true
    when GROUP_BY_PROJECT
      return (project_scope != PROJECT_CURRENT)
    end
    false
  end

  def set_default!
    self['show_desc'] = false
    self['groupby'] = 1
    self['project_scope'] = 0
    self['sort_item_0'] = ''
    self['sort_item_1'] = ''
    self['sort_item_2'] = ''
  end

  def sort_params
    ary = []
    cnt = 0...3
    cnt.each do
      prm = self["sort_item_#{cnt}"]
      next unless prm && !prm.empty?
      case prm
      when 'project'
        next if (groupby == GROUP_BY_PROJECT) || (project_scope == PROJECT_CURRENT)
      when 'category'
        next if groupby == GROUP_BY_CATEGORY
      end
      ary << prm
    end
    ary.uniq
  end
end
