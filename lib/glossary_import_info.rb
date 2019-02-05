#
# glossary_import_info.rb
#
# Author : Mitsuyoshi Yoshida
# This program is freely distributable under the terms of an MIT-style license.
#

require 'i18n'

class GlossaryImportInfo
  attr_accessor :import_file
  attr_accessor :err_string

  def initialize(tbl)
    @import_file = tbl[:import_file]
  end

  def success?
    err_string ? false : true
  end
end

class CsvGlossaryImportInfo < GlossaryImportInfo
  attr_accessor :is_first_comment
  attr_reader :col_max
  attr_accessor :cat_num, :newterm_num, :upterm_num
  attr_writer :in_encoding

  def initialize(tbl)
    super(tbl)
    @is_first_comment = tbl[:is_first_comment]
    @in_encoding = tbl[:in_encoding]
    @colno_tbl = {}
    Term.import_params.each do |prm|
      prmcol = tbl["colno_#{prm}"]
      @colno_tbl[prmcol.to_i] = prm if prmcol && !prmcol.empty?
    end
    @col_max = @colno_tbl.keys.max
    @cat_num = 0
    @newterm_num = 0
    @upterm_num = 0
  end

  def in_encoding
    @in_encoding ? @in_encoding : 'UTF-8'
  end

  def col_param(colno)
    @colno_tbl[colno]
  end

  def param_col(prm)
    @colno_tbl.each do |key, val|
      return key	if val == prm
    end
    nil
  end

  def self.default_param_cols
    Term.import_params.each do |prm|
      yield prm, Term.export_params.index(prm)
    end
  end
end
