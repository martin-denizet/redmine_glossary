RedmineApp::Application.routes.draw do
  match 'glossary_styles/search',
        to: 'glossary_styles#search',
        via: 'get'
  match 'glossary_styles/edit',
        to: 'glossary_styles#edit',
        via: 'patch'

  scope 'projects/:project_id' do
    match 'glossary',
          :to => 'glossary#index',
          :via => 'get'
    match 'glossary/index_clear',
          :to => 'glossary#index_clear',
          :via => 'get'
    match 'glossary/new',
          :to => 'glossary#new',
          :via => [ :get, :post ]
    match 'glossary/preview',
          :to => 'glossary#preview',
          :via => [ :get, :post, :patch ]
    match 'glossary/:id',
          to: 'glossary#show',
          constraints: { id: /\d+/ },
          via: 'get'
    match 'glossary/:id/edit',
          to: 'glossary#edit',
          constraints: { id: /\d+/ },
          via: [ :get, :patch ]
    match 'glossary/:id/destroy',
          to: 'glossary#destroy',
          constraints: { id: /\d+/ },
          via: [:post, :delete]

    match 'glossary/import_csv',
          to: 'glossary#import_csv',
          via: 'get'
    match 'glossary/import_csv_exec',
          to: 'glossary#import_csv_exec',
          via: 'post'
    match 'glossary/move_all',
          to: 'glossary#move_all',
          via: [:get, :post]

    match 'term_categories',
          to: 'term_categories#index',
          via: 'get'
    match 'glossary/add_term_category',
          to: 'glossary#add_term_category',
          via: [ :get , :post ]
    match 'term_categories/:id/edit',
          to: 'term_categories#edit',
          constraints: { id: /\d+/ },
          via: [ :get, :patch]
    match 'term_categories/:id/destroy',
          to: 'term_categories#destroy',
          constraints: { id: /\d+/ },
          via: [ :post, :delete ]
    match 'term_categories/:id/change_order',
          to: 'term_categories#change_order',
          constraints: { id: /\d+/ },
          via: [ :post ]
  end
end
