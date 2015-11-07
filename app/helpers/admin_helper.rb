module AdminHelper
  def admin_title title, sub_title=nil
    @title = title
    @sub_title = sub_title
  end

  def user_label user
    if user.admin?
      "<span class=\"label label-danger glyphicon glyphicon-sunglasses\">&nbsp;Admin</span>"
    elsif user.human?
      "<span class=\"label label-primary glyphicon glyphicon-user\">&nbsp;User</span>"
    else
      "<span class=\"label label-default glyphicon glyphicon-cloud\">&nbsp;Brain</span>"
    end
  end
end