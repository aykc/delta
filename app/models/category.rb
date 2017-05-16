class Category < ApplicationRecord
  has_many :items
  validates :name, presence: true
  validates_associated :option_groups
  validates_associated :options
  before_save :prepare_options_to_save
  before_update :prepare_options_to_save

  def filter(attrs)
    # (" options -> '0144424b-d70b-4eed-a9fc-9008aecb37af' ->> 'value' = 'blue'
    # and options -> '326adcd0-8c1e-438a-bb52-5601d0e61073' ->> 'value' = 'medium' ")
    return items if attrs.blank?
    conditions = attrs.delete_if{|k, v| v.blank? or (v.is_a?(Hash) and (v['0'].blank? or v['1'].blank?)) }.map do |k, v|
      if v.is_a?(Hash) then
        "options -> '#{k}' ->> 'value' >= '#{v['0']}' and options -> '#{k}' ->> 'value' <= '#{v['1']}'"
      else
        "options -> '#{k}' ->> 'value' = '#{v}'"
      end
    end.join(' and ')
    items.where(conditions)
  end

  def option_groups
    @raw_options ||= read_attribute(:options).map{|index, opt|Option.new(opt)}
    groups = {}
    @raw_options.each do |option|
      groups[option.group_name] ||= Array.new
      groups[option.group_name] << option
    end
    @option_groups ||= groups.map do |name, options|
      g = OptionGroup.new(name: name)
      g.options = options
      g
    end
    @option_groups
  end

  def build_option_group(name = 'default')
    @option_groups ||= []
    grp = OptionGroup.new(name: name)
    grp.options = Option.new
    @option_groups << grp
    grp
  end

  def options
    option_groups.flat_map(&:options)
  end

  def option_groups_attributes=(attributes)
    @option_groups ||= []
    attributes.each do |index, attrs|
      next if '1' == attrs.delete("_destroy")
      @option_groups << OptionGroup.new(attrs)
    end
    # write_attribute(:options, prepare_options_to_save)
  end

  # private
    def prepare_options_to_save
      opts = {}
      generate_ids
      options.each do |option|
        option.validations['values'] = option.validations['values'].split(',').each{|item| item.strip!} if option.validations['values'].is_a?(String) and !option.validations['values'].blank?
        opts[option.id] = option
      end
      write_attribute(:options, opts)
    end

    def generate_ids
      options.each{|o| o.id = 0 if o.id.blank? }
      max = options.inject{|memo, o| memo.id > o.id ? memo : o }.id
      options.each do |o|
        if o.id.blank? or o.id == 0
          max = max + 1
          o.id = max
        end
      end
    end

end
