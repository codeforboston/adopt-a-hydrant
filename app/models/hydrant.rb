class Hydrant < Thing
  # Indicates the state of this hydrant
  def indicator_and_color(current_user, event_type_id, trigger, hours)
    ic = {:color => 'green', :indicator => 'hydrant'}
    if adopted?
      if !action_happened?(event_type_id, trigger, hours)
        ic[:color] = 'red'
      end
      ic[:indicator] = 'my_hydrant' if my_thing?(current_user)
    else
      ic[:color] = 'yellow'
    end
    ic
  end
end