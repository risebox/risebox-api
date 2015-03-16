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
  def level_text level
    case level
    when 'none'
      'N/A'
    when 'ok'
      'OK'
    when 'low'
      'Trop bas'
    when 'high'
      'Trop haut'
    end
  end
end
