require 'redmine'
require 'cgi'

module ActionView
  module Helpers
    module TermLinkHelper
      def term_link_new(name, proj)
        link_to(name + '?',
                { controller: 'glossary', action: 'new', project_id: proj,
                  new_term_name: CGI.escapeHTML(name) },
                class: 'new')
      end

      def term_link(term)
        str = link_to(term.name,
                      { controller: 'glossary',
                        action: 'show',
                        project_id: term.project,
                        id: term.id },
                      class: 'term-link')
        unless term.abbr_whole.empty?
          str = content_tag(:abbr, str, title: term.abbr_whole)
        end
        unless term.rubi.empty?
          str = content_tag(:ruby) do
            tstr = content_tag(:rb, str)
            tstr += content_tag(:rp, '(')
            tstr += content_tag(:rt, term.rubi)
            tstr + content_tag(:rp, ')')
          end
        end
        str
      end
    end
  end
end
