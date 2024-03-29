# frozen_string_literal: true

module AccessLevelsHelper
  def visibility_icon(access_level)
    if access_level.hidden
      '<i class="glyphicon glyphicon-eye-open visibility"></i> Show'
    else
      '<i class="glyphicon glyphicon-eye-close visibility"></i> Hide'
    end
  end

  def translate(permit, _options = {})
    translations = {
      enrolled: 'FK-members'
    }
    translations[permit.to_sym] || permit
  end
end
