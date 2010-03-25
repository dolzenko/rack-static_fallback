File.open("../../README.md", "w") do |f|
  first_comment = []
  IO.read("static_fallback.rb").each_line do |l|
    if l =~ /\s*#/
      first_comment << l.sub(/^\s*#\s/, "").rstrip
    elsif !first_comment.empty?
      break
    end
  end
  f.write(first_comment.join("\n"))
end