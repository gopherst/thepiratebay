class String
  def sanitize!
    gsub!(/\A[[:space:]]*(.*?)[[:space:]]*\z/) { $1 } rescue ""
  end
end