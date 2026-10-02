function duration = computeComponentDuration(comp, quantity)

switch comp.duration_model
    case 'linear'
        duration = comp.per_unit_time * quantity;
    case 'fixed'
        duration = comp.vendor_lead_time;
    case 'hybrid'
        linear_time = comp.per_unit_time * quantity;
        duration = min(linear_time, comp.vendor_lead_time);
    otherwise
        error('Unknown duration model');
end

end
