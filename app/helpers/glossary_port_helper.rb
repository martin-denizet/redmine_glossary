module GlossaryPortHelper
  # def glossary_csvout(csv, ic, ary)
  def glossary_csvout(csv, ary)
    csv << ary.collect do |c|
      begin
        # ic.iconv(c.to_s)
        Redmine::CodesetUtil.from_utf8(c.to_s, l(:general_csv_encoding))
      rescue StandardError
        c.to_s
      end
    end
  end

  def glossary_to_csv(terms)
    # ic = Iconv.new(l(:general_csv_encoding), 'UTF-8')
    export = FCSV.generate(col_sep: l(:general_csv_separator)) do |csv|
      # csv header fields
      headers = Term.export_params.collect do |prm|
        label_param(prm)
      end

      # glossary_csvout(csv, ic, headers)
      glossary_csvout(csv, headers)

      # csv lines
      terms.each do |term|
        fields = Term.export_params.collect do |prm|
          term.param_to_s(prm)
        end
        # glossary_csvout(csv, ic, fields)
        glossary_csvout(csv, fields)
      end
    end
    export
  end

  def glossary_from_csv(portinfo, projid)
    line_count = 0
    begin
      # ic = Iconv.new('UTF-8', portinfo.in_encoding)

      raise l(:error_file_none)	unless portinfo.import_file
      FCSV.parse(portinfo.import_file.read) do |row|
        line_count += 1
        next	if portinfo.is_first_comment && (line_count == 1)
        next	if row.empty?

        name = row[portinfo.param_col('name')]
        raise format(l(:error_no_name), t('label.name'))	unless name

        # name = ic.iconv(name)
        name = Redmine::CodesetUtil.to_utf8(name, portinfo.in_encoding)
        term = Term.find_by(project_id: projid, name: name)
        if term
          portinfo.upterm_num += 1
        else
          term = Term.new(name: name, project_id: projid)
          portinfo.newterm_num += 1
        end

        for col in 0...row.size
          prm = portinfo.col_param(col)
          next	unless prm
          # val = ic.iconv(row[col].to_s)
          val = Redmine::CodesetUtil.to_utf8(row[col].to_s, portinfo.in_encoding)
          case prm
          when 'name'
          when 'category'
            unless val.empty?
              cat = TermCategory.find_by_name(val)
              unless cat
                cat = TermCategory.new(name: val, project_id: projid)
                raise l(:error_create_term_category) unless cat.save
                portinfo.cat_num += 1
              end
              term['category_id'] = cat.id
            end
          else
            term[prm] = val
          end
        end
        raise l(:error_create_term) unless term.save
      end
    rescue StandardError => evar
      portinfo.err_string = evar.to_s
      if line_count > 0
        portinfo.err_string += format(l(:error_csv_import_row), line_count)
      end
    end
  end
end
