class Item < ApplicationRecord
  belongs_to :category
  delegate :options, to: :category, prefix: :category
  # delegate :option_groups, to: :category
  # delegate :option_groups_attributes=, to: :category
  attr_accessor :option_groups, :options
  before_save :prepare_options_to_save
  # after_initialize :options

  def option_groups
    groups = {}
    options.each do |option|
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

  def options
    options = category_options.map(&:dup)
    opts = read_attribute(:options)
    options.each{|o| opts.each{|k, v| o.value = v['value'] if k.to_i == o.id.to_i }}
    # write_attribute :options, options
  end

  def options_attributes=(attributes)
    options.each{|o| attributes.each{|k, v| o.value = v['value'] if v['id'].to_i == o.id.to_i }}
    # write_attribute(:options, options)
  end

  def prepare_options_to_save
    opts = {}
    options.each{ |o| opts[o.id] = { value: o.value } }
    write_attribute(:options, opts)
  end
end
