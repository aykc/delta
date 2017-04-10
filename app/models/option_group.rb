class OptionGroup
  include ActiveModel::Model
  attr_accessor :name, :options
  validates :name, presence: true

  def options=(opts)
    if opts.respond_to? 'map'
      @options = opts.map {|opt| opt.group_name = name; opt}
    else
      opts.group_name = name
      @options = [opts]
    end
    @options
  end

  def build_option(attr = {})
    @options ||= []
    attr['group_name'] = name
    opt = Option.new(attr)
    options << opt
    opt
  end

  def options_attributes=(attributes)
    opts = []
    attributes.each do |index, attrs|
      next if '1' == attrs.delete("_destroy")
      attrs['id'] = SecureRandom.uuid if attrs['id'].blank?
      opts<< Option.new(attrs)
    end
    self.options = opts
  end

  def persisted?() false; end
  def new_record?() false; end
  def marked_for_destruction?() false; end
  def _destroy() false; end
end