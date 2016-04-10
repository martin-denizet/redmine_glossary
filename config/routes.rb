RedmineApp::Application.routes.draw do
    match 'glossary_styles/:action', :controller => :glossary_styles, :via => [ :get, :post, :put, :patch ]

    match 'projects/:project_id/glossary', :to => 'glossary#index', :via => [ :get ]
    match 'projects/:project_id/glossary/new', :to => 'glossary#new', :via => [ :get ]
    match 'projects/:project_id/glossary/edit', :to => 'glossary#edit', :via => [ :get, :post, :patch ]
    match 'projects/:project_id/glossary/:id/edit', :to => 'glossary#edit', :id => /\d+/, :via => [ :get, :post, :patch ]
    match 'projects/:project_id/glossary/:id/:action', :controller => :glossary, :id => /\d+/, :via => :all
    match 'projects/:project_id/glossary/:id', :to => 'glossary#show', :id => /\d+/, :via => [ :get ]
    match 'projects/:project_id/glossary/destroy', :to => 'glossary#destroy', :via => [ :delete ]
    match 'projects/:project_id/glossary/:action', :controller => :glossary, :via => :all

    match 'projects/:project_id/term_categories', :to => 'term_categories#index', :via => :all
    match 'projects/:project_id/term_categories/destroy', :to => 'term_categories#destroy', :via => [ :delete ]
    match 'projects/:project_id/term_categories/change_order', :to => 'term_categories#change_order', :via => [ :post ]
    match 'projects/:project_id/term_categories/:action', :controller => :term_categories, :via => :all
    match 'projects/:project_id/term_categories/:id/:action', :controller => :term_categories, :id => /\d+/, :via => :all
end

