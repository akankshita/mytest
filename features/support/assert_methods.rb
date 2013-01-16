def assert_true(error_message = "Something failed")
   if(!yield)
    raise Exception.new("Step failure: #{error_message}")
  end
end

def assert_false(error_message = "something failed")
  if(yield)
    raise Exception.new("Step failure: #{error_message}")
  end
end

def assert_saved (record)
  if(!record.save)
    all_errors = String.new
    record.errors.each {|k, v| all_errors += "#{k.capitalize}: #{v}"}
    raise Exception.new("Save of #{record.class} failed with errors: #{all_errors}")
  end
end