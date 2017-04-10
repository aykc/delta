module ApplicationHelper
  def link_to_add_option(name, f, association)
    new_object = f.object.send("build_#{association.to_s.singularize}")
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize, f: builder)
    end
    link_to(name, '#', class: 'add_option', data:{id: id, fields: fields.gsub("\n", '')})
  end
end
