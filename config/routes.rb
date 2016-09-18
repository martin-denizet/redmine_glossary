RedmineApp::Application.routes.draw do
    match 'glossary_styles/search',
          to: 'glossary_styles#search',
          via: 'get'
    match 'glossary_styles/edit',
          to: 'glossary_styles#edit',
          via: 'patch'

    match 'projects/:project_id/glossary',
          :to => 'glossary#index',
          :via => 'get'
    match 'projects/:project_id/glossary/index_clear',
          :to => 'glossary#index_clear',
          :via => 'get'
    match 'projects/:project_id/glossary/new',
          :to => 'glossary#new',
          :via => [ :get, :post ]
    match 'projects/:project_id/glossary/preview',
          :to => 'glossary#preview',
          :via => [ :get, :post ]
    match 'projects/:project_id/glossary/:id',
          to: 'glossary#show',
          constraints: { id: /\d+/ },
          via: 'get'
    match 'projects/:project_id/glossary/:id/edit',
          to: 'glossary#edit',
          constraints: { id: /\d+/ },
          via: [ :get, :patch ]
    match 'projects/:project_id/glossary/:id/destroy',
          to: 'glossary#destroy',
          constraints: { id: /\d+/ },
          :via => 'delete'

    match 'projects/:project_id/glossary/import_csv',
          :to => 'glossary#import_csv',
          :via => 'get'
    match 'projects/:project_id/glossary/move_all',
          :to => 'glossary#move_all',
          :via => 'get'

    match 'projects/:project_id/term_categories',
          to: 'term_categories#index',
          via: 'get'
    match 'projects/:project_id/glossary/add_term_category',
          to: 'glossary#add_term_category',
          via: [ :get , :post ]
    match 'projects/:project_id/glossary/:id/add_term_category',
          to: 'glossary#add_term_category',
          constraints: { id: /\d+/ },
          via: [ :get , :post ]

    match 'projects/:project_id/term_categories/:id/edit',
          to: 'term_categories#edit',
          constraints: { id: /\d+/ },
          via: [ :get, :patch]
    match 'projects/:project_id/term_categories/:id/destroy',
          to: 'term_categories#destroy',
          constraints: { id: /\d+/ },
          via: [ :delete ]
    match 'projects/:project_id/term_categories/:id/change_order',
          to: 'term_categories#change_order',
          constraints: { id: /\d+/ },
          via: [ :post ]
end
