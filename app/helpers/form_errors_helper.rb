module FormErrorsHelper
  def form_errors_for(object)
    return if object.errors.blank?

    content_tag(:div, class: 'form-errors') do
      concat(content_tag(:p, "Пожалуйста, исправьте следующие ошибки:"))
      concat(
        content_tag(:ul) do
          object.errors.full_messages.each do |msg|
            concat content_tag(:li, msg)
          end
        end
      )
    end
  end
end
