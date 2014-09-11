module ApplicationHelper

  def parsed
    JSON.parse($redis.get("data"))
  end

  def cleanup(string)
    string = string.delete("?").delete("'").delete(",")
    string.gsub!(" ","-")
    string
  end


end
