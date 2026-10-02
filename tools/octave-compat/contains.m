function tf = contains(str, pattern)
  tf = ~isempty(strfind(str, pattern));
end
