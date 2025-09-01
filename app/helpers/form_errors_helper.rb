module FormErrorsHelper
  def form_errors_for(*objects_or_errors)
    items = objects_or_errors.flatten.compact

    all_errors = items.flat_map do |item|
      if item.respond_to?(:errors)
        item.errors.full_messages
      elsif item.is_a?(Array)
        item
      else
        []
      end
    end.uniq

    return if all_errors.blank?

    content_tag(:div, class: 'form-errors') do
      concat content_tag(:p, 'Пожалуйста, исправьте следующие ошибки:')
      concat(
        content_tag(:ul) do
          all_errors.each do |msg|
            concat content_tag(:li, msg)
          end
        end
      )
    end
  end
end
