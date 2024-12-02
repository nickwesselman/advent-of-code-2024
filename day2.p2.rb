def is_safe (report)
  if !is_increasing(report) && !is_decreasing(report)
    return false
  end
  
  report.each.with_index do |level, index|
    if index == 0
      next
    end

    from_previous = (level - report[index-1]).abs
    if from_previous < 1 || from_previous > 3
      return false
    end
  end

  return true
end

def is_increasing (report)
  report.each.with_index do |level, index|
    if index == 0
      next
    elsif level < report[index-1]
      return false
    end
  end
  return true
end

def is_decreasing (report)
  report.each.with_index do |level, index|
    if index == 0
      next
    elsif level > report[index-1]
      return false
    end
  end
  return true
end


safe_reports = 0
File.open("day2.input.txt").read.each_line { |report_line|
  report = report_line.split(/\s/).map { |level| level.to_i }
  if is_safe(report)
    safe_reports += 1
  else
    (0..report.length).to_a.each do |index|
      tolerant_report = report.dup
      tolerant_report.delete_at(index)
      if is_safe(tolerant_report)
        safe_reports += 1
        break
      end
    end
  end
}

puts safe_reports