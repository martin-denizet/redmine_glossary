module GlossaryStylesHelper
  def retrieve_glossary_style
    if User.current.anonymous?
      if session[:glossary_style]
        @glossary_style = GlossaryStyle.new(session[:glossary_style])
      end
    else
      @glossary_style = if !params[:glossary_style_id].blank?
                          GlossaryStyle.find_by(params[:glossary_style_id])
                        else
                          GlossaryStyle.find_by(user_id: User.current.id)
                        end
    end

    unless @glossary_style
      @glossary_style = GlossaryStyle.new(groupby: GlossaryStyle::GroupByCategory)
      @glossary_style.user_id = User.current.id
    end
  end

  def search_index_table(ary, sepcnt, proj, search_index_type = nil)
    return ''	if !ary.is_a?(Array) || (sepcnt <= 0)
    str = '<table><tr>'
    cnt = 0
    for ch in ary
      str += '</tr><tr>'	if (cnt != 0) && (cnt % sepcnt).zero?
      cnt += 1
      str += '<td>'
      if ch && !ch.empty?
        prms = { controller: 'glossary', action: 'index', project_id: proj,
                 search_index_ch: ch }
        prms[:search_index_type] = search_index_type	if search_index_type
        str += link_to(ch, prms)
      end
      str += '</td>'
    end
    str += '</tr></table>'
    str.html_safe
  end

  def search_params
    %i[search_str search_category latest_days]
  end

  def search_params_all
    search_params + %i[search_index_ch search_index_type]
  end

  def add_search_params(prms)
    search_params_all.each do |prm|
      prms[prm] = params[prm]	if params[prm] && !params[prm].empty?
    end
  end

  def glossary_searching?
    search_params.each do |prm|
      return true	if params[prm] && !params[prm].empty?
    end
    false
  end

  def authorized_projects(projscope, curproj, authcnd)
    ary = []
    case projscope
    when GlossaryStyle::ProjectCurrent
      return [curproj]
    when GlossaryStyle::ProjectMine
      ary = User.current.memberships.collect(&:project).compact.uniq
    when GlossaryStyle::ProjectAll
      ary = Project.visible.all
    end
    ary.find_all do |proj|
      User.current.allowed_to?(authcnd, proj)
    end
  end

  def break_categories(cats)
    catstrs = []
    cats.each do |cat|
      catstrs << cat.name
      next unless cat.name.include?('/')
      str = cat.name
      while str =~ /^(.+)\/[^\/]+$/
        str = Regexp.last_match(1)
        catstrs << str
      end
    end
    catstrs
  end

  def seach_category_options(projscope, curproj)
    options = ['']
    projs = authorized_projects(projscope, curproj, controller: :glossary, action: :index)
    unless projs.empty?
      querystr = projs.collect { |proj| "project_id = #{proj.id}" }.join(' OR ')
      options += break_categories(TermCategory.where(querystr)).sort.uniq
    end
    options << "(#{l(:label_not_categorized)})"
  end
end
