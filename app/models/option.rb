class Option
  include ActiveModel::Model
  attr_accessor :id, :name, :value, :group_name, :option_type, :validations
  validates :name, :group_name, presence: true


  def initialize(attr = nil)
    attr = ActiveSupport::HashWithIndifferentAccess.new(attr)
    @id = attr['id']
    @name = attr['name']
    @option_type = attr['option_type']
    @value = attr['value']
    @group_name = attr['group_name']
    @validations = attr['validations']
  end

  def persisted?() false; end
  def new_record?() false; end
  def marked_for_destruction?() false; end
  def _destroy() false; end

  # def attributes
  #   {name: @name, value: @value, group_name: @group_name}
  # end
end