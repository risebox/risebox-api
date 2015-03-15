module ApplicationHelper
  def label_for_color color
    case color
    when 'grey'
      'warning'
    when 'green'
      'success'
    when 'red'
      'danger'
    end
  end
end
