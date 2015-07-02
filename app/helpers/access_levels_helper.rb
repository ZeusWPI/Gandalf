module AccessLevelsHelper
  def visibility_icon(al)
    if al.hidden
      '<i class="glyphicon glyphicon-eye-open visibility"></i> Show'
    else
      '<i class="glyphicon glyphicon-eye-close visibility"></i> Hide'
    end
  end
end
